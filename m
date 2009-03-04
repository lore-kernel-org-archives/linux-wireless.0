Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:54897 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZCDQUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 11:20:13 -0500
Message-ID: <49AEAA34.8080806@openwrt.org> (sfid-20090304_172020_351895_E9333B33)
Date: Wed, 04 Mar 2009 17:20:04 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: use correct init values for ar9100
 devices
References: <1236103846-1672-1-git-send-email-juhosg@openwrt.org>	<18862.1025.217829.656599@gargle.gargle.HOWL>	<18862.4870.138381.234256@gargle.gargle.HOWL>	<49AE8466.3040906@openwrt.org> <18862.36430.959276.440720@gargle.gargle.HOWL>
In-Reply-To: <18862.36430.959276.440720@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith =EDrta:
> Gabor Juhos wrote:
>> Apart from the last line, this patch simply swaps the two initval se=
ts as i see
>> it. Would not be simpler to rename them, and then change this line o=
nly?
>>
>=20
> I didn't bother to check if the initvals were to be swapped or not.

Well, I was curious, so I did it. :)

After some cut&paste job, here is the diff between the original and the=
 new
initvals from your patch:

diff --git a/drivers/net/wireless/ath9k/initvals.h
b/drivers/net/wireless/ath9k/initvals.h
index d492363..d5a8aec 100644
--- a/drivers/net/wireless/ath9k/initvals.h
+++ b/drivers/net/wireless/ath9k/initvals.h
@@ -658,7 +657,7 @@ static const u32 ar5416Addac_9100[][2] =3D {
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
-    {0x000098cc,  0x00000000 },
+    {0x000098c4,  0x00000000 },
 };

 static const u32 ar5416Modes[][6] =3D {
@@ -862,7 +861,7 @@ static const u32 ar5416Common[][2] =3D {
     { 0x00008134, 0x00000000 },
     { 0x00008138, 0x00000000 },
     { 0x0000813c, 0x00000000 },
-    { 0x00008144, 0x00000000 },
+    { 0x00008144, 0xffffffff },
     { 0x00008168, 0x00000000 },
     { 0x0000816c, 0x00000000 },
     { 0x00008170, 0x32143320 },

> The patch was a line-by-line copy of the latest initvals. :-)
> Figured this would also make it easier to roll out future updates.

Ok. This version will cause more noise, but it is fine for me.

>=20
>>> +#define AR_SREV_VERSION_9100		0x014
>> 0x14?
>=20
> Yep, this can be fixed.

I have to send a new patch, or you will take care of it?

Regards,
Gabor

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
