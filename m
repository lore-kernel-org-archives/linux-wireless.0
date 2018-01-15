Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.uni-rostock.de ([139.30.22.72]:49351 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935239AbeAOOsJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 09:48:09 -0500
Subject: Re: [PATCH v3 4/5] mac80211_hwsim: add permanent mac address option
 for new radios
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
 <6596c1d9-da4f-4d83-bd5e-5e276391a0c9@MAIL2.uni-rostock.de>
 <1516018472.410.16.camel@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <3dd7a66e-1b55-0300-b04e-489ed1163b96@uni-rostock.de> (sfid-20180115_154813_477042_131AC723)
Date: Mon, 15 Jan 2018 15:48:06 +0100
MIME-Version: 1.0
In-Reply-To: <1516018472.410.16.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 15.01.2018 um 13:14 schrieb Johannes Berg:
> On Wed, 2018-01-10 at 17:42 +0100, Benjamin Beichler wrote:
>> =20
>> +	if (info->attrs[HWSIM_ATTR_PERM_ADDR]) {
>> +		if (nla_len(info->attrs[HWSIM_ATTR_PERM_ADDR]) !=3D ETH_ALEN) {
>> +			pr_debug("mac80211_hwsim: MAC has wrong size\n");
>> +			return -EINVAL;
>> +		}
> Oh, also - don't do this.
>
> 1) don't print, use NL_SET_ERR_MSG().
Ok, I only adapted the code already there, but I change this.
>
> 2) use the policy to validate lengths
Yeah, of course I change that, much easier -.-

>
>> +		if (!is_local_ether_addr(
>> +				nla_data(info->attrs[HWSIM_ATTR_PERM_ADDR]))) {
>> +			pr_debug("mac80211_hwsim: MAC is not locally administered\n");
>> +			return -EINVAL;
>> +		}
> This doesn't really matter - it's purely virtual. I think we can avoid
> that.
>
>> +		if (get_hwsim_data_ref_from_addr(
>> +				nla_data(info->attrs[HWSIM_ATTR_PERM_ADDR]))) {
>> +			pr_debug("mac80211_hwsim: perm MAC already in use\n");
>> +			return -EINVAL;
>> +		}
> This is racy afaict - remove it and return a clash later when you fail
> to insert the new radio.
Ehm yes, actually exactly this test is already in the rhashtable patch.
But maybe I should also change there the error print to a NL_ERR_MSG() ?

>
> johannes
>

--=20
M.Sc. Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrote=
chnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/
