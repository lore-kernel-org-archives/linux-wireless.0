Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8822C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 21:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1628218AE
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 21:11:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="Z27pbGRo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfB1VLq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 16:11:46 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:45492 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfB1VLq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 16:11:46 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id DB69540A955;
        Thu, 28 Feb 2019 13:11:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail2.candelatech.com DB69540A955
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1551388302;
        bh=YeIYBn2IJCXtvHTBM0/jd1DfGyZLXFaK3haOUh5tnuU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Z27pbGRoeF7qw9rg3gpDFtH3CICEQBi9YcL/xWmBozzkjvYXhsSZ1NLyX6fisoSm9
         /VHmecXigrPuYhUKTqRK4H4zfKOgvEPurtDmIeGbqsHbiCr0xdPn8AdOuZAkGMQWXF
         X/xlHzzCyj7YTJLaMD92kI0Sx7q4RJ7KbRAH4tZw=
Subject: Re: [RFC] ath10k: Fix DMA errors related to beacons (CT FW only)
To:     =?UTF-8?Q?Micha=c5=82_Kazior?= <kazikcz@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
References: <20190228155823.24749-1-greearb@candelatech.com>
 <CABvG-CUTn3aHAUUvQ6P+BtaWPtrBeeO8b3vfm5w=hB753_+g0g@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <c67eeb9a-3444-dd49-58eb-4e633063fd0e@candelatech.com>
Date:   Thu, 28 Feb 2019 13:11:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CABvG-CUTn3aHAUUvQ6P+BtaWPtrBeeO8b3vfm5w=hB753_+g0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/28/19 10:54 AM, Michał Kazior wrote:
> On Thu, 28 Feb 2019 at 16:59, <greearb@candelatech.com> wrote:
>>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> I often saw the ath10k-ct wave-1 firmware spit DMA errors and
>> hang the entire system, requiring a hard power-cycle to revoer.
>>
>> It appears the issue is that there is no beacon-tx callback in
>> stock firmware, so the driver can delete the beacon DMA buffer
>> while firmware is still trying to access it.
>>
>> So, wave-1 ath10k-ct firmware now sends a beacon-tx-complete
>> wmi message and that allows the driver to safely know when it
>> can clean up the buffer.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>
>> NOTE:  This will not apply or work in upstream kernels since the
>> rest of the CT fw support will not be accepted.  But, I'd appreciate
>> any technical feedback on this in case I missed any corner cases
>> on locking or similar.
> 
> For the record this patch seems to be based on code with "ath10k: Free
> beacon buf later in vdev teardown" included.
> 
> 
> [...]
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index 154dcdabc48a..02a8efa2e783 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> [...]
>> @@ -6147,6 +6151,16 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
>>                  ath10k_warn(ar, "failed to stop spectral for vdev %i: %d\n",
>>                              arvif->vdev_id, ret);
>>
>> +       if (test_bit(ATH10K_FW_FEATURE_BEACON_TX_CB_CT,
>> +                     ar->running_fw->fw_file.fw_features)) {
>> +               int time_left;
>> +
>> +               time_left = wait_for_completion_timeout(&arvif->beacon_tx_done, (3 * HZ));
>> +               if (!time_left)
>> +                       ath10k_warn(ar, "WARNING: failed to wait for beacon tx callback for vdev %i: %d\n",
>> +                                   arvif->vdev_id, ret);
>> +       }
> 
> I think this can race against wmi tx credits replenishment and maybe
> other wmi commands if they get issued (not many of them I suppose
> though). The ordering would need to be something like this:
> 
> cpu0                   cpu1
>                         ath10k_wmi_op_ep_tx_credits
>                         ieee80211_iterate_active_interfaces_atomic
>                         ath10k_wmi_beacon_send_ref_nowait
>                         # preempted
> ieee80211_do_stop
> clear sdata running
> drv_remove_interface
> wait_for_completion_timeout
> ath10k_mac_vif_beacon_cleanup
> free/unmap
>                         gen_beacon_dma(bcn->xxx)
>                         reinit_completion()
>                         ath10k_wmi_cmd_send_nowait()
> 
> Interestingly, this also shows it has been a possible use-after-free
> without your patch. This is probably a unlikely scenario because
> there's a disproportionate amount of code between these flows for this
> to happen.

Thanks for the thorough review.  One thing, the firmware
cannot guarantee it can send the event (due to potential WMI event buffer
exhaustion).  It would be rare that you got unlucky enough to hit the
case where FW ran out of msg buffers right as you were deleting an
interface though.

As far as I can tell, my patch at least does not make the use-after-free
scenario worse, so I'm tempted to ignore that for now.

> 
> There's also a memory leak because ath10k_mac_vif_beacon_free() exits
> without freeing arvif->beacon if beacon_state is SENDING, which it
> will be in in the above race case.

Ok, this could be fixed by definitely freeing the mem in the remove_interface
logic, and is not new to my patch, right?

> 
> With the per-skb beaconing case (which is dead code by the way it
> seems..) iommu wouldn't be happy either because we'd hand over an
> unmapped paddr to ath10k_wmi_cmd_send_nowait(). That's assuming kernel
> didn't crash due to use-after-free on arvif->beacon (stored in `bcn`
> on stack) before that >
> This feels like a candidate for rcu if you wanted to have it fixed
> neatly. It would fix both use-after-free and the locking conundrum -
> ath10k_remove_interface() could NULL the pointer, call_rcu() and
> wait_for_completion() in that call handler, and when its called back
> unmap/free the beacon. This would require a refactor to how beacon
> stuff is stored/maintained - a helper structure that would need carry
> the beacon stuff + rcu_head, and this structure would be allocated and
> assigned with rcu_assign_pointer() to a pointer in ath10k_vif. But I
> feel like it's asking for unbound allocations or other bugs,
> especially since I'm...

This callback only happens at all with CT fw, and I definitely don't want to
deal with an out-of-tree rcu patch.  And, you are not guaranteed to get
the callback as previously mentioned.  So I think rcu might be overkill
for this?

> 
> Not sure if it makes any sense. I would probably just rip out the
> arvif->beacon code completely instead and keep arvif->beacon_buf only
> (memcpy on swba and immediatelly free the skbuff). No point in fixing
> dead code, is there?
> 
> Since you have beacon tx completion you can consider preventing beacon
> corruption, similar to how disabled vsync causes frame tearing, by
> avoiding memcpy() if completion for previous one didn't come. Not sure
> how relevant that is though because if fw/hw are having hard time
> transmitting a beacon then the RF condition must be really harsh and
> unusably bad anyway.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

