Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:38625 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756036AbcIFNJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 09:09:34 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org,
        Pannirselvam Kanagaratnam <pannirk@gmail.com>
Subject: Re: Debugging RTL8192CU firmware loading on 3.12 powerpc
Date: Tue, 06 Sep 2016 15:09:21 +0200
Message-ID: <2186338.AojtHidiB8@bentobox> (sfid-20160906_150952_875918_049ED691)
In-Reply-To: <2747159.ja51ucCDFk@bentobox>
References: <1586991.4QUcrJhXOm@prime> <d6f2b558-167b-cb48-e924-7bac815817b1@lwfinger.net> <2747159.ja51ucCDFk@bentobox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2539440.zmd6JSpvy0"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2539440.zmd6JSpvy0
Content-Type: multipart/mixed; boundary="nextPart4802458.S2qBY17CCl"
Content-Transfer-Encoding: 7Bit

This is a multi-part message in MIME format.

--nextPart4802458.S2qBY17CCl
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Dienstag, 6. September 2016 09:40:41 CEST Sven Eckelmann wrote:
> On Freitag, 2. September 2016 12:53:28 CEST Larry Finger wrote:
> [...]
> 
> > The patch I included in my previous E-mail, and attached here,  does get
> > the firmware loaded correctly. There is still a problem that prevents
> > authentication. I'm still looking for that issue.
> 
> Thanks for the fast update. I am currently testing your patch. It looks like
> the initial error is now gone. The hostapd also starts but beaconing
> doesn't seem to work at all (no error from the kernel/hostapd but the
> device is not sending anything). I am currently checking how beaconing is
> supposed to work in your driver. Maybe I will spot something useful.

Yes, found something similar in the checksumming algorithm. See the attached 
patch for details.

Kind regards,
	Sven
--nextPart4802458.S2qBY17CCl
Content-Disposition: attachment; filename="0001-rtl8192c-Fix-byteorder-of-loaded-firmware.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-rtl8192c-Fix-byteorder-of-loaded-firmware.patch"

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 5 Sep 2016 11:03:44 +0200
Subject: [PATCH] rtl8192c: Fix byteorder of loaded firmware

The firmware is read in as an array of bytes, thus it is effectively in
little-endian order. When it is written back to the device in routine
_rtl92c_fw_block_write(), the data output uses 32-bit writes. Of course,
all data supplied in all 2- and 4-byte writes is assumed to be in CPU
order. As the device needs the data to be little-endian, it will be byte
swapped on BE machines. As a result, the firmware is written out in the
wrong byte order
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
index 43fcb25..7c5fc85 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -74,16 +74,18 @@ static void _rtl92c_fw_block_write(struct ieee80211_hw *hw,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 blocksize = sizeof(u32);
 	u8 *bufferptr = (u8 *)buffer;
-	u32 *pu4byteptr = (u32 *)buffer;
+	__le32 *pu4byteptr = (__le32 *)buffer;
 	u32 i, offset, blockcount, remainsize;
+	u32 data;
 
 	blockcount = size / blocksize;
 	remainsize = size % blocksize;
 
 	for (i = 0; i < blockcount; i++) {
 		offset = i * blocksize;
+		data = le32_to_cpu(*(pu4byteptr + i));
 		rtl_write_dword(rtlpriv, (FW_8192C_START_ADDRESS + offset),
-				*(pu4byteptr + i));
+				data);
 	}
 
 	if (remainsize) {

--nextPart4802458.S2qBY17CCl
Content-Disposition: attachment; filename="0002-Fix-TX-checksum-on-big-endian-systems.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0002-Fix-TX-checksum-on-big-endian-systems.patch"

From: Sven Eckelmann <sven@narfation.org>
Date: Tue, 6 Sep 2016 15:00:27 +0200
Subject: [PATCH] Fix TX checksum on big endian systems
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index 95880fe..6cb46ba 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
@@ -481,14 +481,14 @@ static void _rtl_fill_usb_tx_desc(u8 *txdesc)
  */
 static void _rtl_tx_desc_checksum(u8 *txdesc)
 {
-	u16 *ptr = (u16 *)txdesc;
+	__le16 *ptr = (__le16 *)txdesc;
 	u16	checksum = 0;
 	u32 index;
 
 	/* Clear first */
 	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, 0);
 	for (index = 0; index < 16; index++)
-		checksum = checksum ^ (*(ptr + index));
+		checksum = checksum ^ le16_to_cpu(*(ptr + index));
 	SET_TX_DESC_TX_DESC_CHECKSUM(txdesc, checksum);
 }
 

--nextPart4802458.S2qBY17CCl--

--nextPart2539440.zmd6JSpvy0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXzsABAAoJEF2HCgfBJntGTv8P/jNjrPRU/8pxiGKoYoJgAA8K
5IH4eGl2wib3Kxls1Wio4aeVvgMqwq3z6pGIVyTvShAej5cXrLU1sG+9xNhfQRsN
IlKdMW3fYzb64cn2XDMeQF8TiO3CmyThZNfm0Jy+btLh93d5GjcxQuM2XXqRdFxM
E+tzyJd78s+tpNoMALBoA/84D5KG2nNhcQX6D28PC5u5HxTALBtqtSEaiHsINrrX
HhRmPV//dBT9LkU1aaQxvTWbezEMBDhNFWgQgjHAV821IQpr/clA24yLdEKyGs9l
htP15RsIN80fPZoMATGe4m2npo9mcoAf1WkAYmXnDia96k6wXXUkVOliDmHw9Ut+
LuwXEGfDsZ4Bd7skHZY0wTZ3kytDvvyfulgZeIm6nc3KpAI6FGr5LfKkePShutVe
Qoz4jZChjTKdckDJiG1XVC3BSbwMNEt+FaaZlRoEjHNqvtjpsFjx7cLtzKAI4Pzq
N6UIMB/a6u7lvtvmkPdGqYzpNh2Gowu9BVR/B/ANkNptMK/sAgr0AifQquEUE66V
3VVZPScS1oIA4PhzcKiIdtFX4MimJeFqLaA+4pUa3FM46VfbAJ0JLOT2ttuwDWT1
JmOSFzXVdKS1wcFrv3SB+BmNAzBa4PYncKHxLWv7gRXK/TquO/AalnUfCPux8kWF
oTI3qvR32Wx+tSgArR/J
=vZZA
-----END PGP SIGNATURE-----

--nextPart2539440.zmd6JSpvy0--
