Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37160 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbbFLFMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 01:12:06 -0400
Received: by wifx6 with SMTP id x6so5753268wif.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 22:12:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mw06bab5.fsf@kamboji.qca.qualcomm.com>
References: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com>
	<87mw06bab5.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 12 Jun 2015 07:12:05 +0200
Message-ID: <CALhHN=pD+ROqjhYOXsjb7Dc=XGp+YZy6w445ipC4cOGOYUEA3g@mail.gmail.com> (sfid-20150612_071214_469625_0F7EF085)
Subject: Re: [PATCH v2] ath10k: enable VHT for IBSS
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 June 2015 at 16:15, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> Enable VHT support for IBSS, while mac80211/cfg80211 and
>> wpa_supplicant already support this.
>>
>> In my test env, ath10k 2x2 I get:
>> (udp) ath10k-1 >>>> ath10k-2 (server) -  speed: 419 Mbits/sec
>> (tcp) ath10k-1 >>>> ath10k-2 (server) -  speed: 404 Mbits/sec
>
> What hw and firmware version? Do you expect this to work with both
> qca988x and qca6174?
>
Results are for qca9888x.
But IBSS (VHT IBSS) works correctly also with qca6174 FW.

> Oh, we should still add ATH10K_FW_FEATURE_NO_ADHOC so that we can
> disable ad-hoc on 10.x firmwares. Anyone have some spare time to cook up
> a patch?
>
I am not sure we need this, while we add
ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC)
only for main and tlv version. Seems we already cover 10.x case correctly.


>> During tests I used wpa_supplicant (current version)
>
> Better to say "current git version" (if that's what you mean).
>
> --
> Kalle Valo
