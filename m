Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:10376 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbbFOMbr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 08:31:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: enable VHT for IBSS
References: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com>
	<87mw06bab5.fsf@kamboji.qca.qualcomm.com>
	<CALhHN=pD+ROqjhYOXsjb7Dc=XGp+YZy6w445ipC4cOGOYUEA3g@mail.gmail.com>
Date: Mon, 15 Jun 2015 15:31:41 +0300
In-Reply-To: <CALhHN=pD+ROqjhYOXsjb7Dc=XGp+YZy6w445ipC4cOGOYUEA3g@mail.gmail.com>
	(Janusz Dziedzic's message of "Fri, 12 Jun 2015 07:12:05 +0200")
Message-ID: <87pp4x9mqa.fsf@kamboji.qca.qualcomm.com> (sfid-20150615_143151_284907_019F69AA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

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
>
> Results are for qca9888x.
> But IBSS (VHT IBSS) works correctly also with qca6174 FW.

Ok, thanks. I added this info to the commit log in the pending branch.

>> Oh, we should still add ATH10K_FW_FEATURE_NO_ADHOC so that we can
>> disable ad-hoc on 10.x firmwares. Anyone have some spare time to cook up
>> a patch?
>>
> I am not sure we need this, while we add
> ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC)
> only for main and tlv version. Seems we already cover 10.x case correctly.

Ah, I had forgotten that. Good that we have that.

-- 
Kalle Valo
