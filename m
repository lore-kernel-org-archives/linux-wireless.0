Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62569 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2EHJXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 05:23:12 -0400
Received: by qadb17 with SMTP id b17so285256qad.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 02:23:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfdHiCMo6Ro1BVRen1qbFQAhd0cGKWk2ZSsFeHG01eZxig@mail.gmail.com>
References: <1319350901-31178-1-git-send-email-arik@wizery.com>
	<4EA7DA0F.7050603@sipsolutions.net>
	<CA+XVXff+4SLy6y2xbDONDOg_j9CNYd1rkLgtdvHEKpprBW5zog@mail.gmail.com>
	<CAFED-jku-zGtTvYwGpwCastRJZAfQf9uyJAeqtevGVRn22Qygg@mail.gmail.com>
	<1336392314.4325.26.camel@jlt3.sipsolutions.net>
	<CA+XVXfdHiCMo6Ro1BVRen1qbFQAhd0cGKWk2ZSsFeHG01eZxig@mail.gmail.com>
Date: Tue, 8 May 2012 11:23:11 +0200
Message-ID: <CAFED-jk73hMn-ryTPgP4tpowZEXa1SL4XWbjrX43mpR7kQ0CKA@mail.gmail.com> (sfid-20120508_112316_720130_71F7FBE2)
Subject: Re: [PATCH] mac80211: support adding IV-room in the skb for CCMP keys
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/5/7 Arik Nemtsov <arik@wizery.com>:
> On Mon, May 7, 2012 at 3:05 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Mon, 2012-05-07 at 14:01 +0200, Janusz Dziedzic wrote:
>>> 2011/10/26 Arik Nemtsov <arik@wizery.com>:
>>> > On Wed, Oct 26, 2011 at 11:59, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> >> On 10/23/2011 8:21 AM, Arik Nemtsov wrote:
>>> >>>
>>> >>> Some cards can generate CCMP IVs in HW, but require the space for the IV
>>> >>> to be pre-allocated in the frame at the correct offset. Add a key flag
>>> >>> that allows us to achieve this.
>>> >>
>>> >> Is it really that expensive to generate the IV and then not use it that this
>>> >> is worth the extra complexity? This not just makes it more complex but also
>>> >> more expensive in the other case.
>>> >>
>>> >
>>> > Some of the platforms with this chip are pretty weak (host CPU is the
>>> > bottleneck).
>>> >
>>> > We add another "if" for the other case (for a value that's likely in
>>> > the cacheline already). I don't think that's too bad.
>>> >
>>>
>>> Hello,
>>> Why this is only done for CCMP?
>>> Our firmware require such IVs allocation for all modes and currently
>>> we have common code that do that in the driver based on:
>>> iv_len = tx_info->control.hw_key->iv_len
>>> icv_len = tx_info->control.hw_key->icv_len
>>>
>>> /* cw1200 driver */
>>> skb_push(t->skb, iv_len);
>>> memmove(newhdr, newhdr + iv_len, t->hdrlen);
>>> skb_put(t->skb, icv_len);
>>> ....
>>>
>>> Isn't better to handle all modes in mac80211 base on
>>> IEEE80211_KEY_FLAG_PUT_IV_SPACE or just leave this for the driver?
>>>
>>> I know this is easy to fix in our driver but still we have to remember
>>> that in case of CCMP mac80211 will already do it for us and will not
>>> do that in case of other modes.
>>> So, my proposal is to remove all changes from net/mac80211/wpa.c file
>>> and remember that driver should care about it - in such case
>>> PUT_IV_SPACE will be more generic.
>>
>> I suggest the opposite, make it more generic in mac80211.
>
> I agree with Johannes - it's better to do it in mac80211 and be aware
> of the extra tailroom requirement when allocating the skb.
>
> The wl12xx card only needs this for CCMP, you're welcome to extend
> this to other modes. But please make sure to allow selecting specific
> modes, not just all or nothing.
>

Patch proposal:
Verified with cw1200 + WEP, TKIP, CCMP.
As I understand correctly selection (PUT_IV_SPACE flag) will be done
in set_key() driver callback, so driver could select if need this
based on cipher param.

---
 include/net/mac80211.h |    2 +-
 net/mac80211/wep.c     |   14 +++++++++++---
 net/mac80211/wpa.c     |    8 +++++++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 965eca8..853ad85 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -939,7 +939,7 @@ static inline bool ieee80211_vif_is_mesh(struct
ieee80211_vif *vif)
  *	CCMP key if it requires CCMP encryption of management frames (MFP) to
  *	be done in software.
  * @IEEE80211_KEY_FLAG_PUT_IV_SPACE: This flag should be set by the driver
- *	for a CCMP key if space should be prepared for the IV, but the IV
+ *	if space should be prepared for the IV, but the IV
  *	itself should not be generated. Do not set together with
  *	@IEEE80211_KEY_FLAG_GENERATE_IV on the same key.
  */
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 7aa31bb..e904401 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -92,6 +92,7 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 				int keylen, int keyidx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	unsigned int hdrlen;
 	u8 *newhdr;

@@ -104,6 +105,12 @@ static u8 *ieee80211_wep_add_iv(struct
ieee80211_local *local,
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	newhdr = skb_push(skb, WEP_IV_LEN);
 	memmove(newhdr, newhdr + WEP_IV_LEN, hdrlen);
+
+	/* the HW only needs room for the IV, but not the actual IV */
+	if (info->control.hw_key &&
+	    (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE))
+		return newhdr + hdrlen;
+
 	ieee80211_wep_get_iv(local, keylen, keyidx, newhdr + hdrlen);
 	return newhdr + hdrlen;
 }
@@ -313,14 +320,15 @@ ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
 static int wep_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_key_conf *hw_key = info->control.hw_key;

-	if (!info->control.hw_key) {
+	if (!hw_key) {
 		if (ieee80211_wep_encrypt(tx->local, skb, tx->key->conf.key,
 					  tx->key->conf.keylen,
 					  tx->key->conf.keyidx))
 			return -1;
-	} else if (info->control.hw_key->flags &
-			IEEE80211_KEY_FLAG_GENERATE_IV) {
+	} else if ((hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
+		   (hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
 		if (!ieee80211_wep_add_iv(tx->local, skb,
 					  tx->key->conf.keylen,
 					  tx->key->conf.keyidx))
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 0ae23c6..4d05ad9 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -183,7 +183,8 @@ static int tkip_encrypt_skb(struct
ieee80211_tx_data *tx, struct sk_buff *skb)
 	u8 *pos;

 	if (info->control.hw_key &&
-	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
 		/* hwaccel - with no need for software-generated IV */
 		return 0;
 	}
@@ -204,6 +205,11 @@ static int tkip_encrypt_skb(struct
ieee80211_tx_data *tx, struct sk_buff *skb)
 	memmove(pos, pos + TKIP_IV_LEN, hdrlen);
 	pos += hdrlen;

+	/* the HW only needs room for the IV, but not the actual IV */
+	if (info->control.hw_key &&
+	    (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE))
+		return 0;
+
 	/* Increase IV for the frame */
 	spin_lock_irqsave(&key->u.tkip.txlock, flags);
 	key->u.tkip.tx.iv16++;
-- 
1.7.0.4

BR
Janusz
