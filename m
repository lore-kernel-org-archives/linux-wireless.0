Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:64463 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbaENM7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 08:59:21 -0400
Received: by mail-we0-f174.google.com with SMTP id k48so1854021wev.5
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2014 05:59:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878uq4h690.fsf@kamboji.qca.qualcomm.com>
References: <1397695357-14028-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQ=Q3s6_9tXq02_3S0=q5qv4U4V1F_qHoN1X1pfWV9CKBA@mail.gmail.com>
	<878uq4h690.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 14 May 2014 14:59:09 +0200
Message-ID: <CA+BoTQnPznQ_yFGVSvZY9PUsSGZmwPSsQcorpMYmNBgJ0vZOsQ@mail.gmail.com> (sfid-20140514_145933_130626_1F5F7A41)
Subject: Re: [PATCH] ath10k: Hold tx-lock while detaching htt.
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 May 2014 14:52, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 17 April 2014 02:42,  <greearb@candelatech.com> wrote:
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> And check for null pool in the tx path (which would
>>> indicate we are detaching).
>>
>> Shouldn't we just make sure tx is stopped before we try to detach htt?
>> Stoping mac80211 queues and synchronize_net() should be sufficient I
>> think.
>>
>>
>>> @@ -403,6 +412,13 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
>>>                 goto err;
>>>
>>>         spin_lock_bh(&htt->tx_lock);
>>> +
>>> +       /* Check if we are detached... */
>>> +       if (! htt->tx_pool) {
>>> +               spin_unlock_bh(&htt->tx_lock);
>>
>> Setting `res` would be nice to indicate an error. And there's a space after !.
>
> Ben, are you planning to send v2? Or what should we do with this patch?

My patchset `ath10k: recovery fixes 2014-05-09` fixes the problem by
avoiding the tx to happen when it shouldn't in the first place so
Ben's patch isn't necessary anymore I suppose.


Michal
