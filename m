Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxin.vub.ac.be ([134.184.129.112]:30432 "EHLO mxin.vub.ac.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab3KAQKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 12:10:04 -0400
Message-ID: <5273D018.7080607@telenet.be> (sfid-20131101_171009_202938_ACDEAA28)
Date: Fri, 01 Nov 2013 17:00:24 +0100
From: Ruben De Smet <ruben.de.smet@telenet.be>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Re: BCM43228
References: <52737A9C.3020404@telenet.be> <5273C948.9060409@lwfinger.net>
In-Reply-To: <5273C948.9060409@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On 11/01/2013 04:31 PM, Larry Finger wrote:
>> Hi folks,
>> 
>> I'm currently running Broamcoms prorietary wl drivers, which
>> were running fine until I found a bug in the bluetooth part of
>> it, which panics the kernel at a certain position. I don't know
>> if it's a part in the GPL part of the kernel which panics, or if
>> it's in the Broadcom part, as the kernel is tainted by the
>> wireless driver and cannot be debugged that way.
>> 
>> lspci shows me this: 03:00.0 Network controller: Broadcom
>> Corporation BCM43228 802.11a/b/g/n
>> 
>> My question: will b43 ever support this chip? If so, I'd be able
>> to give someone access to this computer for debugging purposes. 
>> I'd give any help possible, though kernels and modules aren't my 
>> domain yet.
> 
> The short answer is "probably not". The reverse engineering process
> is very time consuming and boring. What seems to work best is to
> find a MIPS driver and disassemble it to form the kind of "specs"
> that are seen at http://bcm-v4.sipsolutions.net/. Next a different
> person needs to take that prescription and turn it into code. To
> preserve the clean-room setting, those two parts must be done by
> separate people. The process worked reasonably well for 802.11g
> devices, but  the code gets very complicated for 802.11n. Further
> complicating the issue is that at least one of two BCM43228 units
> has an LCNXN PHY, and we have done little with that although the
> web site shows WIP for that PHY with a BCM43227. The 2.4 GHz part
> of the 227 probably matches that of the 228. Note that b43 has
> never worked well with the 5 GHz radio in any of the chips.
> 
> Of course, if the RE is done perfectly, then you end up with all
> the bugs of wl. :)
> 
> One other possibility is that the device might eventually be
> supported by brcmsmac. That set of authors has the advantage of
> having access to the Broadcom documentation and the wl sources. In
> case that is a possibility, I added the linux-wireless mailing list
> to this reply.
> 
> As shown at 
> http://wireless.kernel.org/en/users/Drivers/b43#Supported_devices,
> there are two different PCI IDs that are called BCM43228. When you
> ask this kind of question, you should include the output of 'lspci
> -nn' so that the ID is listed.
> 
> Larry
> 

AFAIK, broadcom only offers it's drivers for intel x86 and x64_86; I
guess by MIPS, you mean the architecture? (why wouldn't the intel
driver work? Pretty unknown on the subject ;) )

I read the WIP mail about the 227 chip, I could possibly wait for that
one to be released and test it out on mine?

For the record: the issue I'm having is as follows: when connecting
via the bluetooth part of the chip to my phone and using DUN to
connect to the internet, everything works fine until I shut down the
connection. Then my kernel panics. (Another issue of course is the
fact that wl is the only closed source thing in my kernel running atm
on my notebook...)

On brcmsmac: is linux-wireless the right mailinglist to post to then?
I see that the range of supported devices is more close to my chip
than b43 is ;)
I added brcm80211-dev-list@broadcom.com to this mail too, which looks
like the more appropriate mailinglist to post the issue to.

R

PS. snippet of the output of 'lspci -nn':

03:00.0 Network controller [0280]: Broadcom Corporation BCM43228
802.11a/b/g/n [14e4:4359]

Other information on request, will try to answer asap.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSc9AYAAoJEPgmWogSE9wQIGYIAM34w5YzEW3njtkOX0STZf/m
2nDYgORLDgksjQGf7XbSLIn+M7W0u9HMVQXT/aBBxejnSidD/WYIfNLuJddjrGZm
pCl3vO/Z7Px/PI/TBa58MIlV9zZOR/T2dLJmijm7u466AFE23PXT1mJemYzlDNdE
LLykV+Gp6of8uYLzj2GdqVwHEOztdO9x2q5PGVlDiBfIMkqnt1xn6VqFDZdp75Di
viC03tE4HPkN4IIxJbPmZUzBo4L47eRLLJxXAHsVst/sD+YnHkhvEk0yIvSvF3b4
0kZ1jSsDGjryquZ2f4Bvkw8prKS/LyNmPIn8+SaCZ516+C8uUX1e2Z1em2v5DiI=
=Z3eG
-----END PGP SIGNATURE-----
