Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:38550 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbbI2WAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 18:00:44 -0400
Received: by igxx6 with SMTP id x6so17616625igx.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2015 15:00:43 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Sep 2015 15:00:43 -0700
Message-ID: <CAH7ZN-w6UPkjvDsUUzJqLZEip6f4UXgbh9oFsRMwq3woCvcEDQ@mail.gmail.com> (sfid-20150930_000048_466876_6BAF087A)
Subject: [PATCH] nl80211: report age of bss entry from boot in microseconds
From: Dmitry Shmidt <dimitrysh@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: multipart/mixed; boundary=089e0122a3fa04f5470520e9f2dc
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--089e0122a3fa04f5470520e9f2dc
Content-Type: text/plain; charset=UTF-8

    User-space needs to know real time from boot (including suspend)
    of bss entry for location and connectivity services.

Change-Id: I7d5db4378d7941ccecf8ac675425024c2aafe62b
Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
---
 include/uapi/linux/nl80211.h | 2 ++
 net/wireless/core.h          | 1 +
 net/wireless/nl80211.c       | 3 ++-
 net/wireless/scan.c          | 3 +++
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c0ab6b0..173b6a5 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3364,6 +3364,7 @@ enum nl80211_bss_scan_width {
  * (not present if no beacon frame has been received yet)
  * @NL80211_BSS_PRESP_DATA: the data in @NL80211_BSS_INFORMATION_ELEMENTS and
  * @NL80211_BSS_TSF is known to be from a probe response (flag attribute)
+ * @NL80211_BSS_LAST_SEEN_BOOTTIME: age of this BSS entry in us from boot
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -3383,6 +3384,7 @@ enum nl80211_bss {
  NL80211_BSS_CHAN_WIDTH,
  NL80211_BSS_BEACON_TSF,
  NL80211_BSS_PRESP_DATA,
+ NL80211_BSS_LAST_SEEN_BOOTTIME,

  /* keep last */
  __NL80211_BSS_AFTER_LAST,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b9d5bc8..261e159 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -140,6 +140,7 @@ struct cfg80211_internal_bss {
  unsigned long ts;
  unsigned long refcount;
  atomic_t hold;
+ u64 tfb;

  /* must be last because of priv member */
  struct cfg80211_bss pub;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f05ba8b..a9ed2da 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6602,7 +6602,8 @@ static int nl80211_send_bss(struct sk_buff *msg,
struct netlink_callback *cb,
     nla_put_u32(msg, NL80211_BSS_FREQUENCY, res->channel->center_freq) ||
     nla_put_u32(msg, NL80211_BSS_CHAN_WIDTH, res->scan_width) ||
     nla_put_u32(msg, NL80211_BSS_SEEN_MS_AGO,
- jiffies_to_msecs(jiffies - intbss->ts)))
+ jiffies_to_msecs(jiffies - intbss->ts)) ||
+    nla_put_u64(msg, NL80211_BSS_LAST_SEEN_BOOTTIME, intbss->tfb))
  goto nla_put_failure;

  switch (rdev->wiphy.signal_type) {
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 3a50aa2..275cc92 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -749,10 +749,12 @@ cfg80211_bss_update(struct
cfg80211_registered_device *rdev,
     bool signal_valid)
 {
  struct cfg80211_internal_bss *found = NULL;
+ struct timespec tfb;

  if (WARN_ON(!tmp->pub.channel))
  return NULL;

+ get_monotonic_boottime(&tfb);
  tmp->ts = jiffies;

  spin_lock_bh(&rdev->bss_lock);
@@ -895,6 +897,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
  found = new;
  }

+ found->tfb = (u64)(timespec_to_ns(&tfb) / 1000);
  rdev->bss_generation++;
  bss_ref_get(rdev, found);
  spin_unlock_bh(&rdev->bss_lock);
-- 
2.6.0.rc2.230.g3dd15c0

--089e0122a3fa04f5470520e9f2dc
Content-Type: application/octet-stream;
	name="0001-nl80211-report-age-of-bss-entry-from-boot-in-microse.patch"
Content-Disposition: attachment;
	filename="0001-nl80211-report-age-of-bss-entry-from-boot-in-microse.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_if5wr2be0

RnJvbSA0ZWNhMDdlNjYzODdkMmVjY2YzYzhmMTRiMmQ5M2U5ZjFjYWYyODZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEbWl0cnkgU2htaWR0IDxkaW1pdHJ5c2hAZ29vZ2xlLmNvbT4K
RGF0ZTogVHVlLCAyOSBTZXAgMjAxNSAxMzo1NDozMCAtMDcwMApTdWJqZWN0OiBbUEFUQ0hdIG5s
ODAyMTE6IHJlcG9ydCBhZ2Ugb2YgYnNzIGVudHJ5IGZyb20gYm9vdCBpbiBtaWNyb3NlY29uZHMK
CiAgICBVc2VyLXNwYWNlIG5lZWRzIHRvIGtub3cgcmVhbCB0aW1lIGZyb20gYm9vdCAoaW5jbHVk
aW5nIHN1c3BlbmQpCiAgICBvZiBic3MgZW50cnkgZm9yIGxvY2F0aW9uIGFuZCBjb25uZWN0aXZp
dHkgc2VydmljZXMuCgpDaGFuZ2UtSWQ6IEk3ZDVkYjQzNzhkNzk0MWNjZWNmOGFjNjc1NDI1MDI0
YzJhYWZlNjJiClNpZ25lZC1vZmYtYnk6IERtaXRyeSBTaG1pZHQgPGRpbWl0cnlzaEBnb29nbGUu
Y29tPgotLS0KIGluY2x1ZGUvdWFwaS9saW51eC9ubDgwMjExLmggfCAyICsrCiBuZXQvd2lyZWxl
c3MvY29yZS5oICAgICAgICAgIHwgMSArCiBuZXQvd2lyZWxlc3Mvbmw4MDIxMS5jICAgICAgIHwg
MyArKy0KIG5ldC93aXJlbGVzcy9zY2FuLmMgICAgICAgICAgfCAzICsrKwogNCBmaWxlcyBjaGFu
Z2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRl
L3VhcGkvbGludXgvbmw4MDIxMS5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L25sODAyMTEuaAppbmRl
eCBjMGFiNmIwLi4xNzNiNmE1IDEwMDY0NAotLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvbmw4MDIx
MS5oCisrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9ubDgwMjExLmgKQEAgLTMzNjQsNiArMzM2NCw3
IEBAIGVudW0gbmw4MDIxMV9ic3Nfc2Nhbl93aWR0aCB7CiAgKgkobm90IHByZXNlbnQgaWYgbm8g
YmVhY29uIGZyYW1lIGhhcyBiZWVuIHJlY2VpdmVkIHlldCkKICAqIEBOTDgwMjExX0JTU19QUkVT
UF9EQVRBOiB0aGUgZGF0YSBpbiBATkw4MDIxMV9CU1NfSU5GT1JNQVRJT05fRUxFTUVOVFMgYW5k
CiAgKglATkw4MDIxMV9CU1NfVFNGIGlzIGtub3duIHRvIGJlIGZyb20gYSBwcm9iZSByZXNwb25z
ZSAoZmxhZyBhdHRyaWJ1dGUpCisgKiBATkw4MDIxMV9CU1NfTEFTVF9TRUVOX0JPT1RUSU1FOiBh
Z2Ugb2YgdGhpcyBCU1MgZW50cnkgaW4gdXMgZnJvbSBib290CiAgKiBAX19OTDgwMjExX0JTU19B
RlRFUl9MQVNUOiBpbnRlcm5hbAogICogQE5MODAyMTFfQlNTX01BWDogaGlnaGVzdCBCU1MgYXR0
cmlidXRlCiAgKi8KQEAgLTMzODMsNiArMzM4NCw3IEBAIGVudW0gbmw4MDIxMV9ic3MgewogCU5M
ODAyMTFfQlNTX0NIQU5fV0lEVEgsCiAJTkw4MDIxMV9CU1NfQkVBQ09OX1RTRiwKIAlOTDgwMjEx
X0JTU19QUkVTUF9EQVRBLAorCU5MODAyMTFfQlNTX0xBU1RfU0VFTl9CT09UVElNRSwKIAogCS8q
IGtlZXAgbGFzdCAqLwogCV9fTkw4MDIxMV9CU1NfQUZURVJfTEFTVCwKZGlmZiAtLWdpdCBhL25l
dC93aXJlbGVzcy9jb3JlLmggYi9uZXQvd2lyZWxlc3MvY29yZS5oCmluZGV4IGI5ZDViYzguLjI2
MWUxNTkgMTAwNjQ0Ci0tLSBhL25ldC93aXJlbGVzcy9jb3JlLmgKKysrIGIvbmV0L3dpcmVsZXNz
L2NvcmUuaApAQCAtMTQwLDYgKzE0MCw3IEBAIHN0cnVjdCBjZmc4MDIxMV9pbnRlcm5hbF9ic3Mg
ewogCXVuc2lnbmVkIGxvbmcgdHM7CiAJdW5zaWduZWQgbG9uZyByZWZjb3VudDsKIAlhdG9taWNf
dCBob2xkOworCXU2NCB0ZmI7CiAKIAkvKiBtdXN0IGJlIGxhc3QgYmVjYXVzZSBvZiBwcml2IG1l
bWJlciAqLwogCXN0cnVjdCBjZmc4MDIxMV9ic3MgcHViOwpkaWZmIC0tZ2l0IGEvbmV0L3dpcmVs
ZXNzL25sODAyMTEuYyBiL25ldC93aXJlbGVzcy9ubDgwMjExLmMKaW5kZXggZjA1YmE4Yi4uYTll
ZDJkYSAxMDA2NDQKLS0tIGEvbmV0L3dpcmVsZXNzL25sODAyMTEuYworKysgYi9uZXQvd2lyZWxl
c3Mvbmw4MDIxMS5jCkBAIC02NjAyLDcgKzY2MDIsOCBAQCBzdGF0aWMgaW50IG5sODAyMTFfc2Vu
ZF9ic3Moc3RydWN0IHNrX2J1ZmYgKm1zZywgc3RydWN0IG5ldGxpbmtfY2FsbGJhY2sgKmNiLAog
CSAgICBubGFfcHV0X3UzMihtc2csIE5MODAyMTFfQlNTX0ZSRVFVRU5DWSwgcmVzLT5jaGFubmVs
LT5jZW50ZXJfZnJlcSkgfHwKIAkgICAgbmxhX3B1dF91MzIobXNnLCBOTDgwMjExX0JTU19DSEFO
X1dJRFRILCByZXMtPnNjYW5fd2lkdGgpIHx8CiAJICAgIG5sYV9wdXRfdTMyKG1zZywgTkw4MDIx
MV9CU1NfU0VFTl9NU19BR08sCi0JCQlqaWZmaWVzX3RvX21zZWNzKGppZmZpZXMgLSBpbnRic3Mt
PnRzKSkpCisJCQlqaWZmaWVzX3RvX21zZWNzKGppZmZpZXMgLSBpbnRic3MtPnRzKSkgfHwKKwkg
ICAgbmxhX3B1dF91NjQobXNnLCBOTDgwMjExX0JTU19MQVNUX1NFRU5fQk9PVFRJTUUsIGludGJz
cy0+dGZiKSkKIAkJZ290byBubGFfcHV0X2ZhaWx1cmU7CiAKIAlzd2l0Y2ggKHJkZXYtPndpcGh5
LnNpZ25hbF90eXBlKSB7CmRpZmYgLS1naXQgYS9uZXQvd2lyZWxlc3Mvc2Nhbi5jIGIvbmV0L3dp
cmVsZXNzL3NjYW4uYwppbmRleCAzYTUwYWEyLi4yNzVjYzkyIDEwMDY0NAotLS0gYS9uZXQvd2ly
ZWxlc3Mvc2Nhbi5jCisrKyBiL25ldC93aXJlbGVzcy9zY2FuLmMKQEAgLTc0OSwxMCArNzQ5LDEy
IEBAIGNmZzgwMjExX2Jzc191cGRhdGUoc3RydWN0IGNmZzgwMjExX3JlZ2lzdGVyZWRfZGV2aWNl
ICpyZGV2LAogCQkgICAgYm9vbCBzaWduYWxfdmFsaWQpCiB7CiAJc3RydWN0IGNmZzgwMjExX2lu
dGVybmFsX2JzcyAqZm91bmQgPSBOVUxMOworCXN0cnVjdCB0aW1lc3BlYyB0ZmI7CiAKIAlpZiAo
V0FSTl9PTighdG1wLT5wdWIuY2hhbm5lbCkpCiAJCXJldHVybiBOVUxMOwogCisJZ2V0X21vbm90
b25pY19ib290dGltZSgmdGZiKTsKIAl0bXAtPnRzID0gamlmZmllczsKIAogCXNwaW5fbG9ja19i
aCgmcmRldi0+YnNzX2xvY2spOwpAQCAtODk1LDYgKzg5Nyw3IEBAIGNmZzgwMjExX2Jzc191cGRh
dGUoc3RydWN0IGNmZzgwMjExX3JlZ2lzdGVyZWRfZGV2aWNlICpyZGV2LAogCQlmb3VuZCA9IG5l
dzsKIAl9CiAKKwlmb3VuZC0+dGZiID0gKHU2NCkodGltZXNwZWNfdG9fbnMoJnRmYikgLyAxMDAw
KTsKIAlyZGV2LT5ic3NfZ2VuZXJhdGlvbisrOwogCWJzc19yZWZfZ2V0KHJkZXYsIGZvdW5kKTsK
IAlzcGluX3VubG9ja19iaCgmcmRldi0+YnNzX2xvY2spOwotLSAKMi42LjAucmMyLjIzMC5nM2Rk
MTVjMAoK
--089e0122a3fa04f5470520e9f2dc--
