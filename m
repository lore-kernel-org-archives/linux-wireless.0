Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36044 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab2HFUU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 16:20:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SyTnN-0003Lr-Fv
	for linux-wireless@vger.kernel.org; Mon, 06 Aug 2012 22:20:57 +0200
Received: from 83.68.239.193 ([83.68.239.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 22:20:57 +0200
Received: from netuse by 83.68.239.193 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 22:20:57 +0200
To: linux-wireless@vger.kernel.org
From: Marco <netuse@lavabit.com>
Subject: Re: DHCP request timed out, iwlwifi
Date: Mon, 6 Aug 2012 22:20:46 +0200
Message-ID: <20120806222046.5f0a583f@homerow> (sfid-20120806_222101_599128_85C132EC)
References: <20120806161443.35c71558@homerow>
	<20120806192836.369a3737@homerow>
	<1344282454.11053.33.camel@dcbw.foobar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-06 Dan Williams <dcbw@redhat.com>
wrote:

> At this point, either the wifi driver isn't cooperating, or there
> isn't a DHCP server listening.

Not a single other computer on the network has DHCP problems. If I
plug in an external USB network adapter (which uses a different
driver) the computer connects instantly. However, other computers on
the network also use the iwlwifi driver without problems (but with
different hardware).

> I'd rule out the firewall because typically they let DHCPv4
> through by default.

I think so, too. And if it would be the firewall, it wouldn't
connect with a different network adapter, I guess.

> One other thing you could do is set the connection to "manual"
> (ie, static) IPv4 addressing, enter an address that you know is on
> the router's subnet, and try to ping the default router.If that
> works, then clearly something is wrong with DHCP.  If that doesn't
> work and you're sure the address/netmask you set is correct, then
> there's something wrong in the driver.

Now it works again and I cannot test it any more. That's what I
meant with “it's not really reproducible”. I'll have to wait a
couple of days until it occurs again.

> Yet another alternative is to do the static IP thing and then run
> a wireshark packet capture and see if the wifi card sees any
> traffic at all.

I will report back on this issue when the connection fails again and
I can test.

> If the 4-way handshake works, that indicates your WPA passphrase
> is correct.

It's saved in the NetworkManager. I would be surprised if the
passphrase would, out of a sudden, be wrong.

Thanks for taking the time to help tracing down this issue.


Marco


