Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60042 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0HYO7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 10:59:40 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1OoHS0-0007ua-BB
	for linux-wireless@vger.kernel.org; Wed, 25 Aug 2010 10:59:40 -0400
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id o7PExDRB003916
	for <linux-wireless@vger.kernel.org>; Wed, 25 Aug 2010 10:59:14 -0400
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id o7PExD6v003914
	for linux-wireless@vger.kernel.org; Wed, 25 Aug 2010 10:59:13 -0400
Subject: Re: [PATCH 1/2] ath9k: Fix for throughput issue in Intel Pinetrail
 platform.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.org,
	Aeolus.Yang@atheros.com, Senthilkumar.Balasubramanian@atheros.com
In-Reply-To: <1282745092-19825-1-git-send-email-vnatarajan@atheros.com>
References: <1282745092-19825-1-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 16:21:20 +0200
Message-ID: <1282746080.3667.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-25 at 19:34 +0530, Vivek Natarajan wrote:
> Trigger the generic timer interrupt frequently as a workaround
> to improve the throughput in C3 state with the Intel Pinetrail
> platform.

This seems an awfully lot like a DMA problem with C3 states or something
like that? It seems like you should do something like this:

        pm_qos_add_request(&ipw2100_pm_qos_req, PM_QOS_CPU_DMA_LATENCY,
                           PM_QOS_DEFAULT_VALUE);

(taken from ipw2100)

johannes


