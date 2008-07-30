Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49532 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYG3Tgp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 15:36:45 -0400
Subject: Re: Issue: iwlist scanning sees the network; dhclient can't connect
From: Pavel Roskin <proski@gnu.org>
To: "Thiago F. Tavares" <ttavares@halogica.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1127857B97C63B4285A9B02BEF67AEE601627648@afrodite.halogica.com.br>
References: <1127857B97C63B4285A9B02BEF67AEE601627648@afrodite.halogica.com.br>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 15:36:42 -0400
Message-Id: <1217446602.25919.5.camel@dv> (sfid-20080730_213649_064470_02C4DCDD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-30 at 16:13 -0300, Thiago F. Tavares wrote:
> Hello,
>  
> I have a problem with the broadcom wireless card (BCM4306 using b43).
> I'm can list the wireless ESSIDs with "iwlist scanning" command, but I'm
> can't connect in the LAN. My dhclient or dhcpcd can't receive an IP.
> When I set a static IP, I can't ping the gateway.

dhclient is not suitable for wireless networking because it brings the
interface down briefly and breaks the connection.  So I suggest that you
use static addresses or a DHCP client that doesn't bring the interface
down.

Please check iwconfig output.  In particular, please see "access point"
and "link quality".  If the later is 0, there is no association.  If
there is no association, no IP packets can go through.  Try
reestablishing the association by setting ESSID with iwconfig while the
interface is up.

Also please see the kernel log for possible signs of trouble.  It's
shown by the "dmesg" command.

-- 
Regards,
Pavel Roskin
