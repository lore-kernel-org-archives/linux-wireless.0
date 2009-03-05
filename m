Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:59324 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbZCEXNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 18:13:44 -0500
Received: by wf-out-1314.google.com with SMTP id 28so188628wfa.4
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 15:13:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49B056FA.2020605@canonical.com>
References: <43e72e890903041335n47a70186u4a7aeb304f8b6979@mail.gmail.com>
	 <1236275668.6612.134.camel@rc-desk>
	 <43e72e890903051124t42ce5c7blfd741da4a2b4fa79@mail.gmail.com>
	 <49B056FA.2020605@canonical.com>
Date: Thu, 5 Mar 2009 15:13:42 -0800
Message-ID: <43e72e890903051513n44cf5281y32cc11e06754aa3@mail.gmail.com> (sfid-20090306_001347_209839_673D1599)
Subject: Re: Please apply to stable: cfg80211: add support for custom firmware
	regulatory solutions
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: tim.gardner@canonical.com
Cc: reinette chatre <reinette.chatre@intel.com>,
	"stable@kernel.org" <stable@kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 5, 2009 at 2:49 PM, Tim Gardner <tim.gardner@canonical.com>=
 wrote:
> Luis R. Rodriguez wrote:
>> On Thu, Mar 5, 2009 at 9:54 AM, reinette chatre
>> <reinette.chatre@intel.com> wrote:
>>> On Wed, 2009-03-04 at 13:35 -0800, Luis R. Rodriguez wrote:
>>>> Forgot to Cc: stable@kernel.org for this patch during its submissi=
on,
>>>> this is needed on 2.6.28 as otherwise there is an issue for Intel
>>>> cards which get their channels 5 GHz disabled if OLD_REG is set to=
 no
>>>> (this is not the default) or the channels 12-14 are disabled if
>>>> OLD_REG is set to yes (default) set to no and the ieee80211_module
>>>> parameter is not used. The later issue is resolved by userspace as
>>>> well but we cannot yet expect 2.6.28 kernels to have enough usersp=
ace
>>>> interfaces to set the regulatory domain just yet. This is why OLD_=
REG
>>>> is still set to default with 2.6.28.
>>>>
>>>> 14b9815af3f4fe0e171ee0c4325c31d2a2c1570b
>>>> Author: Luis R. Rodriguez <lrodriguez@atheros.com>
>>>> Date: =C2=A0 Wed Nov 12 14:22:03 2008 -0800
>>>>
>>>> =C2=A0 =C2=A0cfg80211: add support for custom firmware regulatory =
solutions
>>>>
>>>> =C2=A0 =C2=A0This adds API to cfg80211 to allow wireless drivers t=
o inform
>>>> =C2=A0 =C2=A0us if their firmware can handle regulatory considerat=
ions *and*
>>>> =C2=A0 =C2=A0they cannot map these regulatory domains to an ISO / =
IEC 3166
>>>> =C2=A0 =C2=A0alpha2. In these cases we skip the first regulatory h=
int instead
>>>> =C2=A0 =C2=A0of expecting the driver to build their own regulatory=
 structure,
>>>> =C2=A0 =C2=A0providing us with an alpha2, or using the reg_notifie=
r().
>>>>
>>>> =C2=A0 =C2=A0Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.=
com>
>>>> =C2=A0 =C2=A0Acked-by: Zhu Yi <yi.zhu@intel.com>
>>>> =C2=A0 =C2=A0Signed-off-by: John W. Linville <linville@tuxdriver.c=
om>
>>> Could you please also add commit
>>> ea4a82dceec7b5782b1259079c8de508d0afe33a? This is the commit that
>>> enables the Intel cards to take advantage of the parameter introduc=
ed in
>>> previous commit.
>>>
>>> commit ea4a82dceec7b5782b1259079c8de508d0afe33a
>>> Author: Luis R. Rodriguez <lrodriguez@atheros.com>
>>> Date: =C2=A0 Wed Nov 12 14:22:04 2008 -0800
>>>
>>> =C2=A0 =C2=A0iwlwifi: enable custom fw regulatory solution
>>>
>>> =C2=A0 =C2=A0This enables the custom firmware regulatory solution o=
ption
>>> =C2=A0 =C2=A0on iwlwifi drivers. These devices are uncapable of map=
ping their
>>> =C2=A0 =C2=A0EEPROM regulatory domain to a specific ISO / IEC alpha=
2.
>>> =C2=A0 =C2=A0Although the new 11n devices (>=3D iwl 5000) have only
>>> =C2=A0 =C2=A03 regultaory SKUs -- MOW, ABG (no N) and BG -- the old=
er
>>> =C2=A0 =C2=A0devices (3945 and 4965) have a more complex SKU arrang=
ement
>>> =C2=A0 =C2=A0and therefore its not practical to move this to the dr=
iver.
>>>
>>> =C2=A0 =C2=A0Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.c=
om>
>>> =C2=A0 =C2=A0Acked-by: Zhu Yi <yi.zhu@intel.com>
>>> =C2=A0 =C2=A0Signed-off-by: John W. Linville <linville@tuxdriver.co=
m>
>>
>> Doh yes that would be required or it would make this pointless.
>>
>> =C2=A0 Luis
>>
>
> Looks like it requires a preparatory commit:
>
> commit f3b407fba52e1b86ca286ee7c218a4fb00bd29e0
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date: =C2=A0 Tue Oct 21 09:57:41 2008 +0200
>
> =C2=A0 =C2=A0wireless: remove cfg80211_reg_mutex
>
> =C2=A0 =C2=A0This mutex is wrong, we use cfg80211_drv_mutex (which sh=
ould
> =C2=A0 =C2=A0possibly be renamed to just cfg80211_mutex) everywhere e=
xcept
> =C2=A0 =C2=A0in one place, fix that and get rid of the extra mutex.
>
> =C2=A0 =C2=A0Also get rid of a spurious regulatory_requests list defi=
nition.
>
> =C2=A0 =C2=A0Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> =C2=A0 =C2=A0Signed-off-by: John W. Linville <linville@tuxdriver.com>

Ah crap. This may be too much for stable. Did you get a hang without
it? Or is it not applying cleanly? If the later then a port may be
required.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
