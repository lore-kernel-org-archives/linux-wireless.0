Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5C6C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A01E2147C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:25:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UtUyfoFv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UtUyfoFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfBGOZU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:25:20 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57930 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfBGOZU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:25:20 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B7D6D607F5; Thu,  7 Feb 2019 14:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549549519;
        bh=bD+mdQbU4SKXfRdQ5al0t2Xk+4Z24bU7lL8zVtDcbHo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UtUyfoFvW5GrDqNiqg01XyjQTKKeQhMcGyFYku3km8/8oM+6CucorFfO7j6NMjPFJ
         YXOfbn8W9ywwH8FiHVqsxnCV3XaeVV21QSr+xDJON4J4EPUCrVgkJ5kDyHA+NNaMWN
         keb8MbSCTFdrPOxhnOjhtoowiqIb/fUBArylkkBs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E8579602CC;
        Thu,  7 Feb 2019 14:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549549519;
        bh=bD+mdQbU4SKXfRdQ5al0t2Xk+4Z24bU7lL8zVtDcbHo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UtUyfoFvW5GrDqNiqg01XyjQTKKeQhMcGyFYku3km8/8oM+6CucorFfO7j6NMjPFJ
         YXOfbn8W9ywwH8FiHVqsxnCV3XaeVV21QSr+xDJON4J4EPUCrVgkJ5kDyHA+NNaMWN
         keb8MbSCTFdrPOxhnOjhtoowiqIb/fUBArylkkBs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E8579602CC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     yiboz <yiboz@codeaurora.org>
Cc:     erik.stromdahl@gmail.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: FW: [PATCH] ath10k: fix return value check in wake_tx_q op
References: <20180506132500.16888-1-erik.stromdahl@gmail.com>
        <6dc00772b826410e930306891fd13ed9@euamsexm01f.eu.qualcomm.com>
        <c77a1c0961f34ee68b7266444d2207f5@aptaiexm02e.ap.qualcomm.com>
        <66a74025a23795f305de37989c1b8aa3@codeaurora.org>
Date:   Thu, 07 Feb 2019 16:25:15 +0200
In-Reply-To: <66a74025a23795f305de37989c1b8aa3@codeaurora.org>
        (yiboz@codeaurora.org's message of "Mon, 28 Jan 2019 15:01:50 +0800")
Message-ID: <87sgwz8ylw.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(please don't top post)

yiboz <yiboz@codeaurora.org> writes:

> We have met performance issue on our two-core system after applying
> your patch. In WDS mode, we found that the peak throughput in TCP-DL
> and UDP-DL dropped more than 10% compared with previous one. And in
> some cases, though throughput stays the same, one CPU usage rises
> about 20% which leads to 10% in total CPU usage. With your change, I
> think driver will try its best to push as many packets as it can.
> During this time, the driver's queue lock will be held for too much
> time in one CPU and as a result, the other CPU will be blocked if it
> wants to acquired the same lock. Working in this way seems not
> efficiency.
>
> So I think it is better to revert the change till we come up with a
> new solution.

I don't think reverting is a clear option at this stage because that
again creates problems for SDIO. IIRC without this patch SDIO was
sending one packet a time (or something like that, can't remember all
the details right now).

Why does this happen only WDS mode? Did you test other modes, like AP or
client mode?

-- 
Kalle Valo
