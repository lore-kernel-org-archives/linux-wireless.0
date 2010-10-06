Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:17028 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754837Ab0JFBKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 21:10:55 -0400
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0130257451
	for <linux-wireless@vger.kernel.org>; Wed,  6 Oct 2010 10:10:53 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH 3/5] ath9k: Use common cycle counters
Date: Wed, 6 Oct 2010 10:10:46 +0900
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"adrian@freebsd.org" <adrian@freebsd.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>
References: <20101005095510.3083.46174.stgit@tt-desk> <20101005095521.3083.87663.stgit@tt-desk> <20101005201407.GI11831@tux>
In-Reply-To: <20101005201407.GI11831@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010061010.46430.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed October 6 2010 05:14:07 Luis R. Rodriguez wrote:
> On Tue, Oct 05, 2010 at 02:55:21AM -0700, Bruno Randolf wrote:
> > Update ath9k to use the common cycle counters.
> > 
> > This also includes other changes from Felix Fietkaus "[PATCH 2/4]
> > ath9k_hw: merge codepaths that access the cycle counter registers".
> > 
> > Compile tested only. ath9k team please review...
> 
> Can you move locking to be specific to the core part of
> the driver instead of the ath9k_hw ?

i'm not sure if i understand what you mean. locking is now implemented in 
ath_common.

> We try to avoid locking
> all over the hardware code. Even ath9k_iowrite32() and
> ath9k_ioread32() are core driver helpers, not part of the
> hw code.

but, we need to make sure the cycle counters are always accessed exclusively. 
e.g. ANI runs from a timer (in ath9k, afaik), and updates the cycle counters. 
at the same time a user might issue a survey, or your debug print may be 
executed, which would want to access the same counters. we need to make sure 
the counters are not updated while they are read, etc...

bruno
