Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932879AbcCQO6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 10:58:32 -0400
Date: Thu, 17 Mar 2016 15:56:43 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00usb: Use usb anchor to manage URB
Message-ID: <20160317145642.GA2846@redhat.com> (sfid-20160317_155835_996750_41B205B4)
References: <1458215759-12641-1-git-send-email-vishalthanki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458215759-12641-1-git-send-email-vishalthanki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 17, 2016 at 12:55:59PM +0100, Vishal Thanki wrote:
> @@ -840,6 +857,8 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf)
>  	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
>  	struct rt2x00_dev *rt2x00dev = hw->priv;
>  
> +	usb_kill_anchored_urbs(rt2x00dev->anchor);

Driver can still submit urb's after that. This should be placed
after we disable radio and flush queues and race conditions with
hrtimer rt2800usb_tx_sta_fifo_timeout() should be handled.

Stanislaw
