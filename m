Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53026 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbaGRMuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 08:50:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: handle attention flags correctly when A-MSDU
References: <1405342041-7114-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Fri, 18 Jul 2014 15:50:05 +0300
In-Reply-To: <1405342041-7114-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Mon, 14 Jul 2014 14:47:21 +0200")
Message-ID: <87pph225mq.fsf@kamboji.qca.qualcomm.com> (sfid-20140718_145018_273858_D8A66F63)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> In case of A-MSDU RX we should check flags for all
> MSDU subframes to be sure we have correct FCS status.
>
> Before we check attention flags only for first frame
> where we didn't have correct info about FCS status in
> case of A-MSDU. Next didn't mark RX_FLAG_FAILED_FCS_CRC
> for skb. As a side efect we see big TP drop when TCP used.
> This was easy to reproduce when AP interface was used
> and added monitor interface run in promiscuous mode.
>
> Reported-by: Denton Gentry <denton.gentry@gmail.com>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

I'm having a hard time to understand the commit log. I think it would
make it easier to read if you first clearly describe the bug you are
fixing and then, in a separate paragraph, tell how you fix it.

So what is the bug Denton reported? "we see big TP drop when TCP used"
implies that this happens with all TCP traffic, but that can't be right.
Or did it happen with one of the reorder patches?

-- 
Kalle Valo
