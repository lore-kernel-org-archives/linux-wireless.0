Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:61375 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab0CVRph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 13:45:37 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 10:45:37 -0700
Date: Mon, 22 Mar 2010 10:45:35 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jiri Moravec <jim.lkml@gmail.com>
CC: "ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	<linux-wireless@vger.kernel.org>, <nbd@openwrt.org>
Subject: Re: [ath5k-devel] can't add ath5k into bridge on kernel >=2.6.33
Message-ID: <20100322174535.GD4786@tux>
References: <ho3rf1$g7v$1@dough.gmane.org>
 <1269153545.8038.8.camel@mj>
 <4BA64633.2050702@gmail.com>
 <1269223392.2656.16.camel@mj>
 <ho80v2$u3b$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <ho80v2$u3b$1@dough.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 22, 2010 at 08:05:05AM -0700, Jiri Moravec wrote:
> On 22.3.2010 03:03, Pavel Roskin wrote:
> > On Sun, 2010-03-21 at 09:15 -0700, Gus Wirth wrote:
> >> On 03/20/2010 11:39 PM, Pavel Roskin wrote:
> > 
> >>> Bridging doesn't work on the station side anyway because the 802.11
> >>> header has three addresses (except when WDS is used) omitting the
> >>> address that would be needed for a station to send or receive a packet
> >>> on behalf of another system.
> >>
> >> But there are ways around that. For example, there is a patch called
> >> arpnat that affects ebtables, used by projects like Gargoyle router that
> >> does for MAC addresses that IP masquerading does for IP addresses.
> >>
> >> As such, it is very useful to have a node in managed (station) mode be
> >> able to be part of a bridge, as it allows the creation of an essentially
> >> transparent connection.
> > 
> > As it stands now, it's more common that users without that patch try to
> > use bridging on the station side.  When/if arpnat is applied to the
> > kernel, the check for managed mode interfaces will need to be revised.
> > 
> Hi
> On some openwrt pages about Gargoyle and arpnat I found link to Felix Fietkau's patch
> which was finally accepted to vanilla as commit 9bc383de37090ba7ca3ff32a12c9d809dc5867f0.
> From this point there is probably support for 4addr mode (STATION/AP_VLAN), but what
> is probably missing is athk5 support for it. Am I correct? Can somebody clarify this?

I only recently got to pick Felix's brain about this. From what I gathered
essentially what you need:

  * on the STA add the 4-address flag, for now this requires using the iw add 4addr flag, iw should
    support a change command but I don't think we have it yet on iw.
  * on the AP/STA side have support for this feature on the kernel/hostapd side (git versions will do)
  * on hostapd use the wds_sta flag
  * Add the STA WDS'd interface to the bridge, everything will take care of itself after that

So the STA with 4-address frame support will allow the bridging layer to send
802.3 frames to through the STA interface, it will send it to the AP,
the AP with support for this will detect it and create a local interface
for the "peer" for sending future frames to it.

If someone can add this to the wiki:

http://wireless.kernel.org/en/users/Documentation/hostapd

it would be appreciated.

  Luis
