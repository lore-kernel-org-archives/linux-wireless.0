Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750873AbcI3Xja (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 19:39:30 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "Franc\[e\]sco" <lolisamurai@waifu.club>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RTL8192EU on rtl8xxxu driver breaks every few minutes
References: <c6784dde-65df-87cd-f97e-33fbd8dd55ff@waifu.club>
        <wrfj4m5acouw.fsf@redhat.com>
        <80b8ae50-ca27-674f-0e7e-79b931bae199@waifu.club>
Date: Fri, 30 Sep 2016 19:39:28 -0400
In-Reply-To: <80b8ae50-ca27-674f-0e7e-79b931bae199@waifu.club> (Franc[e]sco's
        message of "Wed, 21 Sep 2016 19:44:34 +0200")
Message-ID: <wrfjr3816jpr.fsf@redhat.com> (sfid-20161001_013933_510967_FA7EA16C)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Type: text/plain

"Franc[e]sco" <lolisamurai@waifu.club> writes:
> Oops, forgot to forward the previous reply to the mailing list.
>
> I have attached the output of iw link
>
> the AP is an asus dsl-n55u router in 2.4 GHz mode, using WPA2-Personal
> with AES encryption. It's also running a second 5GHz wireless network
> which has a different SSID.
>
> Also, this seems to be some kind of power saving kicking in, as the
> dongle keeps working as long as I keep doing things over ssh.

I just pushed a patch into rtl8xxxu-devel which may resolve this issue.
There were problems with the 8192eu not handling driver reload very
well. It is possible the network scripts you run would trigger the shut
down and restart that caused this problem.

I would be interested in knowing if this patch resolves the problem for
you.

Jes

PS: Please fix your mail client - adding unlisted-recipients to the Cc
line and cutting out the person you are responding to is really
annoying.


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0002-rtl8xxxu-Fix-rtl8192eu-driver-reload-issue.patch

>From 93064d0ae3e9d97c03a3aabd71e6048e1ac82f46 Mon Sep 17 00:00:00 2001
From: Jes Sorensen <Jes.Sorensen@redhat.com>
Date: Fri, 30 Sep 2016 19:18:34 -0400
Subject: [PATCH 2/2] rtl8xxxu: Fix rtl8192eu driver reload issue

The 8192eu suffered from two issues when reloading the driver.

The same problems as with the 8723bu where REG_RX_WAIT_CCA bits 22 and
23 didn't get set in rtl8192e_enable_rf().

In addition it also seems prone to issues when setting REG_RF_CTRL to
0 intead of just disabling the RF_ENABLE bit. Similar to what was
causing issues with the 8188eu.

With this patch I can successfully reload the driver and reassociate
to an APi with an 8192eu dongle.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index df54d27..a793fed 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1461,7 +1461,9 @@ static int rtl8192eu_active_to_emu(struct rtl8xxxu_priv *priv)
 	int count, ret = 0;
 
 	/* Turn off RF */
-	rtl8xxxu_write8(priv, REG_RF_CTRL, 0);
+	val8 = rtl8xxxu_read8(priv, REG_RF_CTRL);
+	val8 &= ~RF_ENABLE;
+	rtl8xxxu_write8(priv, REG_RF_CTRL, val8);
 
 	/* Switch DPDT_SEL_P output from register 0x65[2] */
 	val8 = rtl8xxxu_read8(priv, REG_LEDCFG2);
@@ -1593,6 +1595,10 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
 	u32 val32;
 	u8 val8;
 
+	val32 = rtl8xxxu_read32(priv, REG_RX_WAIT_CCA);
+	val32 |= (BIT(22) | BIT(23));
+	rtl8xxxu_write32(priv, REG_RX_WAIT_CCA, val32);
+
 	val8 = rtl8xxxu_read8(priv, REG_GPIO_MUXCFG);
 	val8 |= BIT(5);
 	rtl8xxxu_write8(priv, REG_GPIO_MUXCFG, val8);
-- 
2.7.4


--=-=-=--
