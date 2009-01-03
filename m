Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:38371 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932183AbZACDDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 22:03:37 -0500
Message-ID: <495ED57A.7080101@lwfinger.net> (sfid-20090103_040351_102808_0978FA78)
Date: Fri, 02 Jan 2009 21:03:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: b43 depends on lots of modules
References: <alpine.LSU.2.00.0901030349030.3914@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0901030349030.3914@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
> 
> I noticed that the b43 module has a lot of dependencies, among:
> 
> depends:        pcmcia,mac80211,ssb,input-polldev,pcmcia_core,led-class,rfkill,rng-core,firmware_class
> 
> Why does it depend on PCMCIA when I hear that b43 devices are also 
> available in PCI variants? Similarly, is SSB needed on x86en which
> usually don't have such?

B43 only depends on PCMCIA if that option is selected in the
configuration. Mine doesn't, but most distros will. Ssb is the PCI
driver for b43. If you have a PCI device, then you need it. Ssb was
split out because it is shared among b43, b43legacy and b44.

Larry
