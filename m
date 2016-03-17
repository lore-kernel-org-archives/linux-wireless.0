Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbcCQIpt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 04:45:49 -0400
Date: Thu, 17 Mar 2016 09:43:32 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00usb: Use usb anchors to manage URB
Message-ID: <20160317084331.GA19458@redhat.com> (sfid-20160317_094554_412026_243D0CC1)
References: <1458149331-2106-1-git-send-email-vishalthanki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458149331-2106-1-git-send-email-vishalthanki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wed, Mar 16, 2016 at 06:28:51PM +0100, Vishal Thanki wrote:
> +struct rt2x00usb_anchors {
> +	struct usb_anchor async_urb;
> +	struct usb_anchor tx_submitted;
> +	struct usb_anchor rx_submitted;
> +};

I don't think we need 3 different usb_anchor's, one should be
enough.

> +static struct rt2x00usb_anchors *anchors;

usb_anchor structure should be embedded in rt2x00_dev structure,
otherwise you can kill urb's from other rt2x00 devices, when
disconnecting another one.

Stanislaw
