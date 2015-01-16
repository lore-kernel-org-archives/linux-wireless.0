Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38232 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbbAPQGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 11:06:22 -0500
Received: by mail-pd0-f181.google.com with SMTP id z10so11947305pdj.12
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 08:06:22 -0800 (PST)
Date: Fri, 16 Jan 2015 21:36:14 +0530
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2] brcmfmac: Use put_unaligned_le32
Message-ID: <20150116160613.GA11361@vaishali-Ideapad-Z570> (sfid-20150116_170625_654192_C8080072)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces the use of function put_unaligned_le32.

This is done using Coccinelle and semantic patch used is as follows:

@a@
typedef u32, __le32, uint32_t;
{u32,__le32,uint32_t} e32;
identifier tmp;
expression ptr;
expression y,e;
type T;
type T;
@@

- tmp = cpu_to_le32(y);

<+... when != tmp
(
- memcpy(ptr, (T)&tmp, \(4\|sizeof(u32)\|sizeof(__le32)\|sizeof(uint32_t)\|sizeof(e32)\));
+ put_unaligned_le32(y,ptr);
|
- memcpy(ptr, (T)&tmp, ...);
+ put_unaligned_le32(y,ptr);
)
...+>
? tmp = e

@@ type T; identifier a.tmp; @@

- T tmp;
...when != tmp

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
--
Changes in v2:
	-refreshed it against changes
	-changed commit message

 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 3aecc5f..ab3cc9f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -3695,17 +3695,12 @@ static u32
 brcmf_vndr_ie(u8 *iebuf, s32 pktflag, u8 *ie_ptr, u32 ie_len, s8 *add_del_cmd)
 {
 
-	__le32 iecount_le;
-	__le32 pktflag_le;
-
 	strncpy(iebuf, add_del_cmd, VNDR_IE_CMD_LEN - 1);
 	iebuf[VNDR_IE_CMD_LEN - 1] = '\0';
 
-	iecount_le = cpu_to_le32(1);
-	memcpy(&iebuf[VNDR_IE_COUNT_OFFSET], &iecount_le, sizeof(iecount_le));
+	put_unaligned_le32(1, &iebuf[VNDR_IE_COUNT_OFFSET]);
 
-	pktflag_le = cpu_to_le32(pktflag);
-	memcpy(&iebuf[VNDR_IE_PKTFLAG_OFFSET], &pktflag_le, sizeof(pktflag_le));
+	put_unaligned_le32(pktflag, &iebuf[VNDR_IE_PKTFLAG_OFFSET]);
 
 	memcpy(&iebuf[VNDR_IE_VSIE_OFFSET], ie_ptr, ie_len);
 
-- 
1.9.1

