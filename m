Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-53.dex002.intermedia.net ([64.78.21.155]:23058 "EHLO
	dhost002-53.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758923AbXEJRL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 13:11:59 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Thu, 10 May 2007 10:12:13 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kumar Gala <galak@kernel.crashing.org>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: support for bridging ethernet and 802.11
Message-ID: <20070510171213.GD24712@devicescape.com>
References: <CCA1D7C0-D44A-450D-A76E-DAE792E0CB37@kernel.crashing.org> <1178816781.3806.31.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1178816781.3806.31.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2007 at 07:06:21PM +0200, Johannes Berg wrote:

> On Thu, 2007-05-10 at 11:18 -0500, Kumar Gala wrote:
> > I'm wondering how to tell if a given driver/device in the kernel  
> > supports the ability to bridge between ethernet and 802.11.  From  
> > searching the web it looks like only the prism driver/device supports  
> > this.

> Normally wireless drivers do 802.3 framing as the 802.11 standard more
> or less requires, so it should "just work". Am I missing something?

IEEE 802.11 allows only the own MAC address to be used as the source
address (addr2) when operating as a non-AP STA in BSS (client in Managed
mode). In other words, layer 2 bridging does not work properly. AP mode
and WDS links can be used for bridging without problems, but this will
of course require the driver to support these.

-- 
Jouni Malinen                                            PGP id EFC895FA
