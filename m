Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:5107 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbXIQUev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 16:34:51 -0400
Received: by py-out-1112.google.com with SMTP id u77so3354943pyb
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2007 13:34:51 -0700 (PDT)
Message-ID: <43e72e890709171334y321dc2c8ke255a126a733dad6@mail.gmail.com>
Date: Mon, 17 Sep 2007 16:34:51 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] revert ath5k ioread32()/iowrite32() usage - use readl()/writel(), we're MMIO-only
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Jeff Garzik" <jeff@garzik.org>, "Jiri Slaby" <jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_15986_8417745.1190061291079"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_15986_8417745.1190061291079
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Based on advise from Jeff, as described in the e-mail:

[PATCH] Clarify pci_iomap() usage for MMIO-only devices

we shouldn't use ioread32()/iowrite32() unless we really have a need
to otherwise we're creating an unnecessary branch on read/write. Lets
revert this back to readl()/writel() as our devices so far have been
MMIO-only. This reverts 9202ec15da36ca060722c363575e0e390d85fb71 on
ath5k. This patch is intended for the ath5k branch of wireless-dev.

Changes-licensed-under: ISC
Singed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>

---

 drivers/net/wireless/ath5k_hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k_hw.c b/drivers/net/wireless/ath5k_hw.c
index 07ad127..3501b4c 100644
--- a/drivers/net/wireless/ath5k_hw.c
+++ b/drivers/net/wireless/ath5k_hw.c
@@ -219,7 +219,7 @@ static inline unsigned int
ath5k_hw_clocktoh(unsigned int clock, bool turbo)
  */
 static inline u32 ath5k_hw_reg_read(struct ath_hw *hal, u16 reg)
 {
-       return ioread32(hal->ah_sh + reg);
+       return readl(hal->ah_sh + reg);
 }

 /*
@@ -227,7 +227,7 @@ static inline u32 ath5k_hw_reg_read(struct ath_hw
*hal, u16 reg)
  */
 static inline void ath5k_hw_reg_write(struct ath_hw *hal, u32 val, u16 reg)
 {
-       iowrite32(val, hal->ah_sh + reg);
+       writel(val, hal->ah_sh + reg);
 }

 /*

------=_Part_15986_8417745.1190061291079
Content-Type: text/x-patch; name="ath5k-revert-ioread-write.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="ath5k-revert-ioread-write.diff"
X-Attachment-Id: f_f6pfhh5q

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aDVrX2h3LmMgYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9hdGg1a19ody5jCmluZGV4IDA3YWQxMjcuLjM1MDFiNGMgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aDVrX2h3LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoNWtfaHcuYwpAQCAtMjE5LDcgKzIxOSw3IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQg
aW50IGF0aDVrX2h3X2Nsb2NrdG9oKHVuc2lnbmVkIGludCBjbG9jaywgYm9vbCB0dXJibykKICAq
Lwogc3RhdGljIGlubGluZSB1MzIgYXRoNWtfaHdfcmVnX3JlYWQoc3RydWN0IGF0aF9odyAqaGFs
LCB1MTYgcmVnKQogewotCXJldHVybiBpb3JlYWQzMihoYWwtPmFoX3NoICsgcmVnKTsKKwlyZXR1
cm4gcmVhZGwoaGFsLT5haF9zaCArIHJlZyk7CiB9CiAKIC8qCkBAIC0yMjcsNyArMjI3LDcgQEAg
c3RhdGljIGlubGluZSB1MzIgYXRoNWtfaHdfcmVnX3JlYWQoc3RydWN0IGF0aF9odyAqaGFsLCB1
MTYgcmVnKQogICovCiBzdGF0aWMgaW5saW5lIHZvaWQgYXRoNWtfaHdfcmVnX3dyaXRlKHN0cnVj
dCBhdGhfaHcgKmhhbCwgdTMyIHZhbCwgdTE2IHJlZykKIHsKLQlpb3dyaXRlMzIodmFsLCBoYWwt
PmFoX3NoICsgcmVnKTsKKwl3cml0ZWwodmFsLCBoYWwtPmFoX3NoICsgcmVnKTsKIH0KIAogLyoK

------=_Part_15986_8417745.1190061291079--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
