Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.181]:12644 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbCNUpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 16:45:18 -0400
Date: Sat, 14 Mar 2015 21:39:07 +0100
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Ochal Christophe <christophe.ochal@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43340
Message-ID: <20150314213907.3f1167bb@mir> (sfid-20150314_214555_853192_C04917BD)
In-Reply-To: <55049507.6040209@gmail.com>
References: <550482A2.3080803@gmail.com>
	<55048833.90408@broadcom.com>
	<55048BB1.9080906@gmail.com>
	<550491DA.6030105@broadcom.com>
	<55049507.6040209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On 2015-03-14, Ochal Christophe wrote:
> Dear Sir,
> 
> On 03/14/2015 08:54 PM, Arend van Spriel wrote:
> > For Windows 8.1 the nvram file is stored in EFI variable space. This 
> > is accessible in Linux as well. If I recall correctly it should be in 
> > /sys/firmware/efi/efivars. There should be a file named nvram-*. Copy 
> > that to /lib/firmware/brcm/brcmfmac43340-sdio.txt.
> >
> Okay.... Kind of wish I knew that a few hours ago before I formatted the 
> thing :)
> I'll see if I can either reinstall Windows on it (somehow) or find 
> someone with the same machine, I'm getting close to get pretty much 
> everything running

You don't need to run windows for that, the nvram (calibration data, 
probably the MAC address and related device specific data) is stored in 
your mainboard's firmware - and exposed to userspace (under linux) via
/sys/firmware/efi/efivars/. You just need to identify the correct file
and copy it to a place where linux expects to find it 
(/lib/firmware/brcm/brcmfmac43340-sdio.txt).

Regards
	Stefan Lippers-Hollmann
