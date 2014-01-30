Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaA3Rfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jan 2014 12:35:55 -0500
Message-ID: <1391103351.4323.23.camel@jlt4.sipsolutions.net> (sfid-20140130_183559_453932_E7146837)
Subject: Re: [PATCH 3.13.1 3/9] rsi: Packet queueing/dequeueing to device
From: Johannes Berg <johannes@sipsolutions.net>
To: Jahnavi <jahnavi.meher@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 30 Jan 2014 18:35:51 +0100
In-Reply-To: <52EA75B5.5040002@redpinesignals.com> (sfid-20140130_170030_682221_D838173E)
References: <52EA75B5.5040002@redpinesignals.com>
	 (sfid-20140130_170030_682221_D838173E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-30 at 21:24 +0530, Jahnavi wrote:

> +#ifdef USE_SDIO_INTF
> +static unsigned int pkt_count;
> +#endif
> +static unsigned int selected_qnum, pkt_cnt;

static variables are a really bad idea, especially ones like this. Have
you ever thought about more than one USB device being plugged in to the
same machine? :)

Also, I'm not sure trying to implement QoS in software is a great idea,
or does it only look like that's what you're doing?

johannes

