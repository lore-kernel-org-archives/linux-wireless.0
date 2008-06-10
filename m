Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4845 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbYFJM7K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 08:59:10 -0400
Date: Tue, 10 Jun 2008 08:30:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Subject: Re: mac80211_hwsim - simulator of 802.11 radios for mac80211
Message-ID: <20080610123007.GB1571@tuxdriver.com> (sfid-20080610_145914_933327_454CB0D7)
References: <20080610105058.GA6961@jm.kir.nu> <1213096575.3668.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213096575.3668.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2008 at 01:16:15PM +0200, Johannes Berg wrote:
> On Tue, 2008-06-10 at 13:50 +0300, Jouni Malinen wrote:
> > hostapd and wpa_supplicant include a test driver interface that allows
> > them to be tested on a single host without any wireless hardware for
> > development purposes. I have found this very valuable both for
> > developing new functionality and for testing existing code.
> > 
> > In order to provide similar mechanism for mac80211 developers and to
> > extend the scope of suitable test cases for hostapd/wpa_supplicant, I've
> > written a Linux kernel module that provides a similar test interface at
> > a lower layer. mac80211_hwsim simulates WLAN hardware and the air
> > interface between the radios by acting as a low-level radio driver for
> > mac80211. Neither mac80211 nor user space programs need any changes to
> > work with the simulated radios.
> 
> Way cool!
 
Yes, awesome!

> > The initial version of mac80211_hwsim is available from the
> > mac80211_hwsim subdirectory of my hostap Git tree:
> > git://w1.fi/srv/git/hostap.git
> > http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=tree;f=mac80211_hwsim
> > 
> > If there is interest in moving mac80211_hwsim module into the Linux
> > kernel tree, I'm open to doing that, too.
> 
> I think that would make sense, yes, especially since one look at the
> code already tells me that it needs to follow large API changes to work
> with the current mac80211.

ACK

> One thing that I'd like to add is a having a "global" monitor interface
> that is registered by the hwsim module and not mac80211 and shows all
> frames, regardless of channel etc.

That sounds like a great idea.  A mechanism for injecting frames from
an external source might be useful as well...?

Jouni this looks great.  Let's get this into the kernel.

John
-- 
John W. Linville
linville@tuxdriver.com
