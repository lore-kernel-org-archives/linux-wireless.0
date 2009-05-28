Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:60846 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103AbZE1O6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 10:58:07 -0400
Date: Thu, 28 May 2009 17:58:04 +0300
From: Jouni Malinen <j@w1.fi>
To: Reiner Herrmann <reiner@reiner-h.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211_hwsim: Problem setting up communication
Message-ID: <20090528145804.GA32743@jm.kir.nu>
References: <4A1E448E.1030201@reiner-h.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A1E448E.1030201@reiner-h.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 28, 2009 at 10:00:14AM +0200, Reiner Herrmann wrote:

> I want to use mac80211_hwsim (from kernel 2.6.30-rc6) for some testing,
> but I can't get the two interfaces to communicate with each other.

> # ifconfig wlan0 10.0.0.1 up
> # ifconfig wlan1 10.0.0.2 up
> 
> wlan1 can successfully associate, but I can't reach any interface via
> the other:
> 
> # ping -I wlan0 10.0.0.2
> PING 10.0.0.2 (10.0.0.2) from 10.0.0.1 wlan0: 56(84) bytes of data.
> >From 10.0.0.1 icmp_seq=1 Destination Host Unreachable

Linux IP/networking stack does not really seem to like connections
between local interfaces unless this goes through lo.. Or well, at least
I haven't figured out how to configure this without some kernel code
changes. It would be kind of nice to get this working, but anyway, I
made a small program for checking both unicast and broadcast
communications for this type of use: hwsim_test from
http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=tree;f=mac80211_hwsim/tools

(it uses packet sockets bound to the interface and does not rely on the
kernel IP stack)

-- 
Jouni Malinen                                            PGP id EFC895FA
