Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:59730 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbXITQ4M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 12:56:12 -0400
Date: Thu, 20 Sep 2007 09:55:45 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wext 64-bit: network manager and wpa_supplicant
Message-ID: <20070920165545.GA29452@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1190292526.18521.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1190292526.18521.52.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 20, 2007 at 02:48:46PM +0200, Johannes Berg wrote:
> Ahrg. So I was complaining about NM not displaying any networks when
> that umlaut-network I talked about earlier was present. But all that was
> just wrong, the real problem seems to be that NM doesn't work on 64-bit
> platforms. Is there any fix for it? It really should be going into a
> 0.6.5.1 version or something so distributions will ship it.
> 
> And even the wpa_supplicant git version still seems to parse everything
> itself without any 64-bit workarounds as far as I can tell. I keep
> building wpa_supplicant for 64-bit just to test... Any chance to finally
> get fixes into the stable versions distros are shipping?
> 
> Thanks,
> johannes

	You know that I don't have any 64 bit box, so I can't really
test it. I did extensive work with people of Gentoo and Debian to make
sure that my fix in Wireless Extension works both with 32 bits
userspace on 64 bits kernel and 64 bits userspace on 64 bits
kernels. The versions that are fully fixed are 29-pre20 and later.
	Then, I modified NetworkManaged to use libiw for scan
parsing. The idea was to simplify NetworkManager and fix the 32-64 bit
bug, plus a few other potential gotchas. The first version of
NetworkManager to include that fix is 0.6.5. But, I've just realised
that I did not convert event parsing, which could be an issue, I'll
try to work on that.
	Note that the other big issue is that, if wpa_supplicant is
present, NetworkManager will request the scan from it, and won't use
its internal code, so all those fixes are useless. Maybe there should
be a control to force NetworkManager to use its own scan code when
needed.

	As far as I know, Debian testing (Lenny) has those
packages. Of course, I would not mind if you could test all this,
verify that the packages are the right version and that iwlist works
properly. If iwlist does not work, the rest will never works.

	With respect to wpa_supplicant. Well, I sent multiple e-mail
to Jouni to inform him about this. My personaly inclination would be
to rip the custom parsing code of wpa_supplicant and use libiw
instead, but Jouni will never accept that. Maybe you should use
xsupplicant instead.

> Same seems to go for wpa_supplicant, Debian is shipping 0.6.0 which only
> triggers this in the kernel log:
> 
> [  787.877417] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32){t:8b;sz:0} arg(ffb58418) on socket:[14569]
> [  787.877763] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32){t:8b;sz:0} arg(ffb58418) on socket:[14569]
> [  787.877817] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32){t:8b;sz:0} arg(ffb58418) on socket:[14569]
> [  795.264145] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32){t:8b;sz:0} arg(ffb58458) on socket:[14569]
> [  795.264243] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32){t:8b;sz:0} arg(ffb58458) on socket:[14569]
> [  795.264291] ioctl32(wpa_supplicant:5846): Unknown cmd fd(3) cmd(00008b32){t:8b;sz:0} arg(ffb58458) on socket:[14569]
> 

	Ok, I see what's happening. That would just prevent you to set
authentication information, but that is not the root caause of your
problems. I'll puch a fix ASAP to John.

	Regards,

	Jean
