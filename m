Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47481 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab3A3JcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 04:32:08 -0500
Date: Wed, 30 Jan 2013 10:33:49 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: stable@vger.kernel.org,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Subject: Re: [PATCH] brcmsmac: handle packet drop on enqueuing correctly
Message-ID: <20130130093349.GB17322@kroah.com> (sfid-20130130_103212_955612_43CD6201)
References: <1359125868-27890-1-git-send-email-arend@broadcom.com>
 <51029FA6.40209@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51029FA6.40209@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2013 at 04:07:18PM +0100, Arend van Spriel wrote:
> On 01/25/2013 03:57 PM, Arend van Spriel wrote:
> > From: Piotr Haber <phaber@broadcom.com>
> > 
> > In the event that tx packet can not be queued by the driver
> > the packet is dropped. Propagate that information to the .tx()
> > callback to make sure the freed packet is not accessed after
> > that.
> > 
> > This has happened causing slab corruptions as reported by
> > Stanislaw Gruszka.
> > 
> > Bug #47721: https://bugzilla.kernel.org/show_bug.cgi?id=47721
> > 
> > That patch is backported from:
> > 
> > commit c4dea35e34f5f46e1701156153a09cce429d1ea9 upstream.
> 
> It applies to stable/linux-3.7.y only.

Ah, here's the 3.7 patch, thanks.

greg k-h
