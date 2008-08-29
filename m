Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:47520 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbYH2Iie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 04:38:34 -0400
Date: Fri, 29 Aug 2008 11:37:41 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: VLAN testing (and mac80211_hwsim test cases in general)
Message-ID: <20080829083740.GA6083@jm.kir.nu> (sfid-20080829_103839_221085_9826A602)
References: <20080617154008.883383150@localhost> <1215625246.3246.40.camel@johannes.berg> <1215626936.3246.45.camel@johannes.berg> <20080828160401.GG4863@jm.kir.nu> <1219995211.25321.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1219995211.25321.24.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 29, 2008 at 09:33:31AM +0200, Johannes Berg wrote:

> Awesome, thanks. I'll look at the code, it seems to me that I actually
> want to be able to configure to not reject unknown stations but put them
> into their own VLAN, or something, then this feature could actually be
> useful in production.

That would require a bit more code to have the default VLAN ID for
unknown STAs stored somewhere, but that should be relatively small
change to hostapd with all the other VLAN ID processing available.

> The validation is a bit harder, you can listen for wext events, but you
> can't even try pinging between the interfaces... Maybe the validation
> should check what's going on on the "air".

debugfs provides some help for things like VLAN (or well, would provide,
if we actually showed that information there ;-), but that can be easily
added). As far as data packets are concerned, we could implement a
simple "ping" program that uses packet sockets to send some data (and
reply to specific messages). This can then by-pass the issues with IP
and local interface.

It would be useful to have a tool that processes hwsim0 dump, though,
and provides a language for writing "expect scripts" for 802.11
(+radiotap) frames.. For example, something like "EXPECT ProbeReq CHAN=1
SRC=<mac> DST=<bcast>; EXPECT ProbeResp CHAN=1 SRC=<bssid> DST=<mac>"
and so on.. That tool would then write a report on what happened and
provided pass/fail result based on requirements in the script.

-- 
Jouni Malinen                                            PGP id EFC895FA
