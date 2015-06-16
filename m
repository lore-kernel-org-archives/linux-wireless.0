Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35368 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbbFPGaw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 02:30:52 -0400
Received: by wgbhy7 with SMTP id hy7so4677776wgb.2
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2015 23:30:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21887.31486.302760.504336@gargle.gargle.HOWL>
References: <1433913034-17801-1-git-send-email-janusz.dziedzic@tieto.com>
	<21886.43539.833126.629494@gargle.gargle.HOWL>
	<CALhHN=pUKuXAEb3JEEVTHATEHhvoLe52QDh-pixiS9oUo=6j6Q@mail.gmail.com>
	<21886.62363.946771.345441@gargle.gargle.HOWL>
	<557F1716.3040204@broadcom.com>
	<21887.31486.302760.504336@gargle.gargle.HOWL>
Date: Tue, 16 Jun 2015 08:30:51 +0200
Message-ID: <CALhHN=rEf0cR211Vizkb2xcbxSseda_6w1Uibs3DVD0GSXAq2w@mail.gmail.com> (sfid-20150616_083056_853720_6BA9919F)
Subject: Re: [RFC] ath9k: advertise p2p dev support when chanctx
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Felix Fietkau <nbd@openwrt.org>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 June 2015 at 03:25, Sujith Manoharan <sujith@msujith.org> wrote:
> Arend van Spriel wrote:
>> The p2p-device is designed to be used for p2p discovery and p2p action
>> frame exchange. It make it easier for driver and/or firmware to
>> determine if user-space request is p2p related or not. However, in
>> discussions with Jouni I got the impression that ath (or qca) firmware
>> and/or drivers did not need this design. Not sure if that claim is
>> unaffected by the "use_chanctx=1" parameter.
>
> Thanks for the explanation.
>
> I don't think advertising support for p2p-device is required for
> ath9k. P2P discovery works properly with the normal station/ap interface
> types and the 'use_chanctx' modparam simply enables multiple channel
> contexts.
>
Works except case I described.
p2p_find is combination of scan and ROC, and scan don't work when we
have configured AP from wpa_supplicant.
In case of adding p2p-device AP + P2P_FIND works perfectly, also AP +
P2P_CLIENT/P2P_GO works OK when use_chanctx.

Other fix I can image is change wpa_supplicant and add
NL80211_SCAN_FLAG_AP to p2p_find, and set in ath9k driver
wiphy->features |= NL80211_FEATURE_AP_SCAN;

NL80211_FEATURE_AP_SCAN is not set when use_chanctx=1

I am not sure which is better. First one required only fix in ath9k,
second one also required changes in wpa_supplicant.

BR
Janusz
