Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab1BXJjb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 04:39:31 -0500
Date: Thu, 24 Feb 2011 10:39:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] ath9k: correct ath9k_hw_set_interrupts
Message-ID: <20110224093912.GA2222@redhat.com>
References: <20110221140210.GA5996@redhat.com>
 <20110223212132.GC2729@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110223212132.GC2729@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 23, 2011 at 04:21:32PM -0500, John W. Linville wrote:
> On Mon, Feb 21, 2011 at 03:02:41PM +0100, Stanislaw Gruszka wrote:
> > Commit 4df3071ebd92ef7115b409da64d0eb405d24a631 "ath9k_hw: optimize
> > interrupt mask changes", changed ath9k_hw_set_interrupts function to
> > enable interrupts regardless of function argument, what could possibly
> > be wrong. Correct that behaviour and check "ints" arguments before
> > enabling interrupts, also disable interrupts if ints do not have
> > ATH9K_INT_GLOBAL flag set.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> Should this be Cc: stable@kernel.org?

I think no. 4df3071ebd92e is from .38-rc1 , this patch should 
go to 38 if possible. If not, I'm still not sure about stable.
It does not fix any pratical issues for me, my ath9k device
work good with and without patch.

Stanislaw
