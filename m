Return-Path: <SRS0=82ey=XA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77971C3A5A5
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Sep 2019 13:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 059C82070C
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Sep 2019 13:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Th/mutnX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LRz+Keon"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbfIENpo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Sep 2019 09:45:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33038 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbfIENpo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Sep 2019 09:45:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3F7506058E; Thu,  5 Sep 2019 13:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567691143;
        bh=w/3IIFOS8nQCteH4ddE4gwv4ezqYRxVFmhWF+d+7VVo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Th/mutnX9LoQy2L+Z2WxUuvkvxHhhZ7Mm7O/CGwZJMHjB86g/C/f4PA1XjaycV9PV
         U3B7/n8G19cBWyfSOwXEal5vD5gyjeoZEARHBoPulvNndDj5nxkk+4S51SxEQH3jPb
         hWXKrY+/8tV9xOjkAEhG8jjSPziXnCSyC+Q6NNlc=
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F0148606E1;
        Thu,  5 Sep 2019 13:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567691141;
        bh=w/3IIFOS8nQCteH4ddE4gwv4ezqYRxVFmhWF+d+7VVo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LRz+KeonYRJHD+DyRA20Bu+pgLL9j/vsbUaKJ1ZP7Ag6GRwlJdDuNNnOeQ/oZk+aj
         y/50pCEp9lgl9poE40jH8uXGLxlucvMp8HKF+DCjV28XEw1U2G8FYNG9/icUxf4wP9
         Mqw0Haixr+BmHHHq+FSO0TdRi0Mk6PozxfUFvfzw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F0148606E1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hostap: remove set but not used variable 'copied' in prism2_io_debug_proc_read
References: <1567497430-22539-1-git-send-email-zhongjiang@huawei.com>
        <5D6E1DF2.1000109@huawei.com>
Date:   Thu, 05 Sep 2019 16:45:37 +0300
In-Reply-To: <5D6E1DF2.1000109@huawei.com> (zhong jiang's message of "Tue, 3
        Sep 2019 16:01:54 +0800")
Message-ID: <87zhjij1q6.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> writes:

> Please ignore the patch.  Because  the hostap_proc.c is marked as 'obsolete'.

You mean marked in the MAINTAINERS file? I don't see that as a problem,
I can (and should) still apply any patches submitted to hostap driver.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
