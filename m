Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47418 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab3A3J35 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 04:29:57 -0500
Date: Wed, 30 Jan 2013 10:31:40 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: stable@vger.kernel.org,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Subject: Re: [PATCH v3.6.y] brcmsmac: handle packet drop on enqueuing
 correctly
Message-ID: <20130130093140.GA17322@kroah.com> (sfid-20130130_103002_625562_E5E2B8EC)
References: <1359126493-28270-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359126493-28270-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2013 at 04:08:13PM +0100, Arend van Spriel wrote:
> From: Piotr Haber <phaber@broadcom.com>
> 
> In the event that tx packet can not be queued by the driver
> the packet is dropped. Propagate that information to the .tx()
> callback to make sure the freed packet is not accessed after
> that.
> 
> This has happened causing slab corruptions as reported by
> Stanislaw Gruszka.
> 
> Bug #47721: https://bugzilla.kernel.org/show_bug.cgi?id=47721
> 
> The patch is backported from:
> 
> commit c4dea35e34f5f46e1701156153a09cce429d1ea9 upstream.
> 

Why not 3.7-stable?  There is no more 3.6-stable releases, that kernel
has been end-of-life for a while now.

thanks,

greg k-h
