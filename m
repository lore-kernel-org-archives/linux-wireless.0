Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16446 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab3HLO5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 10:57:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/4] ath10k: fix HTC endpoint worker starvation
References: <1375949813-10969-1-git-send-email-michal.kazior@tieto.com>
	<1375949813-10969-3-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQk4n=kiWhwvzieuvXp5Wou_QpkY=8iU474XPwG7P4KSiQ@mail.gmail.com>
Date: Mon, 12 Aug 2013 17:56:58 +0300
In-Reply-To: <CA+BoTQk4n=kiWhwvzieuvXp5Wou_QpkY=8iU474XPwG7P4KSiQ@mail.gmail.com>
	(Michal Kazior's message of "Thu, 8 Aug 2013 12:12:03 +0200")
Message-ID: <874navt0sl.fsf@kamboji.qca.qualcomm.com> (sfid-20130812_165709_008423_6E41406C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>> @@ -602,7 +602,8 @@ static void ath10k_htc_reset_endpoint_states(struct ath10k_htc *htc)
>>                 skb_queue_head_init(&ep->tx_queue);
>>                 ep->htc = htc;
>>                 ep->tx_credit_flow_enabled = true;
>> -               INIT_WORK(&ep->send_work, ath10k_htc_send_work);
>> +               tasklet_init(&ep->send_task, ath10k_htc_send_task,
>> +                             (unsigned long)ep);
>>         }
>>  }
>>
>
> Indentation is off by one here. Is it okay if I just resend this
> single patch or is it easier for applying if I resend the whole
> patchset?

It's errorprone if I start to pick patches from different sets. So
please resend the whole series. But take a look at my other comment
first.

-- 
Kalle Valo
