Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab0HYOWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 10:22:38 -0400
Subject: Re: [PATCH 1/2] ath9k: Fix for throughput issue in Intel Pinetrail
 platform.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Aeolus.Yang@atheros.com, Senthilkumar.Balasubramanian@atheros.com
In-Reply-To: <1282745092-19825-1-git-send-email-vnatarajan@atheros.com>
References: <1282745092-19825-1-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 16:22:35 +0200
Message-ID: <1282746155.3667.6.camel@jlt3.sipsolutions.net>
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


