Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48620 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaAWMiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 07:38:50 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	"Michal Kazior" <michal.kazior@tieto.com>
Subject: Re: [PATCH v2] ath10k: implement and use new beacon method
References: <1390477701-16843-1-git-send-email-marek.puzyniak@tieto.com>
Date: Thu, 23 Jan 2014 14:38:45 +0200
In-Reply-To: <1390477701-16843-1-git-send-email-marek.puzyniak@tieto.com>
	(Marek Puzyniak's message of "Thu, 23 Jan 2014 12:48:21 +0100")
Message-ID: <87zjmm50ve.fsf@kamboji.qca.qualcomm.com> (sfid-20140123_133854_556511_9D3EC86F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> From: Michal Kazior <michal.kazior@tieto.com>
>
> Until now ath10k used a copy-by-value beacon
> submission.
>
> The new method passes a DMA address via WMI
> command only. This command contains additional
> metadata that fixes AP behaviour with regard
> to powersave buffering.
>
> This also fixes strange bug when multicast traffic
> would freeze TX indefinitely.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
> ---
>
> v2:
>  -rebased,
>  -beacon send function refactored,
>  -comments moved before field in structure declaration.

I had a conflict when I was applying this to ath-next-test branch for
pending patches. Can you please double check that I didn't break
anything:

https://github.com/kvalo/ath/commit/311f8996ada0e9ff94d5b122b1f022b72e0cdb39

-- 
Kalle Valo
