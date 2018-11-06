Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED5CC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 12:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 544832085B
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 12:24:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O3+MwcxK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cRkJhgfZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 544832085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbeKFVtt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 16:49:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45870 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbeKFVtt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 16:49:49 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6D3596074F; Tue,  6 Nov 2018 12:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541507090;
        bh=26JjXseu6t5JgMqsxanjdZ4bou2IWGEidMb0TB0tpps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O3+MwcxKFdqyTS6GSq24XcT/EstkRPv7eZ4AaKse+6mss7arleqG/Fe+WBMH3ozpo
         BgIA3Rm1p5PlCH28E4zwI7+N5uZ++tARSm/GJTBYZ8DfZ8XCDLQhOZiwixNAJDH13s
         RO1kOVkH7Z2afOUUlkiKguDUyFPXlfX3d81EGmVQ=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id DDBAA60247;
        Tue,  6 Nov 2018 12:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541507089;
        bh=26JjXseu6t5JgMqsxanjdZ4bou2IWGEidMb0TB0tpps=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cRkJhgfZ2rWD0xCZKp76mi4rS3E9fBPLXypHh6bUq5TlfRvazZPZPfmcfBOBvP5CA
         qLqOaPlgstU0P2Mbu+lcH3oOZGvRTcOUK2AybU/eY3mREqRhGim/aiKXpmWuRu2rjL
         6ozdu3B9zQ42Fl60JfdZ4n3ukGluoER2ksNe6gJY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 06 Nov 2018 14:24:49 +0200
From:   merez@codeaurora.org
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 13/16] wil6210: ignore HALP ICR if already handled
In-Reply-To: <875zxabjyn.fsf@purkki.adurom.net>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
 <1540975944-30576-14-git-send-email-merez@codeaurora.org>
 <875zxabjyn.fsf@purkki.adurom.net>
Message-ID: <872e24220a45caf78fc3679c3bcfe7c2@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-06 12:04, Kalle Valo wrote:
> Maya Erez <merez@codeaurora.org> writes:
> 
>> HALP ICR is set as long as the FW should stay awake.
>> To prevent its multiple handling the driver masks this IRQ bit.
>> However, if there is a different MISC ICR before the driver clears
>> this bit, there is a risk of race condition between HALP mask and
>> unmask. This race leads to HALP timeout, in case it is mistakenly
>> masked.
>> Add an atomic flag to indicate if HALP ICR should be handled.
>> 
>> Signed-off-by: Maya Erez <merez@codeaurora.org>
> 
> [...]
> 
>> --- a/drivers/net/wireless/ath/wil6210/interrupt.c
>> +++ b/drivers/net/wireless/ath/wil6210/interrupt.c
>> @@ -575,10 +575,14 @@ static irqreturn_t wil6210_irq_misc(int irq, 
>> void *cookie)
>>  	}
>> 
>>  	if (isr & BIT_DMA_EP_MISC_ICR_HALP) {
>> -		wil_dbg_irq(wil, "irq_misc: HALP IRQ invoked\n");
>> -		wil6210_mask_halp(wil);
>>  		isr &= ~BIT_DMA_EP_MISC_ICR_HALP;
>> -		complete(&wil->halp.comp);
>> +		if (atomic_read(&wil->halp.handle_icr)) {
>> +			/* no need to handle HALP ICRs until next vote */
>> +			atomic_set(&wil->halp.handle_icr, 0);
> 
> atomic_read() followed by atomic_set() is IMHO not really atomic :) I
> would assume there's a function to reset the variable really in atomic
> way.

Actually it shouldn't be atomic :-)
I'll remove it.

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
