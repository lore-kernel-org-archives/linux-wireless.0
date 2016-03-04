Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:32880 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758882AbcCDJwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 04:52:05 -0500
Received: by mail-wm0-f54.google.com with SMTP id l68so12889434wml.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2016 01:52:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87h9gmy538.fsf@kamboji.qca.qualcomm.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
	<1453384006-31907-11-git-send-email-michal.kazior@tieto.com>
	<87h9gmy538.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 4 Mar 2016 10:52:04 +0100
Message-ID: <CA+BoTQmgMBfz+Dkf-+0gDHvnhk5OA4_ZGZgwYDKXG5yP-xMRYw@mail.gmail.com> (sfid-20160304_105214_627401_2A245800)
Subject: Re: [PATCH 10/13] ath10k: implement flushing of pending frames in txqs
From: Michal Kazior <michal.kazior@tieto.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 March 2016 at 10:17, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Firmware supporting pull-push tx model may request
>> a switch between modes. When switching from
>> pull-push to push-only it will be necessary to
>> flush all pending frames. The code will do that
>> once other bits that actually trigger it are added.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> This fails to apply:
>
> fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/htt_rx.c).
> Repository lacks necessary blobs to fall back on 3-way merge.
> Cannot fall back to three-way merge.
> Patch failed at 0010 ath10k: implement flushing of pending frames in txqs
>
>> @@ -2370,6 +2371,8 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
>>               dev_kfree_skb_any(skb);
>>       }
>>
>> +     ath10k_mac_tx_push_pending(ar);
>> +
>>       spin_lock_bh(&htt->rx_ring.lock);
>>       while ((skb = __skb_dequeue(&htt->rx_compl_q))) {
>>               resp = (struct htt_resp *)skb->data;
>
> This hunk seems to be the problem. I could try to fix it myself but the
> function has changed so I would prefer that you respin.

This patch is in v1. It's base included some extra patches that
weren't in ath.git at the time.

The v2 patchset has this patch squashed into wake_tx_queue patch and
the entire v2 patchset is based solely on ath.git without any extra
patches in between. Did patchwork confuse these patchsets?


Michał
