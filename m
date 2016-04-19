Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1046 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598AbcDSPrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 11:47:17 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH] ath10k: fix rx_channel during hw reconfigure
Date: Tue, 19 Apr 2016 15:47:12 +0000
Message-ID: <87zispiosq.fsf@kamboji.qca.qualcomm.com> (sfid-20160419_174719_900197_8A9D3206)
References: <1460011314-15978-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1460011314-15978-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Thu, 7 Apr 2016 12:11:54 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Upon firmware assert, restart work will be triggered so that mac80211
> will reconfigure the driver. An issue is reported that after restart
> work, survey dump data do not contain in-use (SURVEY_INFO_IN_USE) info
> for operating channel. During reconfigure, since mac80211 already has
> valid channel context for given radio, channel context iteration return
> num_chanctx > 0. Hence rx_channel is always NULL. Fix this by assigning
> channel context to rx_channel when driver restart is in progress.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Applied, thanks.

-- 
Kalle Valo