Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbcCSIIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2016 04:08:46 -0400
Date: Sat, 19 Mar 2016 09:06:28 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] rt2x00usb: Use usb anchor to manage URB
Message-ID: <20160319080627.GA29771@redhat.com> (sfid-20160319_090852_219159_4BA99CB9)
References: <1458318591-14921-1-git-send-email-vishalthanki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458318591-14921-1-git-send-email-vishalthanki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2016 at 05:29:51PM +0100, Vishal Thanki wrote:
>  
> @@ -1001,6 +1002,9 @@ struct rt2x00_dev {
>  
>  	/* Extra TX headroom required for alignment purposes. */
>  	unsigned int extra_tx_headroom;
> +
> +	struct usb_anchor *anchor;
> +	void (*kill_anchored_urbs)(struct rt2x00_dev *);
...
> @@ -1423,6 +1423,7 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
>  	cancel_delayed_work_sync(&rt2x00dev->autowakeup_work);
>  	cancel_work_sync(&rt2x00dev->sleep_work);
>  	if (rt2x00_is_usb(rt2x00dev)) {
> +		rt2x00dev->kill_anchored_urbs(rt2x00dev);
...
>  
> +static void rt2x00usb_kill_anchored_usb(struct rt2x00_dev *rt2x00dev)
> +{
> +	usb_kill_anchored_urbs(rt2x00dev->anchor);
> +}
...
> +	rt2x00dev->kill_anchored_urbs = rt2x00usb_kill_anchored_usb;

Why do you complicate things, instead of call usb_kill_anchored_urbs()
directly?

Stanislaw
