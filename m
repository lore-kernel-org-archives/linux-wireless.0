Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:56484 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753220AbYLFVra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 16:47:30 -0500
Message-ID: <493AF2EE.20605@lwfinger.net> (sfid-20081206_224736_750362_CCBF2F01)
Date: Sat, 06 Dec 2008 15:47:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Greg KH <gregkh@suse.de>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] p54usb: rewriting rx/tx routines to make use of
 usb_anchor's facilities
References: <200812051547.45790.chunkeey@web.de> <4939B6AF.2060901@lwfinger.net> <20081205232321.GA8557@suse.de> <200812062109.40590.chunkeey@web.de>
In-Reply-To: <200812062109.40590.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> 
> Alan, I've got a question about:
> "Create and initialize a usb_anchor structure, and each time you create
> a new URB, call usb_anchor_urb().  Then you can free the URB as soon as
> it is submitted; the anchor will keep it pinned until it completes, and
> it is automatically removed from the anchor when the completion routine
> is called."
> 
> Do we have to call usb_free_urb again, if we're resubmitting the urb in the
> complete callback? (the code what I'm referring to is p54u_rx_cb in p54usb.c)

I am very interested in the answer to this question. My interpretation is that
you cannot resubmit the urb after it has been posted to usb_anchor_usb() because
the USB core will have deleted it, and that the callback routine will have to
allocate a new urb, anchor it, and then free it as well.

Larry
