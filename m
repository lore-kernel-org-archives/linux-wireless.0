Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:10423 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab2BWWza (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 17:55:30 -0500
Date: Thu, 23 Feb 2012 17:55:21 -0500
From: Pavel Roskin <proski@gnu.org>
To: wharms@bfs.de
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] Staging: wlan-ng: memsetting the wrong amount of data
Message-ID: <20120223175521.64aec938@mj> (sfid-20120223_235533_358160_4527EF35)
In-Reply-To: <4F44A279.7010403@bfs.de>
References: <20120221141838.GA7998@elgon.mountain>
	<4F43C8CE.8060602@bfs.de>
	<20120222075438.GA3680@mwanda>
	<4F44A279.7010403@bfs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 22 Feb 2012 09:08:25 +0100
walter harms <wharms@bfs.de> wrote:

> Am 22.02.2012 08:54, schrieb Dan Carpenter:
> > On Tue, Feb 21, 2012 at 05:39:42PM +0100, walter harms wrote:
> >>> -	memset(&(msg1.bssid.data), 0xFF,
> >>> sizeof(p80211item_pstr6_t));
> >>> +	memset(&msg1.bssid.data, 0xFF, sizeof(msg1.bssid.data));
> >>>  	msg1.bssid.data.len = 6;
> >>
> >> maybe msg1.bssid.data.len is related to msg1.bssid.data ?
> >> I guess sizeof(msg1.bssid.data)-1 (why -1).
> >>
> >> perhaps you can fix both ?
> >>
> > 
> > It's an interesting point.  The problem is that I don't actually
> > have this hardware.  On the patch which I sent, it was obvious what
> > the intent.  My guess is that msg1.bssid.data[] should have 6
> > elements instead of 7, but I don't feel confident enough to sign off
> > on that.

msg1.bssid.data.data has 6 elements.  msg1.bssid.data is a Pascal
string, i.e. a length byte and 6 bytes of data.

The intention of the code must have been:

memset(&msg1.bssid.data.data, 0xFF, sizeof(msg1.bssid.data.data));

sizeof(msg1.bssid.data.data) is 6.

Writing 15 bytes to a structure that is 7 bytes long is certainly
wrong and should be fixed.

I have the hardware, so please copy me if testing is needed.

-- 
Regards,
Pavel Roskin
