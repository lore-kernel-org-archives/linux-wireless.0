Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:35802 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab0GJSi1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jul 2010 14:38:27 -0400
Message-ID: <4C38BE1D.2020107@openwrt.org>
Date: Sat, 10 Jul 2010 20:38:21 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Norman Henderson <norm.audrey@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Issues with ath9k dropping connectivity - now no connectivity
References: <AANLkTilq_VFbOPHmMuf1EFmewc_WBBpgvW0t7ogZdbdl@mail.gmail.com>
In-Reply-To: <AANLkTilq_VFbOPHmMuf1EFmewc_WBBpgvW0t7ogZdbdl@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-10 8:32 PM, Norman Henderson wrote:
> Hi,
> 
> I'm a bit new to all of this - here's the short story. I would
> appreciate any help available!
> 
> I was building a WAP using a PC Engines ALIX board (AMD Geode LX800),
> DNMA92 wireless card (Atheros 92xx) and Voyage Linux (based on Debian
> Lenny, 2.6.30 kernel with hostapd 0.6.9 and libnl1.1). It was all
> working but, the wireless card would drop connectivity for no apparent
> reason after an undetermined time (minutes to hours). Stations (Win or
> cellphone) would no longer see it at all, as if it was no longer
> transmitting.
> 
> The Voyage maintainer advised that ath9k isn't that stable at 2.6.30.
> So, I upgraded the kernel to 2.6.32 using the Debian Lenny backport. I
> then installed the "stable" compat-wireless, 2.6.32.16.
> 
> Hostapd appears to start OK. However, the wireless SSID is only
> visible to the Windows clients for a short time - seconds/minutes -
> and they aren't able to connect. There were no errors in the hostapd
> startup and it does its key rotations periodically. All that's logged
> from hostapd -dd during the actual time that the Win clients can see
> it and are trying to connect is:
> 1278785975.350851: STA 00:13:02:be:7b:f9 sent probe request for broadcast SSID
> 1278785975.353034: MGMT (TX callback) ACK
> 1278785975.353073: mgmt::proberesp cb
> (repeated a few times)
> 
> The Win7 station used to connect automatically but now doesn't and
> when I click "connect" it fails and shortly thereafter the SSID
> disappears from the list.
> 
> Nothing in /var/log. iw phy phy0 info and iw dev wlan0 info appear to
> report sensible info as does iwconfig.
> 
> During boot I do get messages about "VIA Padlock Hash Engine not detected" and
> modprobe: FATAL: Error inserting padlock_sha
> (/lib/modules/2.6.32-bpo.5-686/kern...): No such device
> From googling it's not clear to me at least whether this is relevant.
> 
> Suggestions? What further diagnostics could I do?
I'd suggest using a 'bleeding edge' compat-wireless along with hostapd
version 0.7.2.

In OpenWrt we're using a compat-wireless based on wireless-testing
2010-07-06, along with two ath9k patches that were merged in a later
version.

According to my own testing and various user feedback, this is the most
stable version that we had so far.

I think 2.6.36 is probably going to be the first Linux Kernel version
with ath9k working in AP mode *reliably*.

- Felix
