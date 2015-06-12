Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33235 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbbFLNdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 09:33:35 -0400
Message-ID: <557ADFAD.5080004@candelatech.com> (sfid-20150612_153339_032156_BE034F3F)
Date: Fri, 12 Jun 2015 06:33:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: enable VHT for IBSS
References: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com> <87mw06bab5.fsf@kamboji.qca.qualcomm.com> <CALhHN=pD+ROqjhYOXsjb7Dc=XGp+YZy6w445ipC4cOGOYUEA3g@mail.gmail.com>
In-Reply-To: <CALhHN=pD+ROqjhYOXsjb7Dc=XGp+YZy6w445ipC4cOGOYUEA3g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/11/2015 10:12 PM, Janusz Dziedzic wrote:
> On 11 June 2015 at 16:15, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>>
>>> Enable VHT support for IBSS, while mac80211/cfg80211 and
>>> wpa_supplicant already support this.
>>>
>>> In my test env, ath10k 2x2 I get:
>>> (udp) ath10k-1 >>>> ath10k-2 (server) -  speed: 419 Mbits/sec
>>> (tcp) ath10k-1 >>>> ath10k-2 (server) -  speed: 404 Mbits/sec
>>
>> What hw and firmware version? Do you expect this to work with both
>> qca988x and qca6174?
>>
> Results are for qca9888x.
> But IBSS (VHT IBSS) works correctly also with qca6174 FW.
>
>> Oh, we should still add ATH10K_FW_FEATURE_NO_ADHOC so that we can
>> disable ad-hoc on 10.x firmwares. Anyone have some spare time to cook up
>> a patch?
>>
> I am not sure we need this, while we add
> ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC)
> only for main and tlv version. Seems we already cover 10.x case correctly.

If you give me some way to advertise my CT 10.1 firmware supports ADHOC
mode in the upstream driver then there will be one more firmware
variant that works with IBSS in stock kernels....

Maybe a feature flag 'ATH10K_FW_FEATURE_SUPPORTS_ADHOC' ?  You can special case
older firmware that is known to support ADHOC but has no feature
flag for it.  And new firmware could add the feature flag as needed.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
