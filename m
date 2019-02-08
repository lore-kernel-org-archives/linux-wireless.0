Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7F1C282CC
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FF91217D8
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 14:42:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bHQLMhBo";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="T2M1G5jy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfBHOmt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:42:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45300 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfBHOmt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 09:42:49 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8CCC0608EA; Fri,  8 Feb 2019 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549636968;
        bh=oj4i405fs5jVwuRTyOecz/QhLw3hWOR0I0l9Fd8KFX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bHQLMhBoj9UkHEGQO7n5bnlzbxNY/jrLRYqyY2270n+3gjY6st/Qnck7HtPI5O29q
         rsMN6XwLMn3AUJLhKdwGkDjSGc/E6zTvCgGvyK16+w5rmt7CRxAF6K55vNzMwDrU7H
         fQ8o/atK4pVATJSchUoIDtTZdGkIAAAfrn9FgdNU=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3969460988;
        Fri,  8 Feb 2019 14:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549636956;
        bh=oj4i405fs5jVwuRTyOecz/QhLw3hWOR0I0l9Fd8KFX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T2M1G5jyZ0K49sgJgTBJQRyZcP/hycIPlIegbPr4ACWPxjqs9ZDzmotOoyawLdhTC
         1b3VOFLXCibpsSIe4oUzJzs5hcOU+WfY4EZR8U7A2V1rwImho82/YDpMEt1aRMs5B7
         M5KKDTc/DTxezF1MakvhAUHiJ2lP7jSngFVB/mkE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 08 Feb 2019 20:12:35 +0530
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fix shadow register implementation for WCN3990
In-Reply-To: <20190208141735.43AF360734@smtp.codeaurora.org>
References: <1548755647-23356-1-git-send-email-pillair@codeaurora.org>
 <20190208141735.43AF360734@smtp.codeaurora.org>
Message-ID: <566bdcf168c95646e1a0d2689649025d@codeaurora.org>
X-Sender: pillair@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,
I have checked the patch, and it is fine.

Thanks,
Rakesh Pillai.

On 2019-02-08 19:47, Kalle Valo wrote:
> Rakesh Pillai <pillair@codeaurora.org> wrote:
> 
>> WCN3990 supports shadow registers write operation support
>> for copy engine for regular operation in powersave mode.
>> 
>> Since WCN3990 is a 64-bit target, the shadow register
>> implementation needs to be done in the copy engine handlers
>> for 64-bit target. Currently the shadow register implementation
>> is present in the 32-bit target handlers of copy engine.
>> 
>> Fix the shadow register copy engine write operation
>> implementation for 64-bit target(WCN3990).
>> 
>> Tested HW: WCN3990
>> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
>> 
>> Fixes: b7ba83f7c414 ("ath10k: add support for shadow register for 
>> WNC3990")
>> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> I was able to apply with 3-way merge but please double check the 
> results:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=45112636f48a180c2867c78731ea28ac665495d9
> 
> Applying: ath10k: Fix shadow register implementation for WCN3990
> Using index info to reconstruct a base tree...
> M       drivers/net/wireless/ath/ath10k/ce.c
> M       drivers/net/wireless/ath/ath10k/ce.h
> Falling back to patching base and 3-way merge...
> Auto-merging drivers/net/wireless/ath/ath10k/ce.h
> Auto-merging drivers/net/wireless/ath/ath10k/ce.c
