Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:46289 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbIQLCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 07:02:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: move hw_scan worker queuing
References: <1441269825-344-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 17 Sep 2015 14:01:59 +0300
In-Reply-To: <1441269825-344-1-git-send-email-michal.kazior@tieto.com> (Michal
	Kazior's message of "Thu, 3 Sep 2015 10:43:45 +0200")
Message-ID: <878u85ux5k.fsf@kamboji.qca.qualcomm.com> (sfid-20150917_130214_727349_821D4372)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The remain_on_channel callback needs different
> timeout. Calling ieee80211_queue_work() with a
> shorter delay after calling it with a longer delay
> will not change the timer. This caused the
> offchannel timeout worker to not trigger in time
> and caused the device to stay on channel longer
> then expected. This could cause some problems and
> was be easily reproduced with `iw offchannel`
> command.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
