Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:35105 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaG2Jqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 05:46:52 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so8451416wes.6
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2014 02:46:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87egx4iksd.fsf@kamboji.qca.qualcomm.com>
References: <1405941081-17359-1-git-send-email-michal.kazior@tieto.com>
	<1405941081-17359-2-git-send-email-michal.kazior@tieto.com>
	<87egx4iksd.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 29 Jul 2014 11:46:48 +0200
Message-ID: <CA+BoTQnMKDCPTOZswZTg8s-_hmaKBiwDT_Rj4tt=ReR7RUWQ3w@mail.gmail.com> (sfid-20140729_114656_457983_54B797F1)
Subject: Re: [PATCH 1/2] ath10k: introduce a stricter scan state machine
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"sw@simonwunderlich.de" <sw@simonwunderlich.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 July 2014 11:20, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This aims at fixing some rare scan bugs related to
>> firmware reporting unexpected scan event
>> sequences.
>>
>> One such bug was if spectral scan phyerr reporting
>> prevented firmware from properly propagating scan
>> events to host. This leadsl to scan timeout. After
>> that next scan would trigger scan completed event
>> first (before scan started event) leading to
>> ar->scan.in_progress and timeout timer states to
>> be overwritten incorrectly and making the very
>> next scan to hang forever.
>>
>> Reported-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
>> +enum ath10k_scan_state {
>> +     ATH10K_SCAN_IDLE,
>> +     ATH10K_SCAN_STARTING,
>> +     ATH10K_SCAN_RUNNING,
>> +     ATH10K_SCAN_RUNNING_AND_ABORTING,
>> +};
>
> Can't we just call the last state just as ATH10K_SCAN_ABORTING? I think
> I understand why you added the word "running" there but IMHO that's not
> needed.

I'll change that.


>> @@ -2323,8 +2348,6 @@ void ath10k_halt(struct ath10k *ar)
>>               ath10k_monitor_stop(ar);
>>       }
>>
>> -     del_timer_sync(&ar->scan.timeout);
>> -     ath10k_reset_scan((unsigned long)ar);
>>       ath10k_peer_cleanup_all(ar);
>>       ath10k_core_stop(ar);
>>       ath10k_hif_power_down(ar);
>
> Why you don't call ath10k_scan_reset() here? I would have assumed that
> you do that.

Hmm.. Good catch.

Anyway I need to work on this patch a little bit more and fix another
corner case.


Michał
