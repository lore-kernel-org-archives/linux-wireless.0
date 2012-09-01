Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37795 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab2IANOm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2012 09:14:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1T7nX6-00068k-PI
	for linux-wireless@vger.kernel.org; Sat, 01 Sep 2012 15:14:40 +0200
Received: from 83.68.239.193 ([83.68.239.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 01 Sep 2012 15:14:40 +0200
Received: from netuse by 83.68.239.193 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 01 Sep 2012 15:14:40 +0200
To: linux-wireless@vger.kernel.org
From: Marco <netuse@lavabit.com>
Subject: Re: DHCP request timed out, iwlwifi
Date: Sat, 1 Sep 2012 15:14:29 +0200
Message-ID: <20120901151429.51e55525@homerow> (sfid-20120901_151519_965122_313B1529)
References: <20120806161443.35c71558@homerow>
	<20120806192836.369a3737@homerow>
	<1344282454.11053.33.camel@dcbw.foobar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-06 Dan Williams <dcbw@redhat.com>
wrote:

Hi,

I am sorry do wake up this old thread again (should I start a new
one instead?).

> Ok, that does all look fine.  At this point, either the wifi driver
> isn't cooperating, or there isn't a DHCP server listening.

I managed to find another USB network adapter with a different
chipset which works perfectly. My guess is that the DHCP works (I
don't have access to the DHCP server), since it works fine for all
other hosts on the network.

> I'd rule out the firewall because typically they let DHCPv4
> through by default.  One other thing you could do is set the
> connection to "manual" (ie, static) IPv4 addressing, enter an
> address that you know is on the router's subnet, and try to ping
> the default router.  If that works, then clearly something is
> wrong with DHCP.

The ping did not succeed.

> If that doesn't work and you're sure the address/netmask you set
> is correct, then there's something wrong in the driver.

I am not 100% sure that the values I input were correct. I used the
same settings that a different host used and picked a random IP
address on the same subnet.

That way I am connected to the network, but don't have internet
access (e.g. cannot ping google by IP address).

> Yet another alternative is to do the static IP thing and then
> run a wireshark packet capture and see if the wifi card sees any traffic
> at all.

I did that and wireshark receives packages. But I don't really know
what to look for, to be honest. I can provide a wireshark capture
file, if necessary. But I guess it makes more sense to send it via
email, instead of dropping a big binary blob in this list.

> Anyone else have any thoughts?  If the 4-way handshake works, that
> indicates your WPA passphrase is correct.

It is definitely correct. As I said, if I use a different adapter on
the same computer with the same settings assigned via DHCP it works.


Marco


