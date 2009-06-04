Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:53049 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbZFDTvZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 15:51:25 -0400
Message-ID: <4A2825B5.3000405@free.fr>
Date: Thu, 04 Jun 2009 21:51:17 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: b43 : unaligned access on mips
References: <4A244E19.7090501@free.fr> <200906021720.39080.mb@bu3sch.de> <4A256CCC.5040908@free.fr> <200906022027.35609.mb@bu3sch.de>
In-Reply-To: <200906022027.35609.mb@bu3sch.de>
Content-Type: multipart/mixed;
 boundary="------------030403080704020109050209"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030403080704020109050209
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Michael Buesch wrote:
> On Tuesday 02 June 2009 20:17:48 matthieu castet wrote:
> Can you send a patch please?
> I do actually prefer patches anyway instead of verbose explanations. I'd have
> immediately understood what you were talking about, if you'd just sent a patch. ;)
> 
Here you are

--------------030403080704020109050209
Content-Type: text/x-diff;
 name="b43_unaligned.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="b43_unaligned.diff"

Fix an unaligned access on b43.
unaligned data is read/write with a u32 pointer instead of using the
packed structure.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index a63d888..55f36a7 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -118,7 +118,6 @@ u8 b43_plcp_get_ratecode_ofdm(const u8 bitrate)
 void b43_generate_plcp_hdr(struct b43_plcp_hdr4 *plcp,
 			   const u16 octets, const u8 bitrate)
 {
-	__le32 *data = &(plcp->data);
 	__u8 *raw = plcp->raw;
 
 	if (b43_is_ofdm_rate(bitrate)) {
@@ -127,7 +126,7 @@ void b43_generate_plcp_hdr(struct b43_plcp_hdr4 *plcp,
 		d = b43_plcp_get_ratecode_ofdm(bitrate);
 		B43_WARN_ON(octets & 0xF000);
 		d |= (octets << 5);
-		*data = cpu_to_le32(d);
+		plcp->data = cpu_to_le32(d);
 	} else {
 		u32 plen;
 
@@ -141,7 +140,7 @@ void b43_generate_plcp_hdr(struct b43_plcp_hdr4 *plcp,
 				raw[1] = 0x04;
 		} else
 			raw[1] = 0x04;
-		*data |= cpu_to_le32(plen << 16);
+		plcp->data |= cpu_to_le32(plen << 16);
 		raw[0] = b43_plcp_get_ratecode_cck(bitrate);
 	}
 }

--------------030403080704020109050209--
