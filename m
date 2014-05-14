Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11207 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbaENMwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 08:52:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Hold tx-lock while detaching htt.
References: <1397695357-14028-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQ=Q3s6_9tXq02_3S0=q5qv4U4V1F_qHoN1X1pfWV9CKBA@mail.gmail.com>
Date: Wed, 14 May 2014 15:52:43 +0300
In-Reply-To: <CA+BoTQ=Q3s6_9tXq02_3S0=q5qv4U4V1F_qHoN1X1pfWV9CKBA@mail.gmail.com>
	(Michal Kazior's message of "Thu, 17 Apr 2014 08:12:06 +0200")
Message-ID: <878uq4h690.fsf@kamboji.qca.qualcomm.com> (sfid-20140514_145254_466706_D082A564)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 17 April 2014 02:42,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> And check for null pool in the tx path (which would
>> indicate we are detaching).
>
> Shouldn't we just make sure tx is stopped before we try to detach htt?
> Stoping mac80211 queues and synchronize_net() should be sufficient I
> think.
>
>
>> @@ -403,6 +412,13 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
>>                 goto err;
>>
>>         spin_lock_bh(&htt->tx_lock);
>> +
>> +       /* Check if we are detached... */
>> +       if (! htt->tx_pool) {
>> +               spin_unlock_bh(&htt->tx_lock);
>
> Setting `res` would be nice to indicate an error. And there's a space after !.

Ben, are you planning to send v2? Or what should we do with this patch?

-- 
Kalle Valo
