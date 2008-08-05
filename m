Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55239 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763824AbYHEWik (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 18:38:40 -0400
Subject: Re: [Orinoco-devel] [PATCH 00/19] orinoco: WPA for Agere based
	cards
From: Pavel Roskin <proski@gnu.org>
To: Dave <kilroyd@googlemail.com>
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <48978C25.601@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217822232.10989.13.camel@dv>  <48978C25.601@gmail.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 18:38:37 -0400
Message-Id: <1217975917.2908.27.camel@dv> (sfid-20080806_003854_284826_E1854E06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-08-05 at 00:09 +0100, Dave wrote:
> > However,
> > sparse finds two issues on x86_64, both due to sizeof() returning
> > size_t, which is wider than int.
> > 
> > Here's the fix.  Please integrate it into the patches that introduce the
> > code.
> 
> Will do. I obviously need to upgrade my version of sparse, since it isn't complaining to me :(

It's not just sparse.  gcc will complain too.  But you'll need to
compile for a 64-bit kernel to see it.

> >> To use WPA, you will need an Agere firmware image. You can get the
> >> necessary file at
> >> <http://marc.info/?l=orinoco-devel&m=121078835610877>
> > I tested it on my WPA2 AP and could not associate:
> 
> I'm not familiar with the difference between WPA/WPA2. Is that expected to work?

WPA2 uses a different IE format.  It is also required to support CCMP,
unlike WPA1, which defaults to TKIP.

I could associate to a WPA1 AP with TKIP, but only on a 32-bit system.
It still fails on the 64-bit system.  wpa_supplicant prints this in a
loop:

RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Wireless event: cmd=0x8c07 len=40
AssocReq IE wireless event - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
Wireless event: cmd=0x8b15 len=24
Wireless event: new AP: 00:0f:66:2f:ef:59
Association info event
req_ies - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
WPA: set own WPA/RSN IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
State: ASSOCIATED -> ASSOCIATED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
Associated with 00:0f:66:2f:ef:59
WPA: Association event - clear replay counter
WPA: Clear old PTK
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request

And the kernel log is:

[ 7729.202964] eth1: New link status: Connected (0001)
[ 7738.072382] eth1: New link status: Disconnected (0002)
[ 7739.238773] eth1: New link status: Connected (0001)
[ 7748.527988] eth1: New link status: Disconnected (0002)
[ 7749.683346] eth1: New link status: Connected (0001)
[ 7758.983565] eth1: New link status: Disconnected (0002)

I'm sorry, I'm really limited in time right now to do more tests, and
I'm afraid I'll be mostly offline for the next 3 weeks.

-- 
Regards,
Pavel Roskin
