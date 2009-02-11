Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:5331 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZBKVl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 16:41:26 -0500
Received: by rn-out-0910.google.com with SMTP id k40so448374rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 13:41:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2d14e2ca0902110900r7f0b84e4k7be81827187c434@mail.gmail.com>
References: <2d14e2ca0902110900r7f0b84e4k7be81827187c434@mail.gmail.com>
Date: Wed, 11 Feb 2009 13:41:25 -0800
Message-ID: <43e72e890902111341l36bd40c8o9d54515e8b06e603@mail.gmail.com> (sfid-20090211_224131_552427_AB50FA90)
Subject: Re: [ath9k-devel] Radar Detection and DFS status
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: mementux <mementux@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Michael Green <Michael.Green@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/11 mementux <mementux@gmail.com>:
> Hi!
>
> I would like to make an outdoor radio link at 5GHz between my house and one
> of my neighbors. Because I live near an airport, I've looked for European in
> force regulation regarding radar detection. I've discovered that ETSI has
> released a new normative on Dicember 2008 (EN 301 893 v1.5). This normative
> requires that WLAN devices with DFS capability must detect pulse width down
> to 0.8us across the bands from 5250 to 5350MHz and from 5470 to 5725 MHz;
> moreover they must detect staggered Pulse Repetition Frequency (PRF) radars
> with 3 PRF value (I don't excactly know what it means).
>
> I have two devices with Atheros 5414 radio module, so I've looked for
> support of radar detection (and 802.11h) in madwifi driver. I've seen that
> the -dfs branch supports the EN 301 893 v1.4.1 and it implements 802.11h
> protocol. Looking into the madwifi-dfs code I've seen that the hardware does
> the pulse detection and the driver detects the radar recognizing the pulse
> patterns (ath/if_ath_radar.c and ath/if_ath_radar.h).
>
> Because the pulse detection is done in hardware, I suppose that for
> detecting pulse width down to 0.8us I need radio modules with newer chipset
> like AR9xxx. Is it right? Can't I use my AR5414 radio modules?
> So, I've searched in the code of ath9k and mac80211 but I don't find any
> implementation of radar detection and 802.11h. Am I wrong? I've read on
> http://wireless.kernel.org/en/users/Drivers/ath9k that 802.11h is a feature
> of ath9k driver (and consecutively of mac80211, right?).
>
> I there any way to make an outdoor radio link at 5GHz compliant to the
> European regulation with Linux? :-)

mac80211 or ath9k does not yet have radar detection support so
therefore no mac80211 driver will allow you to use any beaconing mode
(AP | IBSS | Mesh) mode on DFS channels yet.

Note that not all 5 GHz channels require radar detection though so you
could try using one of the non-DFS channels. Check 'iw list' for that.

ath9k STA should work with DFS but I didn't work on that myself so
will leave someone else to comment on that.

  Luis
