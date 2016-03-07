Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34550 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbcCGGNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 01:13:17 -0500
Received: by mail-wm0-f46.google.com with SMTP id p65so93955021wmp.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2016 22:13:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <874mcjwv04.fsf@kamboji.qca.qualcomm.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
	<1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
	<874mcjwv04.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 7 Mar 2016 07:13:15 +0100
Message-ID: <CA+BoTQnhZfwyCEiMpDsacxNiT_TiGCb7RMOAEwGzVYn+O7ZjPw@mail.gmail.com> (sfid-20160307_071321_190403_2D859043)
Subject: Re: [PATCH v2 00/11] ath10k: implement push-pull tx model
From: Michal Kazior <michal.kazior@tieto.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 March 2016 at 15:18, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This adds support for the new logic where host
>> tells firmware how many frames are queued for each
>> station/tid and then firmware asks host to submit
>> frames for given station/tid.
>>
>> The patch count is a bit high but I tried
>> splitting the patches as much as possible to keep
>> them short and easy to review. Hopefully it's not
>> going to be a huge headache.
>>
>> v2:
>>  - squashes some patches
>>  - reworked pending frame scheduling
>>
>>
>> Michal Kazior (11):
>>   ath10k: refactor tx code
>>   ath10k: unify txpath decision
>>   ath10k: refactor tx pending management
>>   ath10k: maintain peer_id for each sta and vif
>>   ath10k: add fast peer_map lookup
>>   ath10k: add new htt message generation/parsing logic
>>   ath10k: implement wake_tx_queue
>>   ath10k: implement updating shared htt txq state
>>   ath10k: store txq in skb_cb
>>   ath10k: keep track of queue depth per txq
>>   ath10k: implement push-pull tx
>
> I saw two conflicts, please double check my resolutions in the pending
> branch:
>
> Applying: ath10k: implement wake_tx_queue
> CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/htt_rx.c
[...]
> Applying: ath10k: implement push-pull tx
> CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/htt_rx.c

Looks good, thanks!


Michał
