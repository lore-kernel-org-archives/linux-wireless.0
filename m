Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50077 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbZHGVcs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 17:32:48 -0400
Subject: Re: [PATCH] rndis_wlan: wait association to complete
From: Dan Williams <dcbw@redhat.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
In-Reply-To: <20090806223406.27393zuzztewms74@hayate.sektori.org>
References: <20090806181746.31308.15687.stgit@fate.lan>
	 <1249584385.28278.124.camel@johannes.local>
	 <20090806223406.27393zuzztewms74@hayate.sektori.org>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 16:31:58 -0500
Message-Id: <1249680718.26088.44.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-06 at 22:34 +0300, Jussi Kivilinna wrote:
> Quoting "Johannes Berg" <johannes@sipsolutions.net>:
> 
> > On Thu, 2009-08-06 at 21:17 +0300, Jussi Kivilinna wrote:
> >> Fix WPA authentication problems by waiting to association to complete.
> >> Otherwise userspace (wpa_supplicant) receives authentication packets before
> >> association events from driver.
> >
> >> +	/* If we return now, userspace would get association events too late
> >> +	 * (after receiving first packets from access point). This causes
> >> +	 * WPA authentication to fail.
> >
> > This is a bit weird, shouldn't you just send the event later then?
> >
> 
> rndis_wlan bases on rndis_host/usbnet. Problem is that rndis_host uses  
> polling for rndis_command() results to avoid more complex interrupt  
> based solution. Because rndis_host and therefore rndis_wlan doesn't  
> handle interrupts on command channel, rndis_wlan knows about completed  
> association too late. 'Too late' means here that device starts  
> receiving packets from AP, which end up ignored because userspace  
> thinks device isn't assosiated yet (I think).
> 
> So this patch adds waiting in set_essid() and active polling for  
> association completion in worker.
> 
> Real fix would probably be to hold on data channel until association  
> is complete, but that would mean touching usbnet/rndis_host little bit  
> too much than I'd like to.

If this patch ever blocks SIOSIWESSID, then a huge NAK.  Setting the
ESSID is an asynchronous operation, it should *not* block for operation
to complete.  Completion is signaled only when an IWESSID event is sent
to userspace.  What you should be doing is dropping packets from the AP
on the floor until the firmware things the association is complete.

Dan


