Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34067 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab0EJKuZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 06:50:25 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 10 May 2010 03:50:25 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19431.58619.856626.694277@gargle.gargle.HOWL>
Date: Mon, 10 May 2010 16:20:35 +0530
To: Dan Carpenter <error27@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ming Lei <tom.leiming@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [patch 2/9] ath9k: range checking issues in htc_hst.c
In-Reply-To: <20100510102319.GV27064@bicker>
References: <20100508162201.GN27064@bicker>
	<19431.36216.198492.247202@gargle.gargle.HOWL>
	<20100510102319.GV27064@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter wrote:
> I'm afraid I don't understand.  ENDPOINT_MAX is 22 and HST_ENDPOINT_MAX
> is 8.  The htc_target struct is defined as having 8 endpoints.
> 
> drivers/net/wireless/ath/ath9k/htc_hst.h
>    137  struct htc_target {
>    138          void *hif_dev;
>    139          struct ath9k_htc_priv *drv_priv;
>    140          struct device *dev;
>    141          struct ath9k_htc_hif *hif;
>    142          struct htc_endpoint endpoint[HST_ENDPOINT_MAX];
>                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> So in the original code:
> drivers/net/wireless/ath/ath9k/htc_hst.c
>    119                  for (tepid = ENDPOINT_MAX; tepid > ENDPOINT0; tepid--) {
>    120                          tmp_endpoint = &target->endpoint[tepid];
>                                                ^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> 	We are past the end of the array here.  22 vs 7.
> 
> Perhaps the htc_target struct should be changed to ENDPOINT_MAX?

Ah right. That should be fixed.

Sujith
