Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:46649 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab3KAPbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 11:31:24 -0400
Received: by mail-oa0-f49.google.com with SMTP id j10so4624268oah.8
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 08:31:24 -0700 (PDT)
Message-ID: <5273C948.9060409@lwfinger.net> (sfid-20131101_163128_478304_CEC79043)
Date: Fri, 01 Nov 2013 10:31:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ruben De Smet <ruben.de.smet@telenet.be>,
	b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: BCM43228
References: <52737A9C.3020404@telenet.be>
In-Reply-To: <52737A9C.3020404@telenet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/01/2013 04:55 AM, Ruben De Smet wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi folks,
>
> I'm currently running Broamcoms prorietary wl drivers, which were
> running fine until I found a bug in the bluetooth part of it, which
> panics the kernel at a certain position.
> I don't know if it's a part in the GPL part of the kernel which
> panics, or if it's in the Broadcom part, as the kernel is tainted by
> the wireless driver and cannot be debugged that way.
>
> lspci shows me this:
> 03:00.0 Network controller: Broadcom Corporation BCM43228 802.11a/b/g/n
>
> My question: will b43 ever support this chip? If so, I'd be able to
> give someone access to this computer for debugging purposes.
> I'd give any help possible, though kernels and modules aren't my
> domain yet.

The short answer is "probably not". The reverse engineering process is very time 
consuming and boring. What seems to work best is to find a MIPS driver and 
disassemble it to form the kind of "specs" that are seen at 
http://bcm-v4.sipsolutions.net/. Next a different person needs to take that 
prescription and turn it into code. To preserve the clean-room setting, those 
two parts must be done by separate people. The process worked reasonably well 
for 802.11g devices, but  the code gets very complicated for 802.11n. Further 
complicating the issue is that at least one of two BCM43228 units has an LCNXN 
PHY, and we have done little with that although the web site shows WIP for that 
PHY with a BCM43227. The 2.4 GHz part of the 227 probably matches that of the 
228. Note that b43 has never worked well with the 5 GHz radio in any of the chips.

Of course, if the RE is done perfectly, then you end up with all the bugs of wl. :)

One other possibility is that the device might eventually be supported by 
brcmsmac. That set of authors has the advantage of having access to the Broadcom 
documentation and the wl sources. In case that is a possibility, I added the 
linux-wireless mailing list to this reply.

As shown at http://wireless.kernel.org/en/users/Drivers/b43#Supported_devices, 
there are two different PCI IDs that are called BCM43228. When you ask this kind 
of question, you should include the output of 'lspci -nn' so that the ID is listed.

Larry

