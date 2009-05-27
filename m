Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14160 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbZE0JES (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 05:04:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 27 May 2009 02:04:21 -0700
Date: Wed, 27 May 2009 14:32:59 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Jeff Hansen <x@jeffhansen.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/4] ath9k: Combine legacy and 11n rc statistics
Message-ID: <20090527090258.GJ4584@vasanth-laptop>
References: <1243400715-13561-1-git-send-email-x@jeffhansen.com> <1243400715-13561-2-git-send-email-x@jeffhansen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1243400715-13561-2-git-send-email-x@jeffhansen.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2009 at 10:35:13AM +0530, Jeff Hansen wrote:
> +       max = 80 + sc->cur_rate_table->rate_cnt * 64;
> +       buf = vmalloc(max + 1);

I think kmalloc() is the better option here, you are not even
allocating a page, you are allocating 2952B at max.

Vasanth

