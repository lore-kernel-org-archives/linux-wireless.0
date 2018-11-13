Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E7BC43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 21:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC0D223DD
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 21:07:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TLLE1gUn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDC0D223DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbeKNHHK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 02:07:10 -0500
Received: from mail-yb1-f182.google.com ([209.85.219.182]:41635 "EHLO
        mail-yb1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbeKNHHK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 02:07:10 -0500
Received: by mail-yb1-f182.google.com with SMTP id t13-v6so6003213ybb.8
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2018 13:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=gTXychc71FMnGmpIQi2ku/qKM6NGHPFr7RLV77Ldb4c=;
        b=TLLE1gUnoV+0++dCb0630f2waUXWgQp5bWO7dMPOweYghq/cx9BDZzq2KgS2FinaYu
         e3bUkUesI7B2yuKL0zZLxLl/mfxv5foO6FIV3udbZycenow7lIzHheAXbC5bn5rMsYhK
         z2jYtTW1oh8WwUUBWjP/PYmI4L36MmX5DrWIA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=gTXychc71FMnGmpIQi2ku/qKM6NGHPFr7RLV77Ldb4c=;
        b=lzyuPCc8c3BJLvprujcBnoYv2rDCI9oNV0IJkmhNA5AuH5PdWEkpzeR9dwtiDq06jX
         Z0dXH5Lco9RPWfIiRmJ64z1uckHSFFkfWk1DVI6AUKccgSUl5PaTDL/xtsI4V9m8Irpr
         RYmVfnlQAR79/DXy81EAntgn+0VY8X7jgvQCLL7TE/DDjIJnb2TORJRPcYEkzcZMX3LO
         l+rJxw6YzY3OI1Ru4eOps7kpSBWs0wpHRUont3i4kfrSb4rEtHoB99SYr4rthoTzsEQh
         heOgXVkwOP3wfXKzNqZxENRGpcI2sOqOUWkxKxCyqUQ+IKxX/DA2xmj/FWZbD3PRrTJt
         Hrow==
X-Gm-Message-State: AGRZ1gIZ3m0uOQYvdUptSk8LZjRAaQboUVy+s0hDEffGWcZSfzqDKn7D
        +8wTcUAnw0oBRqP3bYFLzHNvrw7i8STaBg==
X-Google-Smtp-Source: AJdET5ddGX/GEG4VgWUl2bjCAv4l4OnkqBWV10KdxmuRPkI6FZ4BLvSG5aP11uvWqYXfyiMaNuIdWg==
X-Received: by 2002:a25:f40b:: with SMTP id q11-v6mr6830989ybd.69.1542143232524;
        Tue, 13 Nov 2018 13:07:12 -0800 (PST)
Received: from [10.177.251.169] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id j65-v6sm5374205ywg.52.2018.11.13.13.07.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 13:07:11 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: Use standard SKB list accessors in
 brcmf_sdiod_sglist_rw.
To:     Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>
References: <20181110.163402.130407398146253939.davem@davemloft.net>
 <87pnv99qdh.fsf@purkki.adurom.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <60f8f1c2-2b20-be60-e248-13dfcc58298d@broadcom.com>
Date:   Tue, 13 Nov 2018 22:07:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <87pnv99qdh.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/13/2018 12:19 PM, Kalle Valo wrote:
> David Miller <davem@davemloft.net> writes:
>
>> [ As I am trying to remove direct SKB list pointer accesses I am
>>   committing this to net-next.  If this causes a lot of grief I
>>   can and will revert, just let me know. ]
>>
>> Instead of direct SKB list pointer accesses.
>>
>> The loops in this function had to be rewritten to accommodate this
>> more easily.
>>
>> The first loop iterates now over the target list in the outer loop,
>> and triggers an mmc data operation when the per-operation limits are
>> hit.
>>
>> Then after the loops, if we have any residue, we trigger the last
>> and final operation.
>>
>> For the page aligned workaround, where we have to copy the read data
>> back into the original list of SKBs, we use a two-tiered loop.  The
>> outer loop stays the same and iterates over pktlist, and then we have
>> an inner loop which uses skb_peek_next().  The break logic has been
>> simplified because we know that the aggregate length of the SKBs in
>> the source and destination lists are the same.
>>
>> This change also ends up fixing a bug, having to do with the
>> maintainance of the seg_sz variable and how it drove the outermost
>> loop.  It begins as:
>>
>> 	seg_sz = target_list->qlen;
>>
>> ie. the number of packets in the target_list queue.  The loop
>> structure was then:
>>
>> 	while (seq_sz) {
>> 		...
>> 		while (not at end of target_list) {
>> 			...
>> 			sg_cnt++
>> 			...
>> 		}
>> 		...
>> 		seg_sz -= sg_cnt;
>>
>> The assumption built into that last statement is that sg_cnt counts
>> how many packets from target_list have been fully processed by the
>> inner loop.  But this not true.
>>
>> If we hit one of the limits, such as the max segment size or the max
>> request size, we will break and copy a partial packet then contine
>> back up to the top of the outermost loop.
>>
>> With the new loops we don't have this problem as we don't guard the
>> loop exit with a packet count, but instead use the progression of the
>> pkt_next SKB through the list to the end.  The general structure is:
>>
>> 	sg_cnt = 0;
>> 	skb_queue_walk(target_list, pkt_next) {
>> 		pkt_offset = 0;
>> 		...
>> 		sg_cnt++;
>> 		...
>> 		while (pkt_offset < pkt_next->len) {
>> 			pkt_offset += sg_data_size;
>> 			if (queued up max per request)
>> 				mmc_submit_one();
>> 		}
>> 	}
>> 	if (sg_cnt)
>> 		mmc_submit_one();
>>
>> The variables that maintain where we are in the MMC command state such
>> as req_sz, sg_cnt, and sgl are reset when we emit one of these full
>> sized requests.
>>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>
> Looks good to me, thanks.

Looks good to me too. However, I currently do not have the hardware at 
hands to give it a run for its money. I would prefer to have a tested-by 
tag. May take me a couple of days to revive a setup.

Regards,
Arend
