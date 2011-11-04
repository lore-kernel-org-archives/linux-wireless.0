Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab1KDPHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 11:07:10 -0400
Subject: Re: mac80211: UAPSD - first release HW buffered frames next also
 check mac80211 buffered frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAFED-jnG8+4U49scyEu8Yd7=WXFKGcrqcWw1EtTtaiVsQpwcdQ@mail.gmail.com> (sfid-20111104_160506_868196_9C6CE817)
References: <CAFED-jnG8+4U49scyEu8Yd7=WXFKGcrqcWw1EtTtaiVsQpwcdQ@mail.gmail.com>
	 (sfid-20111104_160506_868196_9C6CE817)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 16:07:06 +0100
Message-ID: <1320419226.3969.94.camel@jlt3.sipsolutions.net> (sfid-20111104_160713_407509_92E1B255)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 16:04 +0100, Janusz Dziedzic wrote:
> Hello,
> 
> Seems currently we have implementation.
> 
> if(!driver_release_tids) {
>   ...
> } else {
>   ...
> }
> 
> Shouldn't we first release HW buffered frames and next check also SW
> buffered frames?

Only one of them can be true -- we don't release from driver & mac80211
queues at the same time. Technically we could, but the complexity would
be much higher than your simple patch for more-data handling etc.

johannes

