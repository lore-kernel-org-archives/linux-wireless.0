Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59043
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760178AbXG2WGw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 18:06:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Subject: Re: [PATCH 1/5] Use mutex instead of semaphore in the Host AP driver
Date: Mon, 30 Jul 2007 00:06:41 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070729212909.GC3432@traven> <20070729213434.GD3432@traven>
In-Reply-To: <20070729213434.GD3432@traven>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707300006.42397.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 29 July 2007 23:34, Matthias Kaehlcke wrote:
> The Host AP driver uses a semaphore as mutex. Use the mutex API
> instead of the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> 
> --
> 
> -	res = down_interruptible(&local->rid_bap_sem);
> +	res = mutex_lock_interruptible(&local->rid_bap_mtx);
>  	if (res)
>  		return res;
>  
> @@ -902,7 +902,7 @@ static int hfa384x_set_rid(struct net_device *dev, u16 rid, void *buf, int len)
>  	/* RID len in words and +1 for rec.rid */
>  	rec.len = cpu_to_le16(len / 2 + len % 2 + 1);
>  
> -	res = down_interruptible(&local->rid_bap_sem);
> +	res = mutex_lock_interruptible(&local->rid_bap_mtx);
>  	if (res)
>  		return res;
>  

Is res returned to userspace? If yes, that's not right.
On a interrupted mutex allocation you should return
-ERESTARTSYS to userspace.
