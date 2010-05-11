Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52474 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab0EKJa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 05:30:29 -0400
Received: by vws17 with SMTP id 17so880989vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 02:30:28 -0700 (PDT)
Date: Tue, 11 May 2010 11:29:38 +0200
From: Dan Carpenter <error27@gmail.com>
To: Sujith.Manoharan@atheros.com
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ming Lei <tom.leiming@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [patch 2/9] ath9k: range checking issues in htc_hst.c
Message-ID: <20100511092938.GY27064@bicker>
References: <20100508162201.GN27064@bicker> <19432.61450.971181.675920@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19432.61450.971181.675920@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 11:20:02AM +0530, Sujith.Manoharan@atheros.com wrote:
> Dan Carpenter wrote:
> > The original code had ENDPOINT_MAX and HST_ENDPOINT_MAX switched.
> > 
> > Also the first loop was off by one, it started past the end of the array
> > and went down to 1 instead of going down to 0.  The test at the end of
> > the loop to see if we exited via a break wasn't right because
> > "tmp_endpoint" is always non-null here.
> 
> This is a very good catch and fixes a stack corruption issue.
> Do you mind if I work upon this patch and send out an updated fix ?
> 
> Sujith

Sorry, I meant to do that yesterday but I was out of it.  Yes.  Please 
send the updated fix.

regards,
dan carpenter
