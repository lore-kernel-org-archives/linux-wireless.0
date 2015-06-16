Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33371 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbbFPHxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 03:53:48 -0400
Received: by padev16 with SMTP id ev16so7869056pad.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2015 00:53:48 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21887.54766.992305.532815@gargle.gargle.HOWL> (sfid-20150616_095402_705359_CEC0BE9F)
Date: Tue, 16 Jun 2015 13:23:18 +0530
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Felix Fietkau <nbd@openwrt.org>, Jouni Malinen <j@w1.fi>
Subject: Re: [RFC] ath9k: advertise p2p dev support when chanctx
In-Reply-To: <CALhHN=rEf0cR211Vizkb2xcbxSseda_6w1Uibs3DVD0GSXAq2w@mail.gmail.com>
References: <1433913034-17801-1-git-send-email-janusz.dziedzic@tieto.com>
	<21886.43539.833126.629494@gargle.gargle.HOWL>
	<CALhHN=pUKuXAEb3JEEVTHATEHhvoLe52QDh-pixiS9oUo=6j6Q@mail.gmail.com>
	<21886.62363.946771.345441@gargle.gargle.HOWL>
	<557F1716.3040204@broadcom.com>
	<21887.31486.302760.504336@gargle.gargle.HOWL>
	<CALhHN=rEf0cR211Vizkb2xcbxSseda_6w1Uibs3DVD0GSXAq2w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic wrote:
> Works except case I described.
> p2p_find is combination of scan and ROC, and scan don't work when we
> have configured AP from wpa_supplicant.
> In case of adding p2p-device AP + P2P_FIND works perfectly, also AP +
> P2P_CLIENT/P2P_GO works OK when use_chanctx.
> 
> Other fix I can image is change wpa_supplicant and add
> NL80211_SCAN_FLAG_AP to p2p_find, and set in ath9k driver
> wiphy->features |= NL80211_FEATURE_AP_SCAN;
> 
> NL80211_FEATURE_AP_SCAN is not set when use_chanctx=1
> 
> I am not sure which is better. First one required only fix in ath9k,
> second one also required changes in wpa_supplicant.

As Johannes mentioned in his email, adding p2p-device support
in ath9k is the simpler solution, without adding driver-specific
hacks to wpa_s. So this patch seems okay...

Sujith
