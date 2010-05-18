Return-path: <linux-wireless-owner@vger.kernel.org>
Message-Id: <4BF28A6B020000230001961F@novprvlin0050.provo.novell.com>
Date: Mon, 17 May 2010 20:39:07 -0600
From: "Joey Lee" <jlee@novell.com>
To: "Matt Chen" <MaChen@novell.com>
Cc: <lrodriguez@atheros.com>, <Luis.Rodriguez@atheros.com>,
	"Gary Lin" <GLin@novell.com>,
	"Greg Kroah-Hartman" <GregKH@novell.com>,
	<linux-net@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Fix AR9285 always turn off LED on HP mini 210
	 [1/1]
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartF4DE43DB.1__="
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartF4DE43DB.1__=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Hi Luis, 

Could you help kindly review my attahced patch (the same with my first
mail in this loop)?

Per our testing, this patch can fix the LED problem on HP mini 210, but
we are not good for wifi driver and just trace the LED behavior. We need
your professional suggestion to us.


thank's a lot!
Joey Lee

於 二，2010-05-18 於 09:55 +0800，Matt Chen 提到：
> Hi Luis,
> After testing the compat-wireless-2.6.34-rc4.tar.bz2，this issue is
> still.
> The wireless LED is always off no matter how many times I try to press
> the function key to enable/disable the wireless.
> I would like to ask is there a way to debug it ? 
> Thanks ~ ;-)
> 
> 2010/5/14 Luis R. Rodriguez <lrodriguez@atheros.com>
>         On Thu, May 13, 2010 at 04:13:18AM -0700, Matt Chen wrote:
>         > Hi Luis,
>         > Tried the driver,compat-wireless-2.6.33.
>         > 2.tar.bz2,  from
>         http://wireless.kernel.org/en/users/Download/stable, it
>         doesn't fix this issue. The LED is still keeping off whatever
>         you enable/disable it.
>         
>         
>         2.6.33 is ancient now, try the compat-wireles 2.6.34-rc stuff
>         and if
>         that doesn't help try bleeding edge. The fixes need to be
>         addressed
>         on bleedinge edge *first* but if bleedinge edge already has a
>         fix
>         then its a matter of cherry picking that and sending it to the
>         stable
>         gods.
>         
>          Luis
> 
> 
> 
> -- 
> Matt Chen
> Engineer
> Novell Asia Pacific
> Tel : +886- 2- 27370946 ext 507
> Fax : +886- 2- 27370947
> Novell Making IT Work As One


--=__PartF4DE43DB.1__=
Content-Type: text/plain; name="0001-Fix-AR9285-always-turn-off-LED-on-HP-mini-210.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="0001-Fix-AR9285-always-turn-off-LED-on-HP-mini-210.patch"

>From b725acf8fda0866aab49807a93c925e07994e2a4 Mon Sep 17 00:00:00 =
2001=0AFrom: Lee, Chun-Yi <jlee@novell.com>=0ADate: Sun, 9 May 2010 =
06:47:07 +0800=0ASubject: [PATCH] Fix AR9285 always turn off LED on HP =
mini 210=0A=0AOn 2.6.33 kernel, The AR9285 wifi module always turn off =
wifi LED=0Aon fn+f11 function key on HP  mini 210.=0AAfter trace main.c, =
found it was always disable_radio after call=0Aath9k_config because the =
all_wiphys_idle is true on HP mini 210.=0A=0AThis LED works fine on 2.6.32 =
kernel, the following patch causes=0Athis side effect:=0Aath9k: fix =
listening to idle requests=0A194b7c13b4c516db94db8ee004342f8935922739=0A=0A=
Signed-off-by: Lee, Chun-Yi <jlee@novell.com>=0A---=0A drivers/net/wireless=
/ath/ath9k/main.c |    7 +++----=0A 1 files changed, 3 insertions(+), 4 =
deletions(-)=0A=0Adiff --git a/drivers/net/wireless/ath/ath9k/main.c =
b/drivers/net/wireless/ath/ath9k/main.c=0Aindex 643bea3..d4ca82e 100644=0A-=
-- a/drivers/net/wireless/ath/ath9k/main.c=0A+++ b/drivers/net/wireless/ath=
/ath9k/main.c=0A@@ -2704,6 +2704,9 @@ static int ath9k_config(struct =
ieee80211_hw *hw, u32 changed)=0A 		if (!idle && all_wiphys_idl=
e)=0A 			enable_radio =3D true;=0A =0A+		if (idle =
&& all_wiphys_idle)=0A+			disable_radio =3D true;=0A+=0A 		=
/*=0A 		 * After we unlock here its possible another wiphy=0A 		=
 * can be re-renabled so to account for that we will=0A@@ -2804,10 +2807,6 =
@@ skip_chan_change:=0A 	if (changed & IEEE80211_CONF_CHANGE_POWER)=
=0A 		sc->config.txpowlimit =3D 2 * conf->power_level;=0A =0A-	=
spin_lock_bh(&sc->wiphy_lock);=0A-	disable_radio =3D ath9k_all_wiphys_=
idle(sc);=0A-	spin_unlock_bh(&sc->wiphy_lock);=0A-=0A 	if =
(disable_radio) {=0A 		ath_print(common, ATH_DBG_CONFIG, "idle: =
disabling radio\n");=0A 		ath_radio_disable(sc, hw);=0A-- =
=0A1.6.0.2=0A=0A
--=__PartF4DE43DB.1__=--
