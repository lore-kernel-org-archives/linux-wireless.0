Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:58650 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756074Ab2BBT3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 14:29:09 -0500
Date: Thu, 2 Feb 2012 20:29:06 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Alfonso Fiore <alfonso.fiore@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: how to setup a wireless bridge (wds) without iwpriv?
Message-ID: <20120202192906.GA1592@minime.bse> (sfid-20120202_202915_073938_F19584D8)
References: <CAO=xpBGPi7o+gi3bTb=9iML=bSqBog6okz-Z7X7tywqiwb=FaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAO=xpBGPi7o+gi3bTb=9iML=bSqBog6okz-Z7X7tywqiwb=FaA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alfonso,

On Thu, Feb 02, 2012 at 07:22:30PM +0100, Alfonso Fiore wrote:
> Since wireless on my PC doesn't work properly, I'd like to create a
> wireless bridge to allow a PC to get an IP address from the wireless
> network without NAT.
> 
> (ISP wireless router - 192.168.1.1) <---wireless---> (ALIX setup as
> bridge) <---wired---> (PC - 192.168.1.x)

I use proxy ARP to achieve this with WPA:

route add -net 192.168.1.0/25 dev wlan0
route add -net 192.168.1.128/25 dev eth0
echo 1 >/proc/sys/net/ipv4/conf/wlan0/proxy_arp
echo 1 >/proc/sys/net/ipv4/conf/eth0/proxy_arp
echo 1 >/proc/sys/net/ipv4/ip_forward

But it only works if you know beforehand on which interface your ALIX
will see an IP address. You could run the DHCP server on your ALIX to
make it more deterministic.

  Daniel
