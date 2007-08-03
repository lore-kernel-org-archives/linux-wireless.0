Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:48342 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757516AbXHCH7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 03:59:46 -0400
Message-ID: <46B2E06F.4090706@warmcat.com>
Date: Fri, 03 Aug 2007 08:59:43 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Ulrich Kunitz <kune@deine-taler.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: mac80211 driver interface semantics
References: <46B27729.5030406@gentoo.org> <20070803052935.GA12683@deine-taler.de>
In-Reply-To: <20070803052935.GA12683@deine-taler.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> As far as I know the phy0/add_iface entry can be used to add a new
> interface. Notify though the "file" has write access for other,
> you will need network admin capabilities, which is satisfied by
> being root. For example:
> 
> # cat mon0 >/sys/class/net/wmaster0/phy80211/add_iface

echo -n mon0 ... ;-)

you can also come at this through

/sys/class/ieee80211/phy<n>/add_iface

Nice idea to document it Daniel.  Seeing it written down makes it a
little more obviously "huh?" about the hard and soft monitor distinction
IMO.  There seems to be some agreement that in the future the number of
virtual interfaces that happen to be lying around shouldn't determine
the functionality of Monitor mode like that.

-Andy
