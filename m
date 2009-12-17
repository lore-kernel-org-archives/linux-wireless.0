Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934192AbZLQBSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 20:18:36 -0500
Subject: Re: libertas driver carrier of signaling
From: Dan Williams <dcbw@redhat.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20091216225524.GD3788@sortiz.org>
References: <20091216225524.GD3788@sortiz.org>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 17:18:31 -0800
Message-Id: <1261012711.17721.7.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-12-16 at 23:55 +0100, Samuel Ortiz wrote:
> Hi guys,
> 
> I was looking at the libertas driver and found that piece of code, at scan.c:
> 
> /* We want to scan all channels */
> 	chan_count = lbs_scan_create_channel_list(priv, chan_list);
> 
> 	netif_stop_queue(priv->dev);
> 	netif_carrier_off(priv->dev);
> 
> So, why do we need to turn carrier off when scanning? I could barely see why
> we'd want to stop the netdev tx queue, but is turning carrier off really
> needed ?

Probably not.  Carrier is largely useless with wireless drivers anyway,
though if they for some reason really, really want to use carrier,
carrier should only be on when the device is authed & associated to an
AP.

Dan


