Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47456 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbYG1O01 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 10:26:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
Date: Mon, 28 Jul 2008 16:25:57 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <48763814.27052c0a.1794.2095@mx.google.com> <200807281544.33509.mb@bu3sch.de> <1217253465.28198.20.camel@localhost.localdomain>
In-Reply-To: <1217253465.28198.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807281625.58188.mb@bu3sch.de> (sfid-20080728_162630_459587_DFDC0341)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 28 July 2008 15:57:45 Dan Williams wrote:
> > (What are the udev problems, btw?)
> 
> People seem to want persistent device names.  Since the kernel doesn't
> provide stable device/bus enumeration, there are udev hacks (see
> attached from Fedora 9) that read the MAC address of the card on
> hot-plug and then assign it to a cached device name so that every time I
> plug in my Netgear MA401 it gets "eth2".

Yeah well. But using a pseudo-random MAC as a base to build a persistent
naming scheme on sounds pretty fragile to me. ;)

I think cards that don't supply MAC early simply cannot support
a really working persistent naming scheme well. udev should probably
just enumerate eth0 - ethX as it sees the devices. That's as good
as mixing a numbering scheme into a pseudo MAC, IMO. And it's
less confusing and it pushes a lot of policy decisions into userspace.

-- 
Greetings Michael.
