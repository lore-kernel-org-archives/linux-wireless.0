Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54392 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZACDUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 22:20:32 -0500
Date: Sat, 3 Jan 2009 04:20:30 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: b43 depends on lots of modules
In-Reply-To: <495ED57A.7080101@lwfinger.net>
Message-ID: <alpine.LSU.2.00.0901030419390.9193@fbirervta.pbzchgretzou.qr> (sfid-20090103_042120_880867_BA6CC81F)
References: <alpine.LSU.2.00.0901030349030.3914@fbirervta.pbzchgretzou.qr> <495ED57A.7080101@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Saturday 2009-01-03 04:03, Larry Finger wrote:

>Jan Engelhardt wrote:
>> Hi,
>> 
>> I noticed that the b43 module has a lot of dependencies, among:
>> 
>> depends:        pcmcia,mac80211,ssb,input-polldev,pcmcia_core,led-class,rfkill,rng-core,firmware_class
>> 
>> Why does it depend on PCMCIA when I hear that b43 devices are also 
>> available in PCI variants? Similarly, is SSB needed on x86en which
>> usually don't have such?
>
>B43 only depends on PCMCIA if that option is selected in the
>configuration. Mine doesn't, but most distros will. Ssb is the PCI
>driver for b43. If you have a PCI device, then you need it. Ssb was
>split out because it is shared among b43, b43legacy and b44.

It's because the Kconfig description says SSB is for embedded systems,
come thinking WRT54, so I wondered what exactly requires SSB.
Is it some bus within the wireless chip itself?

