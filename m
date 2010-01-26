Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:35512 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab0AZNUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 08:20:38 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [PATCH 10/10] [RFC, v4] libertas: cfg80211 support
Date: Tue, 26 Jan 2010 14:20:23 +0100
Cc: Holger Schurig <holgerschurig@googlemail.com>,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
References: <20091202142555.654873300@gmail.com> <20091202142955.107139811@gmail.com> <1264432854.2250.17.camel@caravaggio>
In-Reply-To: <1264432854.2250.17.camel@caravaggio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001261420.23936.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +	/* stop network while we're away from our main channel */
> > +	running = !netif_queue_stopped(priv->dev);
> > +	carrier = netif_carrier_ok(priv->dev);
> > +	if (running)
> > +		netif_stop_queue(priv->dev);
> > +	if (carrier)
> > +		netif_carrier_off(priv->dev);
> Stopping the tx queue is fine, but turning the carrier signal 
off is
> not.

The patch is a bit older, then the wext-libertas did the same 
thing. In the meantime, the wext-libertas doesn't mangle the 
carrier anymore, and thus cfg80211-libertas shouldn't do it 
either.




> A couple of questions here:
> - What is this 50ms delay for ?

Good question. A crude way to combine two "almost concurrent" 
scan requests into one. However, if that was the intention, it 
should have gotten a comment. You can try to delete the delay.


> - Why dont you set the scan_request pointer prior to scheduling 
>   the scanning work ?

Hehe, because I can. After all, there's a delay in my patch :-)

If you rewrite this: the idea was that priv->scan_req not only 
contains the details for this scan (e.g. which channels, 
active/passive), but also implicitly if currently a scan is 
underway.

BTW: thanks for this quick review.



> Again, I think this should make it to wireless-testing soon so
> that people can start using it.

Currently, wext-libertas still supports more options than 
cfg80211-libertas. That did hold me. However, feel free to grab 
my RFC-patch and continue, that's the reason I added 
a "Signed-off-by:"-line.




Oh, and please. you the delete-line or delete-block function of 
your e-mail client liberately. No reason to quote 2000 lines 
when you just write 20 lines or so ...

-- 
http://www.holgerschurig.de
