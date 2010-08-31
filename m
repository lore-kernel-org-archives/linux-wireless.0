Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39859 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab0HaAPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 20:15:34 -0400
Subject: Re: Wireless netlink events delivered out-of-order
From: Marcel Holtmann <marcel@holtmann.org>
To: Adar Dembo <adar@vmware.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Gregory A. Smith" <gasmith@vmware.com>
In-Reply-To: <6E637B430FD37A4AB921E6D15291BCAB02485032FA@EXCH-MBX-4.vmware.com>
References: <6E637B430FD37A4AB921E6D15291BCAB02485032FA@EXCH-MBX-4.vmware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 20:15:23 -0400
Message-ID: <1283213723.6841.109.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Adar,

> I asked this question on the linux-wireless IRC channel last week but I don't think anyone was around at the time, so here it is over e-mail.
> 
> We have a userlevel application that uses a netlink socket to figure out when networking interfaces on the system go up or down. It does so by looking at all RTM_NEWLINK messages that arrive on the socket and examining their ifi_flags fields. We interpret the presence of both IFF_UP and IFF_RUNNING to mean that an interface has gone up, while the lack thereof to mean that an interface is down.

I would look for IFF_LOWER_UP actually. Using only IFF_RUNNING is a
pretty bad idea.

Regards

Marcel


