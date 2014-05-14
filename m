Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49607 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaENNBU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 09:01:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Hold tx-lock while detaching htt.
References: <1397695357-14028-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQ=Q3s6_9tXq02_3S0=q5qv4U4V1F_qHoN1X1pfWV9CKBA@mail.gmail.com>
	<878uq4h690.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnPznQ_yFGVSvZY9PUsSGZmwPSsQcorpMYmNBgJ0vZOsQ@mail.gmail.com>
Date: Wed, 14 May 2014 16:01:11 +0300
In-Reply-To: <CA+BoTQnPznQ_yFGVSvZY9PUsSGZmwPSsQcorpMYmNBgJ0vZOsQ@mail.gmail.com>
	(Michal Kazior's message of "Wed, 14 May 2014 14:59:09 +0200")
Message-ID: <874n0sh5uw.fsf@kamboji.qca.qualcomm.com> (sfid-20140514_150123_432714_2E141C8B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 14 May 2014 14:52, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> On 17 April 2014 02:42,  <greearb@candelatech.com> wrote:
>>>> From: Ben Greear <greearb@candelatech.com>
>>>>
>>>> And check for null pool in the tx path (which would
>>>> indicate we are detaching).
>>>
>>> Shouldn't we just make sure tx is stopped before we try to detach htt?
>>> Stoping mac80211 queues and synchronize_net() should be sufficient I
>>> think.
>>>
>>>
>>>> @@ -403,6 +412,13 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
>>>>                 goto err;
>>>>
>>>>         spin_lock_bh(&htt->tx_lock);
>>>> +
>>>> +       /* Check if we are detached... */
>>>> +       if (! htt->tx_pool) {
>>>> +               spin_unlock_bh(&htt->tx_lock);
>>>
>>> Setting `res` would be nice to indicate an error. And there's a space after !.
>>
>> Ben, are you planning to send v2? Or what should we do with this patch?
>
> My patchset `ath10k: recovery fixes 2014-05-09` fixes the problem by
> avoiding the tx to happen when it shouldn't in the first place so
> Ben's patch isn't necessary anymore I suppose.

Ah, that's great. I'll drop this patch then.

-- 
Kalle Valo
