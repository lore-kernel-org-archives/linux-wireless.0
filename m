Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f31.google.com ([209.85.219.31]:41843 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZBKUrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 15:47:16 -0500
Received: by ewy12 with SMTP id 12so88880ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 12:47:13 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Feb 2009 21:47:13 +0100
Message-ID: <2d14e2ca0902111247s7c816865g50db1e65cc4fd9ae@mail.gmail.com> (sfid-20090211_214719_799807_5D48DB32)
Subject: Radar Detection and DFS status
From: mementux <mementux@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I would like to make an outdoor radio link at 5GHz between my house
and one of my neighbors. Because I live near an airport, I've looked
for European in force regulation regarding radar detection. I've
discovered that ETSI has released a new normative on Dicember 2008 (EN
301 893 v1.5). This normative requires that WLAN devices with DFS
capability must detect pulse width down to 0.8us across the bands from
5250 to 5350MHz and from 5470 to 5725 MHz; moreover they must detect
staggered Pulse Repetition Frequency (PRF) radars with 3 PRF value (I
don't excactly know what it means).

I have two devices with Atheros 5414 radio module, so I've looked for
support of radar detection (and 802.11h) in madwifi driver. I've seen
that the -dfs branch supports the EN 301 893 v1.4.1 and it implements
802.11h protocol. Looking into the madwifi-dfs code I've seen that the
hardware does the pulse detection and the driver detects the radar
recognizing the pulse patterns (ath/if_ath_radar.c and
ath/if_ath_radar.h).

Because the pulse detection is done in hardware, I suppose that for
detecting pulse width down to 0.8us I need radio modules with newer
chipset like AR9xxx. Is it right? Can't I use my AR5414 radio modules?
So, I've searched in the code of ath9k and mac80211 but I don't find
any implementation of radar detection and 802.11h. Am I wrong? I've
read on http://wireless.kernel.org/en/users/Drivers/ath9k that 802.11h
is a feature of ath9k driver (and consecutively of mac80211, right?).

I there any way to make an outdoor radio link at 5GHz compliant to the
European regulation with Linux? :-)

Thanks,
Albert.
