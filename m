Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45189 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab0EKFto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 01:49:44 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 10 May 2010 22:49:44 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19432.61450.971181.675920@gargle.gargle.HOWL>
Date: Tue, 11 May 2010 11:20:02 +0530
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
Subject: [patch 2/9] ath9k: range checking issues in htc_hst.c
In-Reply-To: <20100508162201.GN27064@bicker>
References: <20100508162201.GN27064@bicker>
From: <Sujith.Manoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter wrote:
> The original code had ENDPOINT_MAX and HST_ENDPOINT_MAX switched.
> 
> Also the first loop was off by one, it started past the end of the array
> and went down to 1 instead of going down to 0.  The test at the end of
> the loop to see if we exited via a break wasn't right because
> "tmp_endpoint" is always non-null here.

This is a very good catch and fixes a stack corruption issue.
Do you mind if I work upon this patch and send out an updated fix ?

Sujith
