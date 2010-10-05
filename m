Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40871 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab0JEUOJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 16:14:09 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 05 Oct 2010 13:14:01 -0700
Date: Tue, 5 Oct 2010 13:14:07 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bruno Randolf <br1@einfach.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"adrian@freebsd.org" <adrian@freebsd.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [ath5k-devel] [PATCH 3/5] ath9k: Use common cycle counters
Message-ID: <20101005201407.GI11831@tux>
References: <20101005095510.3083.46174.stgit@tt-desk>
 <20101005095521.3083.87663.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20101005095521.3083.87663.stgit@tt-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 05, 2010 at 02:55:21AM -0700, Bruno Randolf wrote:
> Update ath9k to use the common cycle counters.
> 
> This also includes other changes from Felix Fietkaus "[PATCH 2/4] ath9k_hw:
> merge codepaths that access the cycle counter registers".
> 
> Compile tested only. ath9k team please review...

Can you move locking to be specific to the core part of
the driver instead of the ath9k_hw ? We try to avoid locking
all over the hardware code. Even ath9k_iowrite32() and
ath9k_ioread32() are core driver helpers, not part of the
hw code.

  Luis
