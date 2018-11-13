Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B9B6C43610
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 11:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3324B22507
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 11:19:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Qbq2F+CF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Qbq2F+CF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3324B22507
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732998AbeKMVRH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Nov 2018 16:17:07 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39964 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732506AbeKMVRG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Nov 2018 16:17:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C37806144B; Tue, 13 Nov 2018 11:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542107966;
        bh=F/yC6/zR05Ki4MqFiWOAn1kvfTpCa732cieO/Uhot1Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Qbq2F+CFKz1thCYzZb35AO8JSVz8iPZclqMNV0Xm3Y/IEoAP5eYoftZ1jerSViYSw
         hx8RcqA88tNmlaSXhyBQD2TwaejDkvkWhi9T25Lq5uIp7EyEuGdMRersAF6ujWt6rO
         IenUKGJGR+1sBY83lX55Ca6UemCV5CnbYN8ikJn0=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 99C2160B7A;
        Tue, 13 Nov 2018 11:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542107966;
        bh=F/yC6/zR05Ki4MqFiWOAn1kvfTpCa732cieO/Uhot1Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Qbq2F+CFKz1thCYzZb35AO8JSVz8iPZclqMNV0Xm3Y/IEoAP5eYoftZ1jerSViYSw
         hx8RcqA88tNmlaSXhyBQD2TwaejDkvkWhi9T25Lq5uIp7EyEuGdMRersAF6ujWt6rO
         IenUKGJGR+1sBY83lX55Ca6UemCV5CnbYN8ikJn0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 99C2160B7A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: Use standard SKB list accessors in brcmf_sdiod_sglist_rw.
References: <20181110.163402.130407398146253939.davem@davemloft.net>
Date:   Tue, 13 Nov 2018 13:19:22 +0200
In-Reply-To: <20181110.163402.130407398146253939.davem@davemloft.net> (David
        Miller's message of "Sat, 10 Nov 2018 16:34:02 -0800 (PST)")
Message-ID: <87pnv99qdh.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> [ As I am trying to remove direct SKB list pointer accesses I am
>   committing this to net-next.  If this causes a lot of grief I
>   can and will revert, just let me know. ]
>
> Instead of direct SKB list pointer accesses.
>
> The loops in this function had to be rewritten to accommodate this
> more easily.
>
> The first loop iterates now over the target list in the outer loop,
> and triggers an mmc data operation when the per-operation limits are
> hit.
>
> Then after the loops, if we have any residue, we trigger the last
> and final operation.
>
> For the page aligned workaround, where we have to copy the read data
> back into the original list of SKBs, we use a two-tiered loop.  The
> outer loop stays the same and iterates over pktlist, and then we have
> an inner loop which uses skb_peek_next().  The break logic has been
> simplified because we know that the aggregate length of the SKBs in
> the source and destination lists are the same.
>
> This change also ends up fixing a bug, having to do with the
> maintainance of the seg_sz variable and how it drove the outermost
> loop.  It begins as:
>
> 	seg_sz = target_list->qlen;
>
> ie. the number of packets in the target_list queue.  The loop
> structure was then:
>
> 	while (seq_sz) {
> 		...
> 		while (not at end of target_list) {
> 			...
> 			sg_cnt++
> 			...
> 		}
> 		...
> 		seg_sz -= sg_cnt;
>
> The assumption built into that last statement is that sg_cnt counts
> how many packets from target_list have been fully processed by the
> inner loop.  But this not true.
>
> If we hit one of the limits, such as the max segment size or the max
> request size, we will break and copy a partial packet then contine
> back up to the top of the outermost loop.
>
> With the new loops we don't have this problem as we don't guard the
> loop exit with a packet count, but instead use the progression of the
> pkt_next SKB through the list to the end.  The general structure is:
>
> 	sg_cnt = 0;
> 	skb_queue_walk(target_list, pkt_next) {
> 		pkt_offset = 0;
> 		...
> 		sg_cnt++;
> 		...
> 		while (pkt_offset < pkt_next->len) {
> 			pkt_offset += sg_data_size;
> 			if (queued up max per request)
> 				mmc_submit_one();
> 		}
> 	}
> 	if (sg_cnt)
> 		mmc_submit_one();
>
> The variables that maintain where we are in the MMC command state such
> as req_sz, sg_cnt, and sgl are reset when we emit one of these full
> sized requests.
>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Looks good to me, thanks.

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
