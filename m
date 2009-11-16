Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33998 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbZKPHUP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 02:20:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 15 Nov 2009 23:20:21 -0800
Date: Mon, 16 Nov 2009 12:50:07 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 2/2] ath9k_hw: Fix AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB
	and its shift value in 0x4054
Message-ID: <20091116072004.GC27858@vasanth-laptop>
References: <1258102960-22768-1-git-send-email-vasanth@atheros.com> <1258102960-22768-2-git-send-email-vasanth@atheros.com> <20091113171438.GD3865@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20091113171438.GD3865@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 13, 2009 at 10:44:38PM +0530, Luis Rodriguez wrote:
> On Fri, Nov 13, 2009 at 01:02:40AM -0800, Vasanth Thiagarajan wrote:
> > The bit value of AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB is wrong, it should
> > be 0x400 and the number of bits to be right shifted is 10. Having this
> > wrong value in 0x4054 sometimes affects bt quality on btcoex environment.
> >
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> 
> These both seem small enough and reasonable for stable fixes no?

yeah, I'll resend them CC'ing stable.

> Although I didn't get the impact of the first one..

debruijn32 (0x077CB531UL) is used to find the index of the geric timer
which generated the interrupt. On a 64-bit environment, 0x077CB531UL
will result in indexing more than 32 in gen_timer_index[] which has
memory allocated only for 32 u32.

Vasanth
 
