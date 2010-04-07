Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28003 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0DGEE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 00:04:29 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 21:04:29 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19388.2331.809223.701149@gargle.gargle.HOWL>
Date: Wed, 7 Apr 2010 09:54:59 +0530
To: Ming Lei <tom.leiming@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/5] ath9k_htc: Fix module unloading issue
In-Reply-To: <r2id82e647a1004060646ja618eaecye10b08f05d837e2d@mail.gmail.com>
References: <19387.1463.310224.890658@gargle.gargle.HOWL>
	<r2id82e647a1004060646ja618eaecye10b08f05d837e2d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ming Lei wrote:
> 2010/4/6 Sujith <Sujith.Manoharan@atheros.com>:
> > The maximum number of packets in a single buffer in
> > stream mode is 10. The driver currently uses 8 - which
> > caused stack corruption, in the absence of any kind
> > of OOB checking.
> >
> > Fixing this to the correct value of 10 fixes the module
> > unload issue.
> 
> Great,  the patch fixes the issue of destruction of urb->use_count,
> which caused to sleep forever of usb_kill_urb().
> 
> For this kind of dark issue, it is better to add check for 'pool_index'.

Right, it will be done in a separate patch.

> Tested-by: Ming Lei <tom.leiming@gmail.com>

Thanks !

Sujith
