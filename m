Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45274 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab1FPCLz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 22:11:55 -0400
Message-ID: <4DF96668.3040007@openwrt.org> (sfid-20110616_041200_567206_599DDB82)
Date: Thu, 16 Jun 2011 04:11:52 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k WDS panic without CONFIG_ATH9K_RATE_CONTROL
References: <4DF93116.700@gnu.org>
In-Reply-To: <4DF93116.700@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-06-16 12:24 AM, Pavel Roskin wrote:
> Hello!
>
> I'm trying to implement WDS support in ath5k, but I have found that the
> kernel would panic when I bring the interface up:
>
> modprobe ath5k
> iwconfig wlan0 mode repeater
> iw dev wlan0 set peer 00:01:02:03:04:05
> ifconfig wlan0 up
>
> There are many stack traces, but the first one comes from WARN_ON in
> rate_lowest_index().  I think it should really be BUG_ON (patch
> submitted separately), as returning an invalid index will surely lead to
> memory corruption.
>
> I tried WDS with ath9k and found that it doesn't crash the kernel if
> CONFIG_ATH9K_RATE_CONTROL is set.  However, if that setting is off in
> .config, I would get the same crash.
>
> It appears that rate_control_rate_init() is called in
> ieee80211_do_open() too early.  I think there should be some set on the
> rates assumed to be available on the WDS link for the given channel.
>
> Alternatively, the WDS interface should not be able to emit packets
> until either the rates are set manually with iw or they come from a
> beacon send by the peer.  The rate control algorithms should be able to
> deal with it.
Some time ago I sent some patches to fix the issues with WDS (and add 
support for HT, including aggregation).

These patches assume that you set up an AP on both sides alongside the 
WDS interface (beacons of the APs are used to exchange rates and 
capabilities).

http://thread.gmane.org/gmane.linux.kernel.wireless.general/70872

- Felix
