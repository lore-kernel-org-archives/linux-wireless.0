Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42360 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751908AbeB0KEw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 05:04:52 -0500
Message-ID: <1519725888.4086.3.camel@sipsolutions.net> (sfid-20180227_110625_030319_2096EAF3)
Subject: Re: [PATCH] Revert "mac80211: use QoS NDP for AP probing"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Caradoc-Davies <ben@transient.nz>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Feb 2018 11:04:48 +0100
In-Reply-To: <20180225211541.29931-1-ben@transient.nz> (sfid-20180225_225013_392018_37030F79)
References: <20180225211541.29931-1-ben@transient.nz>
         (sfid-20180225_225013_392018_37030F79)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-26 at 10:15 +1300, Ben Caradoc-Davies wrote:
> This reverts commit 7b6ddeaf27eca72795ceeae2f0f347db1b5f9a30.
> 
> The above commit causes an Atheros AR9271 ath9k_htc USB WiFi adapter
> connected to an AP with QoS/WME enabled to lose all IP connectivity after
> something like 10 to 90 minutes. The adapter remains up and associated
> and "iw dev wlan0 station dump" shows byte and packet counters that keep
> increasing, but all IP connectivity fails, including ping, DNS, and web.
> The host cannot be pinged by other hosts on the WLAN. Network can be
> restored by unloading and reloading the ath9k_htc module, or physically
> unplugging and replugging the adapter, triggering NetworkManager to
> reconnect.
> 
> The problematic commit is on torvalds/master and linux-stable/linux-4.15.y.
> On linux-stable/linux-4.14.y: e23090a7d8f05f03cf564148472130286f5ca9bf.
> 
> Problem confirmed on Debian linux-image-4.14.0-3-amd64 4.14.17-1 and
> Debian linux-image-4.15.0-1-amd64 4.15.4-1 and vanilla 4.14.16
> (git e23090a7d8f0 from linux-stable/linux-4.14.y) and vanilla 4.16.0-rc2
> (git 3664ce2d9309 from torvalds/master).
> 
> Fix tested by reverting the commit on vanilla 4.16.0-rc2 (git 3664ce2d9309
> from torvalds/master) and applying the patch to Debian
> linux-image-4.15.0-1-amd64 4.15.4-1. Both tests resulted in stable IP
> connectivity.
> 
> See also Debian Bug#891060:
> Atheros AR9271 ath9k_htc USB WiFi connected but IP traffic stops
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=891060

It seems to be a particular driver problem, so blindly reverting seems
a bit heavy-handed.

Using non-QoS NDP also isn't nice to the AP (and I'm not even sure it's
in spec), since we expect QoS frames from a QoS/WMM-capable station.

Perhaps we can set some sort of flag in the driver that says "don't use
QoS" frames. In fact, ath9k already says it doesn't like QoS frames:

-		skb = ieee80211_nullfunc_get(sc->hw, vif, false);

so which place creates them?


Either way, I don't think we should just plain revert, better to
identify why ath9k is hitting these code paths to start with (since it
does say "false" there, which means no QoS), and if needed add a
workaround flag to the driver that also documents that something's
broken with the driver(/firmware?)/hardware.

johannes
