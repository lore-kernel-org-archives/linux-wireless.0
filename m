Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35563 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab1ALVTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 16:19:52 -0500
Message-ID: <4D2E1AF7.4000104@candelatech.com>
Date: Wed, 12 Jan 2011 13:19:51 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: NetDev <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: TCP connections stall when station re-associates.
References: <4D2CFDB8.3010907@candelatech.com>
In-Reply-To: <4D2CFDB8.3010907@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2011 05:02 PM, Ben Greear wrote:
>
> We're seeing something funny while testing ath9k and ath5k with
> multiple VIFs. We are using send-to-self routing rules
> and have a TCP connection going between two station interfaces
> connected to the same AP. Kernel is ~2.6.37 (wireless-testing from
> a few days ago, plus some local patches). We tried commercial
> APs and ath9k/ath5k APs running 2.6.37 kernel and hostap with
> similar results.

When the stations re-connect, we re-run dhcp client, which involves
setting IP to zero and then re-acquiring the IP address.  We
then set up new routing rules, etc to have it back to the way
it was before the station lost contact with the AP.

The TCP/IP connections are specifically bound to local IP and port.

Maybe it is invalid to expect TCP connections to survive this
IP change?

I'll work on reproducing this DHCP behaviour on some regular
wired interfaces and see if I can reproduce in a simpler test
case.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
