Return-Path: <SRS0=UTNx=Z7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A50C43603
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Dec 2019 10:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F7CB207FD
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Dec 2019 10:54:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PsOwGyNA";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="hKbK//2z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfLIKye (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 9 Dec 2019 05:54:34 -0500
Received: from a27-55.smtp-out.us-west-2.amazonses.com ([54.240.27.55]:41546
        "EHLO a27-55.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726477AbfLIKye (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Dec 2019 05:54:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575888873;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=T8XQSn+TKa6kRazq60nwAPYM6dCHYqnNv2UTnXtrAWY=;
        b=PsOwGyNAdT8D3pcZaT5HRCJVVdS4lIgTp9wug8kJJunyEPejMRz3OPZWhN5A046M
        y70sDcTBxfE+J4YVtrLKkzkrpDvjyFn3I2NS9c9L2uRa5s2/Yg73kzmet7V/w5qrndE
        xZEi7xZOMxC28WB1cPn7ZnAM+7vKXUhFYNsDW13o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575888873;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=T8XQSn+TKa6kRazq60nwAPYM6dCHYqnNv2UTnXtrAWY=;
        b=hKbK//2z1pmQBugOOz3NEg+85hTfBjcHjwdFopVCfBDfymf+p5yjXLP1DnIjqsHG
        5gDpM5NVIq2+DIfyAyCXCPQbQaql5LF8OIrXxc2oQ1XXu31snLY6lAqt3/QIZZyjApn
        NkWhGKhfZgQ8lLHAp5QjZJIlX3tD5/M6O0CF3Piw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8B620C447AD
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Bjoern Franke <bjo@schafweide.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: Realtek 8822BE: r8822be vs. rtwpci (mainline / lwfinger)
References: <50038b2f-8b90-d803-0377-2c19cc7ad78e@schafweide.org>
Date:   Mon, 9 Dec 2019 10:54:33 +0000
In-Reply-To: <50038b2f-8b90-d803-0377-2c19cc7ad78e@schafweide.org> (Bjoern
        Franke's message of "Fri, 6 Dec 2019 17:48:33 +0100")
Message-ID: <0101016eea4be8c6-86cd4509-2811-4de8-92be-bd5cfa50d49c-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.12.09-54.240.27.55
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Bjoern Franke <bjo@schafweide.org> writes:

> I'm a little confused about the status of the modules for the Realtek
> 8822BE.
>
> Once, there was r8822be which had some issues, but worked more or less
> reliable. Then came rtw88/rtwpci and in my Thinkpad A275 it is hardly

Tony, that rtwpci sounds like very confusing name for a rtw88 module,
even I was first confused what driver is that. I think it should be
rtw88_pci or something like that.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
