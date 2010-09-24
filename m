Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59287 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302Ab0IXWWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 18:22:10 -0400
Message-ID: <4C9D2487.5040202@candelatech.com>
Date: Fri, 24 Sep 2010 15:21:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [wireless] wireless:  Keep phy name consistent across module
 reloads.
References: <1285113431-25526-1-git-send-email-greearb@candelatech.com>	 <1285362170.11036.1.camel@jlt3.sipsolutions.net>	 <4C9D13AC.4080308@candelatech.com>	 <1285363135.11036.7.camel@jlt3.sipsolutions.net>	 <4C9D1760.3040103@candelatech.com> <1285363861.11036.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285363861.11036.8.camel@jlt3.sipsolutions.net>
Content-Type: multipart/mixed;
 boundary="------------040401030209030304090404"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040401030209030304090404
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/24/2010 02:31 PM, Johannes Berg wrote:
> On Fri, 2010-09-24 at 14:25 -0700, Ben Greear wrote:
>
>>> Actually, right now it doesn't even allow you to use a "phy%d" name,
>>> which is because I don't want (sysfs, debugfs) errors coming from doing
>>> "iw phy0 set name phy1" and then plugging in a new device ... In doing
>>> that, I manage to avoid having to allocate two different numbers...
>>
>> I tried rename few months ago, to rename back to phy0, and it failed
>> for no obvious reason..so I just assumed rename didn't work at all.
>> Would you like a patch to print something in kernel logs when someone
>> tries to rename to phy%d?
>
> Well, if you want to work on getting an unused phy%d name this would be
> kinda pointless, no?
>
>>> I suppose it'd be possible to treat this more like interfaces. Want to
>>> also make it per net namespace? ;-)
>>
>> Probably best for all involved if I don't mess with namespaces right now,
>> but I'll be happy to work on (or test) a patch to find the first un-used phyX name,
>> if that's what you mean.
>
> I think that'd be OK, even if maybe at this point a little unexpected?

Here's a patch for consideration.  It's on top of my other patch,
but I can re-do it against a tree with that reverted if you prefer.

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8226ba7..312a44b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -319,9 +319,12 @@ static void cfg80211_event_work(struct work_struct *work)

  struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
  {
+	static int wiphy_counter;
  	int i;
-	struct cfg80211_registered_device *rdev;
+	struct cfg80211_registered_device *rdev, *rdev2;
  	int alloc_size;
+	char nname[IFNAMSIZ + 1];
+	bool found = false;

  	WARN_ON(ops->add_key && (!ops->del_key || !ops->set_default_key));
  	WARN_ON(ops->auth && (!ops->assoc || !ops->deauth || !ops->disassoc));
@@ -341,26 +344,38 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)

  	mutex_lock(&cfg80211_mutex);

+	rdev->wiphy_idx = wiphy_counter++;
+
+	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx)))
+		goto too_many_devs;
+
  	/* 64k wiphy devices is enough for anyone! */
  	for (i = 0; i < 0xFFFF; i++) {
-		if (!cfg80211_rdev_by_wiphy_idx(i))
+		found = false;
+		snprintf(nname, sizeof(nname)-1, PHY_NAME "%d", i);
+		nname[sizeof(nname)-1] = 0;
+		list_for_each_entry(rdev2, &cfg80211_rdev_list, list)
+			if (strcmp(nname, dev_name(&rdev2->wiphy.dev)) == 0) {
+				found = true;
+				break;
+			}
+
+		if (!found)
  			break;
  	}
-	if (i == 0xFFFF)
-		i = -1; /* invalid */
-	rdev->wiphy_idx = i;

