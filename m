Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E424C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 09:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EA7220823
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 09:30:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bigrsgjK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UMUTLm0k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfARJaY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 04:30:24 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39032 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfARJaX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 04:30:23 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1015260734; Fri, 18 Jan 2019 09:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547803823;
        bh=/KyCPpz9Gl+7Xkl0PM4pUW7tQKVoFNbNyiqjSLFjBIo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bigrsgjKGhkvm4LiV6hLixBld1QMCprv6Sd820PslhhElYWGlgFL1pRKp1FLK3yQb
         yO4HQnVRzzmnNbHVnmyv9sHtinVfcs4U3MeW7RQYRYnGAcmTwtGK3zqK/ywApJqrF0
         RZteZw9R1b2yJirDdaUw7olw1B8FqzcVZ+iNYcug=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E878605A0;
        Fri, 18 Jan 2019 09:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547803822;
        bh=/KyCPpz9Gl+7Xkl0PM4pUW7tQKVoFNbNyiqjSLFjBIo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UMUTLm0kqTzZpRzL3p1u2GvWjBYdC++kX6PHKnVCOPKakQgmLo0DQaKF6jGT2J/PY
         BvL8Mm3cx8N8ZZcPYS7gtU4GqRFhIZB/S7Fs+XM8ybJZ7eUmJ+8GCvipQq6vsmoT8b
         wfAs0yUjzZ31dQGu0qkoqxVgS1ZQlUe4Pn4wO4xo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5E878605A0
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Cody Schuffelen <schuffelen@google.com>,
        <linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net-next] virt_wifi: fix error return code in virt_wifi_newlink()
References: <1547796592-99034-1-git-send-email-weiyongjun1@huawei.com>
Date:   Fri, 18 Jan 2019 11:30:18 +0200
In-Reply-To: <1547796592-99034-1-git-send-email-weiyongjun1@huawei.com> (Wei
        Yongjun's message of "Fri, 18 Jan 2019 07:29:52 +0000")
Message-ID: <87fttqpb2t.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wei Yongjun <weiyongjun1@huawei.com> writes:

> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Fixes: c7cdba31ed8b ("mac80211-next: rtnetlink wifi simulation device")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

BTW, virt_wifi patches go through mac80211-next, not via net-next.

-- 
Kalle Valo
