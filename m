Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep24.mx.upcmail.net ([62.179.121.44]:50367 "EHLO
	fep24.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab2JUMrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 08:47:14 -0400
From: <aolah76@freemail.hu>
To: "'Mohammed Shafi'" <shafi.wireless@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
References: <1311771665-59853-1-git-send-email-nbd@openwrt.org><1311771665-59853-2-git-send-email-nbd@openwrt.org><1311771665-59853-3-git-send-email-nbd@openwrt.org><1311771665-59853-4-git-send-email-nbd@openwrt.org><loom.20121018T003841-742@post.gmane.org> <CAD2nsn2T-GhRwJAAEgpyQTSJLNV1m-ZYC+A3L78GfEpt=ATw_g@mail.gmail.com>
In-Reply-To: <CAD2nsn2T-GhRwJAAEgpyQTSJLNV1m-ZYC+A3L78GfEpt=ATw_g@mail.gmail.com>
Subject: RE: [PATCH 4/4] ath9k_hw: do not limit initial tx power to 20 dbm
Date: Sun, 21 Oct 2012 14:32:23 +0200
Message-ID: <013577EE628D48EC97D828F298FFDFA0@A64X24200> (sfid-20121021_144717_770792_EC1CEE78)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_000C_01CDAF98.E2DB8720"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_000C_01CDAF98.E2DB8720
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable

=20

-----Original Message-----
From: Mohammed Shafi [mailto:shafi.wireless@gmail.com]=20
Sent: Friday, October 19, 2012 7:21 AM
To: Ambrus Ol=E1h
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] ath9k_hw: do not limit initial tx power to 20 =
dbm

On Thu, Oct 18, 2012 at 4:14 AM, Ambrus Ol=E1h <aolah76@freemail.hu> =
wrote:
> Felix Fietkau <nbd@...> writes:
>
>>
>> When testing for tx power, bypass the default limits.
>>
>> Signed-off-by: Felix Fietkau <nbd@...>
>> ---
>>  drivers/net/wireless/ath/ath9k/hw.c |    9 ++++++---
>>  1 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c
> b/drivers/net/wireless/ath/ath9k/hw.c
>> index 8006ce0..a2e5763 100644
>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> @@ -2432,15 +2432,18 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw=20
>> *ah, u32
> limit, bool test)
>>       struct ath_regulatory *regulatory =3D ath9k_hw_regulatory(ah);
>>       struct ath9k_channel *chan =3D ah->curchan;
>>       struct ieee80211_channel *channel =3D chan->chan;
>> +     int reg_pwr =3D min_t(int, MAX_RATE_POWER, =
regulatory->power_limit);
>> +     int chan_pwr =3D channel->max_power * 2;
>> +
>> +     if (test)
>> +             reg_pwr =3D chan_pwr =3D MAX_RATE_POWER;
>>
>>       regulatory->power_limit =3D min(limit, (u32) MAX_RATE_POWER);
>>
>>       ah->eep_ops->set_txpower(ah, chan,
>>                                ath9k_regd_get_ctl(regulatory, chan),
>>                                channel->max_antenna_gain * 2,
>> -                              channel->max_power * 2,
>> -                              min((u32) MAX_RATE_POWER,
>> -                              (u32) regulatory->power_limit), test);
>> +                              chan_pwr, reg_pwr, test);
>>  }
>>  EXPORT_SYMBOL(ath9k_hw_set_txpowerlimit);
>>
>
>
> Dear Mr. Fietkau,
>
> I have tried to apply your patch on
> http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.3/compat-w
> ireless-3.3-2-n.tar.bz2
>
> I get the following error:
>
> patch -p1 < ath9k_txpower.patch
> patching file drivers/net/wireless/ath/ath9k/hw.c
> Hunk #1 FAILED at 2432.
> patch unexpectedly ends in middle of line
> 1 out of 1 hunk FAILED -- saving rejects to file=20
> drivers/net/wireless/ath/ath9k/hw.c.rej
> patch unexpectedly ends in middle of line
>
> Could you support me with a patch tuned to the above compat-wireless?

try applying over the latest
http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-201=
2-1
0-03.tar.bz2

ideally these patches are based on wireless-testing tree and you goto =
apply
into it, and do kerenel/module compilation.

http://wireless.kernel.org/en/developers/Documentation/git-guide#Cloning_=
lat
est_wireless-testing


>
> Yours sincerelly,
>
> Ambrus Ol=E1h
>
> --
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-wireless" in the body of a message to majordomo@vger.kernel.org=20
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
thanks,
Shafi

Dear Mr. Shafi,

I have tested the patch above on
http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-201=
2-1
0-03.tar.bz2 with the following results:

~/compat-wireless-2012-10-03# patch -p1 < ath9k_txpower.patch
patching file drivers/net/wireless/ath/ath9k/hw.c
Hunk #1 FAILED at 2432.
patch unexpectedly ends in middle of line
1 out of 1 hunk FAILED -- saving rejects to file
drivers/net/wireless/ath/ath9k/hw.c.rej
patch unexpectedly ends in middle of line

I have also tried to test the patch with the latest compat-wireless =
source
found at:
http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-201=
2-1
0-20.tar.bz2

I get the same error:

~/compat-wireless-2012-10-20# patch -p1 < ath9k_txpower.patch
patching file drivers/net/wireless/ath/ath9k/hw.c
Hunk #1 FAILED at 2432.
patch unexpectedly ends in middle of line
1 out of 1 hunk FAILED -- saving rejects to file
drivers/net/wireless/ath/ath9k/hw.c.rej
patch unexpectedly ends in middle of line

Could you examine the attached patch file why it is comlaining twice =
about
"patch unexpectedly ends in middle of line" ?

Yours sincerelly,

Ambrus Ol=E1h

------=_NextPart_000_000C_01CDAF98.E2DB8720
Content-Type: application/octet-stream;
	name="ath9k_txpower.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="ath9k_txpower.patch"

--- a/drivers/net/wireless/ath/ath9k/hw.c=0A=
+++ b/drivers/net/wireless/ath/ath9k/hw.c=0A=
@@ -2432,15 +2432,18 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw =
*ah, u32 limit, bool test)=0A=
 	struct ath_regulatory *regulatory =3D ath9k_hw_regulatory(ah);=0A=
 	struct ath9k_channel *chan =3D ah->curchan;=0A=
 	struct ieee80211_channel *channel =3D chan->chan;=0A=
+	int reg_pwr =3D min_t(int, MAX_RATE_POWER, regulatory->power_limit);=0A=
+	int chan_pwr =3D channel->max_power * 2;=0A=
+=0A=
+	if (test)=0A=
+		reg_pwr =3D chan_pwr =3D MAX_RATE_POWER;=0A=
=0A=
 	regulatory->power_limit =3D min(limit, (u32) MAX_RATE_POWER);=0A=
=0A=
 	ah->eep_ops->set_txpower(ah, chan,=0A=
 				 ath9k_regd_get_ctl(regulatory, chan),=0A=
 				 channel->max_antenna_gain * 2,=0A=
-				 channel->max_power * 2,=0A=
-				 min((u32) MAX_RATE_POWER,=0A=
-				 (u32) regulatory->power_limit), test);=0A=
+				 chan_pwr, reg_pwr, test);=0A=
 }=0A=
 EXPORT_SYMBOL(ath9k_hw_set_txpowerlimit);=0A=
=0A=
--
------=_NextPart_000_000C_01CDAF98.E2DB8720--