-	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx))) {
+	if (unlikely(found)) {
+too_many_devs:
  		mutex_unlock(&cfg80211_mutex);
  		/* ugh, too many devices already! */
  		kfree(rdev);
  		return NULL;
  	}

-	mutex_unlock(&cfg80211_mutex);
-
  	/* give it a proper name */
-	dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
+	dev_set_name(&rdev->wiphy.dev, "%s", nname);
+
+	mutex_unlock(&cfg80211_mutex);

  	mutex_init(&rdev->mtx);
  	mutex_init(&rdev->devlist_mtx);


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


--------------040401030209030304090404
Content-Type: text/plain;
 name="phy_name.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="phy_name.patch"

ZGlmZiAtLWdpdCBhL25ldC93aXJlbGVzcy9jb3JlLmMgYi9uZXQvd2lyZWxlc3MvY29yZS5j
CmluZGV4IDgyMjZiYTcuLjMxMmE0NGIgMTAwNjQ0Ci0tLSBhL25ldC93aXJlbGVzcy9jb3Jl
LmMKKysrIGIvbmV0L3dpcmVsZXNzL2NvcmUuYwpAQCAtMzE5LDkgKzMxOSwxMiBAQCBzdGF0
aWMgdm9pZCBjZmc4MDIxMV9ldmVudF93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykK
IAogc3RydWN0IHdpcGh5ICp3aXBoeV9uZXcoY29uc3Qgc3RydWN0IGNmZzgwMjExX29wcyAq
b3BzLCBpbnQgc2l6ZW9mX3ByaXYpCiB7CisJc3RhdGljIGludCB3aXBoeV9jb3VudGVyOwog
CWludCBpOwotCXN0cnVjdCBjZmc4MDIxMV9yZWdpc3RlcmVkX2RldmljZSAqcmRldjsKKwlz
dHJ1Y3QgY2ZnODAyMTFfcmVnaXN0ZXJlZF9kZXZpY2UgKnJkZXYsICpyZGV2MjsKIAlpbnQg
YWxsb2Nfc2l6ZTsKKwljaGFyIG5uYW1lW0lGTkFNU0laICsgMV07CisJYm9vbCBmb3VuZCA9
IGZhbHNlOwogCiAJV0FSTl9PTihvcHMtPmFkZF9rZXkgJiYgKCFvcHMtPmRlbF9rZXkgfHwg
IW9wcy0+c2V0X2RlZmF1bHRfa2V5KSk7CiAJV0FSTl9PTihvcHMtPmF1dGggJiYgKCFvcHMt
PmFzc29jIHx8ICFvcHMtPmRlYXV0aCB8fCAhb3BzLT5kaXNhc3NvYykpOwpAQCAtMzQxLDI2
ICszNDQsMzggQEAgc3RydWN0IHdpcGh5ICp3aXBoeV9uZXcoY29uc3Qgc3RydWN0IGNmZzgw
MjExX29wcyAqb3BzLCBpbnQgc2l6ZW9mX3ByaXYpCiAKIAltdXRleF9sb2NrKCZjZmc4MDIx
MV9tdXRleCk7CiAKKwlyZGV2LT53aXBoeV9pZHggPSB3aXBoeV9jb3VudGVyKys7CisKKwlp
ZiAodW5saWtlbHkoIXdpcGh5X2lkeF92YWxpZChyZGV2LT53aXBoeV9pZHgpKSkKKwkJZ290
byB0b29fbWFueV9kZXZzOworCiAJLyogNjRrIHdpcGh5IGRldmljZXMgaXMgZW5vdWdoIGZv
ciBhbnlvbmUhICovCiAJZm9yIChpID0gMDsgaSA8IDB4RkZGRjsgaSsrKSB7Ci0JCWlmICgh
Y2ZnODAyMTFfcmRldl9ieV93aXBoeV9pZHgoaSkpCisJCWZvdW5kID0gZmFsc2U7CisJCXNu
cHJpbnRmKG5uYW1lLCBzaXplb2Yobm5hbWUpLTEsIFBIWV9OQU1FICIlZCIsIGkpOworCQlu
bmFtZVtzaXplb2Yobm5hbWUpLTFdID0gMDsKKwkJbGlzdF9mb3JfZWFjaF9lbnRyeShyZGV2
MiwgJmNmZzgwMjExX3JkZXZfbGlzdCwgbGlzdCkKKwkJCWlmIChzdHJjbXAobm5hbWUsIGRl
dl9uYW1lKCZyZGV2Mi0+d2lwaHkuZGV2KSkgPT0gMCkgeworCQkJCWZvdW5kID0gdHJ1ZTsK
KwkJCQlicmVhazsKKwkJCX0KKworCQlpZiAoIWZvdW5kKQogCQkJYnJlYWs7CiAJfQotCWlm
IChpID09IDB4RkZGRikKLQkJaSA9IC0xOyAvKiBpbnZhbGlkICovCi0JcmRldi0+d2lwaHlf
aWR4ID0gaTsKIAotCWlmICh1bmxpa2VseSghd2lwaHlfaWR4X3ZhbGlkKHJkZXYtPndpcGh5
X2lkeCkpKSB7CisJaWYgKHVubGlrZWx5KGZvdW5kKSkgewordG9vX21hbnlfZGV2czoKIAkJ
bXV0ZXhfdW5sb2NrKCZjZmc4MDIxMV9tdXRleCk7CiAJCS8qIHVnaCwgdG9vIG1hbnkgZGV2
aWNlcyBhbHJlYWR5ISAqLwogCQlrZnJlZShyZGV2KTsKIAkJcmV0dXJuIE5VTEw7CiAJfQog
Ci0JbXV0ZXhfdW5sb2NrKCZjZmc4MDIxMV9tdXRleCk7Ci0KIAkvKiBnaXZlIGl0IGEgcHJv
cGVyIG5hbWUgKi8KLQlkZXZfc2V0X25hbWUoJnJkZXYtPndpcGh5LmRldiwgUEhZX05BTUUg
IiVkIiwgcmRldi0+d2lwaHlfaWR4KTsKKwlkZXZfc2V0X25hbWUoJnJkZXYtPndpcGh5LmRl
diwgIiVzIiwgbm5hbWUpOworCisJbXV0ZXhfdW5sb2NrKCZjZmc4MDIxMV9tdXRleCk7CiAK
IAltdXRleF9pbml0KCZyZGV2LT5tdHgpOwogCW11dGV4X2luaXQoJnJkZXYtPmRldmxpc3Rf
bXR4KTsK
--------------040401030209030304090404--
