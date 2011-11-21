Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56147 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1KUTpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 14:45:33 -0500
Date: Mon, 21 Nov 2011 14:34:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH v2] ath9k: Improve ath_tx_aggr_stop to avoid TID stuck in
 cleanup state.
Message-ID: <20111121193422.GD7153@tuxdriver.com> (sfid-20111121_204536_421499_9D56C3F8)
References: <1321767035-3263-1-git-send-email-mar.kolya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1321767035-3263-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 20, 2011 at 12:30:35AM -0500, Nikolay Martynov wrote:
> From: kolya <mar.kolya@gmail.com>
> 
>   When tx agg is being stopped TID is flushed using ath_tx_flush_tid. It is possible that ath_tx_flush_tid completelly flushes TID (if all packets in this TID have already been retried). If this happened ath_tx_aggr_stop would leave TID in cleanup state permanently. Fix this by making ath_tx_flush_tid remove AGGR_ADDBA_COMPLETE and AGGR_CLEANUP flags from TID status if TID is empty.

Please follow the suggestions Kalle made about your patch.  Please also
include a Signed-off-by line.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
