Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61042 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096AbZKDTtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 14:49:16 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] usb: Check results of dma_map_single
Date: Wed, 4 Nov 2009 20:49:02 +0100
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
References: <4af115c3.JUDAYfcydqPYCYyH%Larry.Finger@lwfinger.net>
In-Reply-To: <4af115c3.JUDAYfcydqPYCYyH%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911042049.02761.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009 06:48:51 Larry Finger wrote:
> At http://marc.info/?l=linux-wireless&m=125695331205062&w=2, a problem
> with DMA buffer processing was corrected for the libertas driver. Because
> routine usb_fill_bulk_urb() does not check that DMA is possible when
           ^^^
hmm, usb_fill_bulk_urb? No, that should be usb_submit_urb :)

http://osdir.com/ml/linux-wireless/2009-10/msg01182.html

> dma_map_single() is called, this condition was not detected until the buffer
> was unmapped. By this time memory corruption had occurred.
> 
> The situation is fixed by testing the returned DMA address. If not a legal
> address, a WARN_ON(1) is executed to provide traceback and the error is
> returned.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

