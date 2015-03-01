Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:58247 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbbCARMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 12:12:55 -0500
Date: Sun, 1 Mar 2015 19:12:52 +0200
From: Jouni Malinen <j@w1.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Multiple-BSSID issues with hostapd
Message-ID: <20150301171252.GA18568@w1.fi> (sfid-20150301_181437_698081_D6A9775C)
References: <54784001.7020706@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54784001.7020706@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 28, 2014 at 10:27:29AM +0100, Arend van Spriel wrote:
> For the brcmfmac we started working on Multiple-BSSID support and came
> across some issues with hostapd that are listed listed below.

Did you get test these with a more recent hostapd version (ideally,
hostap.git master branch snapshot)? I was unable to reproduce either
issue..

> BSS1 setup on netdev wlan0
> BSS2 setup on netdev wlan0_0
> 
> * get_station() done on wrong netdev
> 
> observed:
> Upon association of STA1 with BSS2 (wlan0_0) a get_station() is done for
> STA1 with wlan0 as netdev.
> expected:
> get_station() for STA1 with wlan0_0 as netdev. We verified that wlan0_0
> ifindex was used in NL80211_CMD_NEW_STATION event.

I'm not sure which get_station operation would happen upon association..
Anyway, hostapd uses get_station() to fetch STA statistics for
accounting and inactivity checking. The former can be triggered through
control interface, so I used that to test this. In multi-BSS
configuration, NL80211_CMD_GET_STATION was issued to the correct ifindex
depending on which BSS the STA was associated with.

> * cleanup of wlan0_0 not done upon terminating hostapd
> 
> observed:
> Upon terminating hostapd, only change interface from AP->STA is received
> for wlan0_0 and wlan0. The stop_ap is only done for BSS1. So ending up
> with additional netdev, ie. wlan0_0.
> expected:
> following sequence seems more appropriate:
> stop_ap() for BSS2
> if_remove() for BSS2
> stop_ap() for BSS1
> if_change() AP->STA for BSS1

All dynamically added interfaces get removed in my tests.

> Do you think it makes sense to correct these scenarios according the
> described expected behaviour? Maybe the behaviour is only expected by me
> and there is a good reason for the current behaviour.

Your expectation sounds correct and that matches what I see hostapd
doing currently..

-- 
Jouni Malinen                                            PGP id EFC895FA
