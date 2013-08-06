Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41857 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3HFI5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 04:57:30 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20992.47215.657712.108336@gargle.gargle.HOWL> (sfid-20130806_105734_289422_60AD1CEE)
Date: Tue, 6 Aug 2013 14:18:47 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 11/12] ath9k: improve tx scheduling fairness
In-Reply-To: <1375732583-39001-11-git-send-email-nbd@openwrt.org>
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
	<1375732583-39001-11-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Instead of trying to schedule the same TID multiple times in a loop,
> iterate over other TIDs/stations first.

The txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH check in the beginning 
of txq_schedule() is not really correct after this, no ?

Sujith
