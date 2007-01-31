Return-path: <wireless-bounces@tuxdriver.com>
Received: from mail7.sea5.speakeasy.net (mail7.sea5.speakeasy.net
	[69.17.117.9])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0V2qe9e003935
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 21:53:06 -0500
Date: Tue, 30 Jan 2007 18:52:34 -0800
From: Jouni Malinen <jkmaline@cc.hut.fi>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: SIOCGIWRANGE and dscape
Message-ID: <20070131025234.GB7061@jm.kir.nu>
References: <9e4733910701301636i18a21f31q421cc7d5c61f6c99@mail.gmail.com>
	<200701302012.23302.flamingice@sourmilk.net>
MIME-Version: 1.0
In-Reply-To: <200701302012.23302.flamingice@sourmilk.net>
Cc: wireless@lists.tuxdriver.org
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Sender: wireless-bounces@tuxdriver.com
Errors-To: wireless-bounces@tuxdriver.com

On Tue, Jan 30, 2007 at 08:12:19PM -0500, Michael Wu wrote:

> Fixing up giwrange is currently on my d80211 blockers todo list since it is 
> part of fixing wireless statistics reporting in d80211. Helper functions for 
> filling the channel lists is also somewhere on the todo list, though it isn't 
> on the blocker list. The driver currently has no way to indicate what 
> regulatory domain the hardware has stored in eeprom, and d80211 just assumes 
> FCC. (after all, d80211 isn't merge ready yet ;) Yes, basic driver regulatory 
> domain support is on my blocker todo list.

The simple workaround for client mode is indeed just assuming one
regulatory domain, but the original design of the Devicescape stack was
to use a user space component (hostapd in case of AP mode) to populate
the allowed channel information based on what the low-level driver
claims to support as far as channels are concerned and what is
configured for regulatory domain (in hostapd configuration).

> Listing rates and channels in giwrange should be easy - find the current mode, 
> and iterate through the list of channels and rates in there. Ignore any 
> channels which are not enabled. Count up all the enabled channels and stick 
> it in num_channels and num_frequency.

Yes, all the needed information for this particular part should already
be in net/d80211 and there is no need for low-level driver changes for
this. The separate question is on how the channel flags should be set
based on the current location of the device.

-- 
Jouni Malinen                                            PGP id EFC895FA
_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
