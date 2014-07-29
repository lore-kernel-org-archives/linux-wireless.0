Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40685 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaG2Jv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 05:51:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"sw@simonwunderlich.de" <sw@simonwunderlich.de>
Subject: Re: [PATCH 1/2] ath10k: introduce a stricter scan state machine
References: <1405941081-17359-1-git-send-email-michal.kazior@tieto.com>
	<1405941081-17359-2-git-send-email-michal.kazior@tieto.com>
	<87egx4iksd.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnMKDCPTOZswZTg8s-_hmaKBiwDT_Rj4tt=ReR7RUWQ3w@mail.gmail.com>
Date: Tue, 29 Jul 2014 12:51:17 +0300
In-Reply-To: <CA+BoTQnMKDCPTOZswZTg8s-_hmaKBiwDT_Rj4tt=ReR7RUWQ3w@mail.gmail.com>
	(Michal Kazior's message of "Tue, 29 Jul 2014 11:46:48 +0200")
Message-ID: <87wqawh4ru.fsf@kamboji.qca.qualcomm.com> (sfid-20140729_115130_633557_FA5B82C9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>>> @@ -2323,8 +2348,6 @@ void ath10k_halt(struct ath10k *ar)
>>>               ath10k_monitor_stop(ar);
>>>       }
>>>
>>> -     del_timer_sync(&ar->scan.timeout);
>>> -     ath10k_reset_scan((unsigned long)ar);
>>>       ath10k_peer_cleanup_all(ar);
>>>       ath10k_core_stop(ar);
>>>       ath10k_hif_power_down(ar);
>>
>> Why you don't call ath10k_scan_reset() here? I would have assumed that
>> you do that.
>
> Hmm.. Good catch.
>
> Anyway I need to work on this patch a little bit more and fix another
> corner case.

Ok, I'll drop this patch and wait for the next version.

-- 
Kalle Valo
