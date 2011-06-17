Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6821 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab1FQVgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 17:36:17 -0400
Message-ID: <4DFBC8CA.8020808@gnu.org> (sfid-20110617_233620_788555_9F3E4005)
Date: Fri, 17 Jun 2011 17:36:10 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, tsyvarev@ispras.ru,
	me@bobcopeland.com, mickflemm@gmail.com
Subject: Re: [PATCH v2] ath5k: free sc->ah in ath5k_deinit_softc
References: <1308343066-13770-1-git-send-email-linville@tuxdriver.com> <1308343290-13875-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1308343290-13875-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/17/2011 04:41 PM, John W. Linville wrote:
> Nothing else is freeing it, and this mirrors the error handling patch
> already in ath5k_init_softc.

You mean path, of course.

>   	ath5k_hw_deinit(sc->ah);
> +	kfree(sc->ah);
>   	free_irq(sc->irq, sc);

Looks good to me.

While at that, ath_ahb_remove() misses ieee80211_free_hw(), which is 
present in the error handling path in ath_ahb_probe().  I have no AHB 
devices to test.  Anyone wants to make a (tested) patch?

-- 
Regards,
Pavel Roskin
