Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35814 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161138AbcFBOYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 10:24:19 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mike@fireburn.co.uk" <mike@fireburn.co.uk>
Subject: Re: Bug 119151 - [regression] ath10k no longer authenitcates and
 freezes system
Date: Thu, 2 Jun 2016 14:24:11 +0000
Message-ID: <871t4fzn1x.fsf@kamboji.qca.qualcomm.com> (sfid-20160602_162423_111404_BDF00BAB)
References: <8760trzoiw.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8760trzoiw.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Thu, 02 Jun 2016 16:52:23 +0300")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> there's a regression in ath10k:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=119151
>
> Reporter bisected it to this:
>
> 5c86d97bcc1d42ce7f75685a61be4dad34ee8183 is the first bad commit
> commit 5c86d97bcc1d42ce7f75685a61be4dad34ee8183
> Author: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> Date:   Tue Mar 22 17:22:19 2016 +0530
>
> ath10k: combine txrx and replenish task
>
> Since tx completion and rx indication processing are moved out
> of txrx tasklet and rx ring lock contention also removed from txrx
> for rx_ind messages, it would be efficient to combine both replenish
> and txrx tasks. Refill threshold is adjusted for both AP135 and AP148
> (low and high end systems). With this adjustment in AP135, TCP DL is
> improved from 603 Mbps to 620 Mbps and UDP DL is improved from 758 Mbps
> to 803 Mbps. Also no watchdog are observed on UDP BiDi.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Adding Mike, the bug reporter.

-- 
Kalle Valo