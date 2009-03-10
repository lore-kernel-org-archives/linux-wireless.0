Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:42115 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbZCJR35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 13:29:57 -0400
Received: by ewy25 with SMTP id 25so1350680ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 10:29:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49B660AE.80502@gmail.com>
References: <20090310103344.GC3341@makis> <49B660AE.80502@gmail.com>
Date: Tue, 10 Mar 2009 19:29:53 +0200
Message-ID: <40f31dec0903101029v5744ea82yf8632a07defe1642@mail.gmail.com> (sfid-20090310_183004_978184_1A317A37)
Subject: Re: [PATCH 2/3] ath5k: Convert chip specific calibration data to a
	generic format
From: Nick Kossifidis <mickflemm@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/10 Jiri Slaby <jirislaby@gmail.com>:
> On 10.3.2009 11:33, Nick Kossifidis wrote:
>>
>> --- a/drivers/net/wireless/ath5k/eeprom.c
>> +++ b/drivers/net/wireless/ath5k/eeprom.c
>
> ...
>>
>> +static int
>> +ath5k_eeprom_convert_pcal_info_5111(struct ath5k_hw *ah, int mode,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ath5k_chan_pcal_info *chi=
nfo)
>> +{
>> + =C2=A0 =C2=A0 =C2=A0 struct ath5k_eeprom_info *ee =3D&ah->ah_capab=
ilities.cap_eeprom;
>> + =C2=A0 =C2=A0 =C2=A0 struct ath5k_chan_pcal_info_rf5111 *pcinfo;
>> + =C2=A0 =C2=A0 =C2=A0 struct ath5k_pdgain_info *pd;
>> + =C2=A0 =C2=A0 =C2=A0 u8 pier, point, idx;
>> + =C2=A0 =C2=A0 =C2=A0 u8 *pdgain_idx =3D ee->ee_pdc_to_idx[mode];
>> +
>> + =C2=A0 =C2=A0 =C2=A0 /* Fill raw data for each calibration pier */
>> + =C2=A0 =C2=A0 =C2=A0 for (pier =3D 0; pier< =C2=A0ee->ee_n_piers[m=
ode]; pier++) {
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pcinfo =3D&chinfo=
[pier].rf5111_info;
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Allocate pd_cu=
rves for this cal pier */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 chinfo[pier].pd_c=
urves =3D
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 kzalloc(sizeof(struct ath5k_pdgain_info) *
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AR5K_EEPROM_N_PD_CURVES, GFP_KER=
NEL);
>
> ...
>>
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Allocate pd po=
ints for this curve */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pd->pd_step =3D k=
zalloc(sizeof(u8) *
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AR5K=
_EEPROM_N_PWR_POINTS_5111,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GFP_=
KERNEL);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!pd->pd_step)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return -ENOMEM;
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pd->pd_pwr =3D kz=
alloc(sizeof(s16) *
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 AR5K=
_EEPROM_N_PWR_POINTS_5111,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GFP_=
KERNEL);
>
> Just a nit, these 3 may be kcalloc. (and in other places too)
>

Cool, i didn't knew about kcalloc, we can use it on rf registers too ;-=
)

>> =C2=A0static int
>> =C2=A0ath5k_eeprom_read_pcal_info_5112(struct ath5k_hw *ah, int mode=
)
>> =C2=A0{
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ath5k_eeprom_info *ee =3D&ah->ah_c=
apabilities.cap_eeprom;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ath5k_chan_pcal_info_rf5112 *chan_=
pcal_info;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ath5k_chan_pcal_info *gen_chan_inf=
o;
>> + =C2=A0 =C2=A0 =C2=A0 u8 *pdgain_idx =3D ee->ee_pdc_to_idx[mode];
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 offset;
>> - =C2=A0 =C2=A0 =C2=A0 unsigned int i, c;
>> + =C2=A0 =C2=A0 =C2=A0 u8 i, c;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0u16 val;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
>> + =C2=A0 =C2=A0 =C2=A0 u8 pd_gains =3D 0;
>> +
>> + =C2=A0 =C2=A0 =C2=A0 /* Count how many curves we have and
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* identify them (which one of the 4
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* available curves we have on each coun=
t).
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Curves are stored from lower (x0) to
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* higher (x3) gain */
>> + =C2=A0 =C2=A0 =C2=A0 memset(pdgain_idx, 0, sizeof(pdgain_idx));
>
> Note, that sizeof(pdgain_idx) =3D=3D 4 or 8 (pointer size) depending =
on arch,
> this is likely not what you want :).
>
> (and the other memsets too)

Yup it's totally wrong plus i don't think we need to memset this
anyway, it should be zeroed...

Thanks a lot for the comments, i'll wait a couple of days in case
anything else comes up and i'll re-submit ;-)

--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
