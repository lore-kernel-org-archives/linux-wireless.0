Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37960 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1EBEeY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 00:34:24 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 01 May 2011 21:33:56 -0700
Date: Mon, 2 May 2011 10:04:16 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [PATCH] ath9k: Fix drain txq failure in flush
Message-ID: <20110502043415.GA2855@vmraj-lnx.users.atheros.com> (sfid-20110502_063438_958236_17E2215A)
References: <1303984917-12340-1-git-send-email-rmanoharan@atheros.com>
 <20110429192751.GE25999@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110429192751.GE25999@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 30, 2011 at 12:57:51AM +0530, John W. Linville wrote:
> On Thu, Apr 28, 2011 at 03:31:57PM +0530, Rajkumar Manoharan wrote:
> > While draining the txq in flush, the buffers can be
> > added into the tx queue by tx_tasklet which leads to
> > unneccesary chip reset.
> > 
> > This issue was originially found with AR9382 and
> > running heavy uplink udp traffic with higher bandwidth
> > and doing frequent bgscan.
> > 
> > Cc: stable@kernel.org
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> 
> Should this be a fix for 2.6.39?
>
Yes. This patch is meant for 2.6.39 only.

--
Rajkumar
