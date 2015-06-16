Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39772 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbbFPHIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 03:08:50 -0400
Message-ID: <1434438520.2337.7.camel@sipsolutions.net> (sfid-20150616_090855_559764_2F331F69)
Subject: Re: [RFC] ath9k: advertise p2p dev support when chanctx
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Felix Fietkau <nbd@openwrt.org>, Jouni Malinen <j@w1.fi>
Date: Tue, 16 Jun 2015 09:08:40 +0200
In-Reply-To: <CALhHN=rEf0cR211Vizkb2xcbxSseda_6w1Uibs3DVD0GSXAq2w@mail.gmail.com> (sfid-20150616_083056_853720_6BA9919F)
References: <1433913034-17801-1-git-send-email-janusz.dziedzic@tieto.com>
	 <21886.43539.833126.629494@gargle.gargle.HOWL>
	 <CALhHN=pUKuXAEb3JEEVTHATEHhvoLe52QDh-pixiS9oUo=6j6Q@mail.gmail.com>
	 <21886.62363.946771.345441@gargle.gargle.HOWL>
	 <557F1716.3040204@broadcom.com>
	 <21887.31486.302760.504336@gargle.gargle.HOWL>
	 <CALhHN=rEf0cR211Vizkb2xcbxSseda_6w1Uibs3DVD0GSXAq2w@mail.gmail.com>
	 (sfid-20150616_083056_853720_6BA9919F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-16 at 08:30 +0200, Janusz Dziedzic wrote:

> Other fix I can image is change wpa_supplicant and add
> NL80211_SCAN_FLAG_AP to p2p_find, and set in ath9k driver
> wiphy->features |= NL80211_FEATURE_AP_SCAN;
> 
> NL80211_FEATURE_AP_SCAN is not set when use_chanctx=1
> 
> I am not sure which is better. First one required only fix in ath9k,
> second one also required changes in wpa_supplicant.

It would be unfortunate if a driver change required wpa_s changes. It
doesn't seem so bad to add p2p-device support to the driver, after all,
there isn't much it needs to do for that.

This seems like a strange quirk though - you can normally not do any p2p
operation when already operating as soft-AP (without P2P-device), no?

johannes

