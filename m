Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62737 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746AbZJ3SXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 14:23:18 -0400
Received: by bwz27 with SMTP id 27so3883655bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 11:23:22 -0700 (PDT)
Message-ID: <4AEB2F13.50102@lwfinger.net>
Date: Fri, 30 Oct 2009 13:23:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linville@tuxdriver.com, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, dcbw@redhat.com,
	stern@rowland.harvard.edu, davem@davemloft.net
Subject: Re: [PATCH] libertas if_usb: Fix crash on 64-bit machines
References: <1256924714.4030.44.camel@macbook.infradead.org>
In-Reply-To: <1256924714.4030.44.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse wrote:
> On a 64-bit kernel, skb->tail is an offset, not a pointer. The libertas
> usb driver passes it to usb_fill_bulk_urb() anyway, causing interesting
> crashes. Fix that by using skb->data instead.
> 
> This highlights a problem with usb_fill_bulk_urb(). It doesn't notice
> when dma_map_single() fails and return the error to its caller as it
> should. In fact it _can't_ currently return the error, since it returns
> void.

This should be fixed. If changing the code to return the error would
be too invasive (It is used in 30+ drivers), perhaps the routine
should be modified to log a warning when dma mapping fails. I will
submit an RFC to do that.

Larry

