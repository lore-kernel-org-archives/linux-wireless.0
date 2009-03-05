Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:62778 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbZCETYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 14:24:30 -0500
Received: by yx-out-2324.google.com with SMTP id 8so65990yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 11:24:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1236275668.6612.134.camel@rc-desk>
References: <43e72e890903041335n47a70186u4a7aeb304f8b6979@mail.gmail.com>
	 <1236275668.6612.134.camel@rc-desk>
Date: Thu, 5 Mar 2009 11:24:27 -0800
Message-ID: <43e72e890903051124t42ce5c7blfd741da4a2b4fa79@mail.gmail.com> (sfid-20090305_202457_907620_AEA5C31F)
Subject: Re: Please apply to stable: cfg80211: add support for custom firmware
	regulatory solutions
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "stable@kernel.org" <stable@kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 5, 2009 at 9:54 AM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Wed, 2009-03-04 at 13:35 -0800, Luis R. Rodriguez wrote:
>> Forgot to Cc: stable@kernel.org for this patch during its submission=
,
>> this is needed on 2.6.28 as otherwise there is an issue for Intel
>> cards which get their channels 5 GHz disabled if OLD_REG is set to n=
o
>> (this is not the default) or the channels 12-14 are disabled if
>> OLD_REG is set to yes (default) set to no and the ieee80211_module
>> parameter is not used. The later issue is resolved by userspace as
>> well but we cannot yet expect 2.6.28 kernels to have enough userspac=
e
>> interfaces to set the regulatory domain just yet. This is why OLD_RE=
G
>> is still set to default with 2.6.28.
>>
>> 14b9815af3f4fe0e171ee0c4325c31d2a2c1570b
>> Author: Luis R. Rodriguez <lrodriguez@atheros.com>
>> Date: =C2=A0 Wed Nov 12 14:22:03 2008 -0800
>>
>> =C2=A0 =C2=A0cfg80211: add support for custom firmware regulatory so=
lutions
>>
>> =C2=A0 =C2=A0This adds API to cfg80211 to allow wireless drivers to =
inform
>> =C2=A0 =C2=A0us if their firmware can handle regulatory consideratio=
ns *and*
>> =C2=A0 =C2=A0they cannot map these regulatory domains to an ISO / IE=
C 3166
>> =C2=A0 =C2=A0alpha2. In these cases we skip the first regulatory hin=
t instead
>> =C2=A0 =C2=A0of expecting the driver to build their own regulatory s=
tructure,
>> =C2=A0 =C2=A0providing us with an alpha2, or using the reg_notifier(=
).
>>
>> =C2=A0 =C2=A0Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.co=
m>
>> =C2=A0 =C2=A0Acked-by: Zhu Yi <yi.zhu@intel.com>
>> =C2=A0 =C2=A0Signed-off-by: John W. Linville <linville@tuxdriver.com=
>
>
> Could you please also add commit
> ea4a82dceec7b5782b1259079c8de508d0afe33a? This is the commit that
> enables the Intel cards to take advantage of the parameter introduced=
 in
> previous commit.
>
> commit ea4a82dceec7b5782b1259079c8de508d0afe33a
> Author: Luis R. Rodriguez <lrodriguez@atheros.com>
> Date: =C2=A0 Wed Nov 12 14:22:04 2008 -0800
>
> =C2=A0 =C2=A0iwlwifi: enable custom fw regulatory solution
>
> =C2=A0 =C2=A0This enables the custom firmware regulatory solution opt=
ion
> =C2=A0 =C2=A0on iwlwifi drivers. These devices are uncapable of mappi=
ng their
> =C2=A0 =C2=A0EEPROM regulatory domain to a specific ISO / IEC alpha2.
> =C2=A0 =C2=A0Although the new 11n devices (>=3D iwl 5000) have only
> =C2=A0 =C2=A03 regultaory SKUs -- MOW, ABG (no N) and BG -- the older
> =C2=A0 =C2=A0devices (3945 and 4965) have a more complex SKU arrangem=
ent
> =C2=A0 =C2=A0and therefore its not practical to move this to the driv=
er.
>
> =C2=A0 =C2=A0Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com=
>
> =C2=A0 =C2=A0Acked-by: Zhu Yi <yi.zhu@intel.com>
> =C2=A0 =C2=A0Signed-off-by: John W. Linville <linville@tuxdriver.com>

Doh yes that would be required or it would make this pointless.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
