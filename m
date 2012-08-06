Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab2HFTp6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:45:58 -0400
Message-ID: <1344282454.11053.33.camel@dcbw.foobar.com> (sfid-20120806_214601_514806_E0ADFC09)
Subject: Re: DHCP request timed out, iwlwifi
From: Dan Williams <dcbw@redhat.com>
To: Marco <netuse@lavabit.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Aug 2012 14:47:34 -0500
In-Reply-To: <20120806192836.369a3737@homerow>
References: <20120806161443.35c71558@homerow>
	 <20120806192836.369a3737@homerow>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-06 at 19:28 +0200, Marco wrote:
> I just tested with a current Fedora. The problem remains. I get the
> same error. I attached the complete /var/log/messages, since I don't
> know exactly what parts might be of interest.
> 
> Any help appreciated

Ok, that does all look fine.  At this point, either the wifi driver
isn't cooperating, or there isn't a DHCP server listening.  I'd rule out
the firewall because typically they let DHCPv4 through by default.  One
other thing you could do is set the connection to "manual" (ie, static)
IPv4 addressing, enter an address that you know is on the router's
subnet, and try to ping the default router.  If that works, then clearly
something is wrong with DHCP.  If that doesn't work and you're sure the
address/netmask you set is correct, then there's something wrong in the
driver.  Yet another alternative is to do the static IP thing and then
run a wireshark packet capture and see if the wifi card sees any traffic
at all.

Anyone else have any thoughts?  If the 4-way handshake works, that
indicates your WPA passphrase is correct.

Dan

