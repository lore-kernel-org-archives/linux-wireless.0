Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:44490 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbbCKGam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 02:30:42 -0400
Received: by wesp10 with SMTP id p10so6771480wes.11
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2015 23:30:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87twxsyiqn.fsf@kamboji.qca.qualcomm.com>
References: <87fv9hyz2r.fsf@kamboji.qca.qualcomm.com>
	<1425908197-16118-1-git-send-email-michal.kazior@tieto.com>
	<1425908197-16118-2-git-send-email-michal.kazior@tieto.com>
	<87twxsyiqn.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 11 Mar 2015 07:30:40 +0100
Message-ID: <CA+BoTQkm1Y80+PB9JsncgusS=Ny6FkEbSO4Hf3j_TOt6TgMv-g@mail.gmail.com> (sfid-20150311_073048_087088_871CEBE5)
Subject: Re: [PATCH v2 2/2] ath10k: add hw connection monitor support
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 March 2015 at 16:28, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Some firmware revisions (e.g. qca6174 with fw73)
>> don't deliver beacons to host reliably. This
>> causes random disconnects even in perfect
>> conditions. This is most visible with
>> multi-channel operation.
>>
>> All available firmware revisions seem to support
>> beacon miss offloading so there shouldn't be any
>> problems.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> @@ -2139,6 +2208,8 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
>>       spin_lock_bh(&arvif->ar->data_lock);
>>       arvif->is_up = false;
>>       spin_unlock_bh(&arvif->ar->data_lock);
>> +
>> +     cancel_delayed_work_sync(&arvif->connection_loss_work);
>>  }
>
> There was a simple conflict here, please check the pending branch for my
> resolution.

Looks good, thanks!


Michał
