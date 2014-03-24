Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:41782 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaCXLVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 07:21:22 -0400
Received: by mail-oa0-f47.google.com with SMTP id i11so5613468oag.6
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 04:21:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871txr7svw.fsf@kamboji.qca.qualcomm.com>
References: <1395428150-31996-1-git-send-email-greearb@candelatech.com>
	<871txr7svw.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 24 Mar 2014 12:21:21 +0100
Message-ID: <CA+BoTQmquq7dXTV0sSV1mJ0+8-9OuiCnqz2iN8VNO4J3iaeexQ@mail.gmail.com> (sfid-20140324_122126_080200_B3C20423)
Subject: Re: [PATCH 1/3] ath10k: Add debugging for tx-credits usage.
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 March 2014 12:12, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This helps track tx credits accounting and usage.  If
>> firmware hangs or otherwise fails to return credits, one
>> can more easily see the last few command types that
>> was send to the firmware.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> This patchset didn't apply, and the sha1 ids were useless so that 3-way
> merge didn't work. Can you rebase, please? And better yet if you rebase
> in top of my master branch.
>
>>  int ath10k_htc_send(struct ath10k_htc *htc,
>>                   enum ath10k_htc_ep_id eid,
>> -                 struct sk_buff *skb)
>> +                 struct sk_buff *skb, int dbg)
>>  {
>>       struct ath10k_htc_ep *ep = &htc->endpoint[eid];
>>       struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
>> @@ -167,6 +167,10 @@ int ath10k_htc_send(struct ath10k_htc *htc,
>>                       goto err_pull;
>>               }
>>               ep->tx_credits -= credits;
>> +             ath10k_dbg(ATH10K_DBG_HTC,
>> +                        "ep %d used %d credits, remaining %d dbg %d (0x%x)\n",
>> +                        eid, credits, ep->tx_credits, dbg, dbg);
>> +
>>               spin_unlock_bh(&htc->tx_lock);
>>       }
>
> [...]
>
>> @@ -680,7 +684,7 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
>>
>>       reinit_completion(&htc->ctl_resp);
>>
>> -     status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
>> +     status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb, __LINE__);
>
> Using line numbers in debug messages is very cumbersome. Some people
> cherry pick patches, have their own changes and whatnot which will make
> it more difficult to read the debug logs. Isn't there any better way to
> do this?

I would prefer to explicitly wait for tx credit replenishment in
ath10k_wmi_cmd_send() after a command is sent instead of all these
prints. This way you can get a full call trace if it times out.


Michał
