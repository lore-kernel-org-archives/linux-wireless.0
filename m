Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24072 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756219AbZJFFxG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 01:53:06 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2009 22:53:10 -0700
Date: Tue, 6 Oct 2009 11:22:23 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [RFT 0/4] ath9k: fix oops during driver unload
Message-ID: <20091006055222.GA26591@vasanth-laptop>
References: <1254801201-15893-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1254801201-15893-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 06, 2009 at 09:23:17AM +0530, Luis Rodriguez wrote:
> This should fix an oops reported by Vasanth.
> Vasanth my rc3 poos out, can you let me know if this
> fixes the issue you saw?
> 
> Luis R. Rodriguez (4):
>   ath9k: move common->debug_mask setting to ath_init_softc()
>   ath9k: fix oops during unload -- initialize hw prior to debugfs
>   ath9k: add helper to un-init the hw properly
>   ath9k: rename ath_beaconq_setup() to ath9k_hw_beaconq_setup()
> 
>  drivers/net/wireless/ath/ath.h          |    6 ++++
>  drivers/net/wireless/ath/ath9k/ath9k.h  |    1 -
>  drivers/net/wireless/ath/ath9k/beacon.c |   12 -------
>  drivers/net/wireless/ath/ath9k/debug.c  |    5 ---
>  drivers/net/wireless/ath/ath9k/hw.c     |   11 ++++++-
>  drivers/net/wireless/ath/ath9k/mac.c    |   13 ++++++++
>  drivers/net/wireless/ath/ath9k/mac.h    |    1 +
>  drivers/net/wireless/ath/ath9k/main.c   |   50 ++++++++++++++++++------------
>  8 files changed, 60 insertions(+), 39 deletions(-)
> 

The issue is not fixed completely, ah->common is used after ah is
freed in ath_cleanup() which makes rmmod ath9k stuck in the middle.

Vasanth
