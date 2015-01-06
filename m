Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34501 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbAFDx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 22:53:27 -0500
Received: by mail-pa0-f47.google.com with SMTP id kq14so30080083pab.20
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2015 19:53:26 -0800 (PST)
Date: Tue, 6 Jan 2015 09:23:19 +0530
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] brcmfmac: Use put_unaligned_le32
Message-ID: <20150106035319.GA4082@vaishali-Ideapad-Z570> (sfid-20150106_045332_129360_16BDF6D2)
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
- memcpy(ptr, (T)&tmp, \(4\|sizeof(u32)\|sizeof(__le32)\|sizeof(uint32_t)\|s
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
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 28fa25b..6d37618 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3550,17 +3550,12 @@ static u32
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

