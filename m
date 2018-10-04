Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199B7C64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D23E420652
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dgHk831n";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dgHk831n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D23E420652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbeJDTXn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 15:23:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33858 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbeJDTXm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 15:23:42 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BBA7F60C8A; Thu,  4 Oct 2018 12:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538656237;
        bh=8ebnf39hFGmdUqDwnfXkXAIfckDT/vueoayWFMBXim8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dgHk831niV48a4TYeW4zyP/jVzoId6j1wJiIyEQN3iMWweC2U5zAZ/pCBUiQ5afxj
         kBl9w7h/DcccGWaDSmGZw3FmSkjp9BCHzyKlcfdwRY0FiTlQka+PFl5xAOuDQOD5KA
         JIXrrqS+QB4ezAKMGXZXb45DcQIH8mOy4rKe0DT0=
Received: from x230.qca.qualcomm.com (85-76-114-39-nat.elisa-mobile.fi [85.76.114.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ADD7E6043F;
        Thu,  4 Oct 2018 12:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538656237;
        bh=8ebnf39hFGmdUqDwnfXkXAIfckDT/vueoayWFMBXim8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dgHk831niV48a4TYeW4zyP/jVzoId6j1wJiIyEQN3iMWweC2U5zAZ/pCBUiQ5afxj
         kBl9w7h/DcccGWaDSmGZw3FmSkjp9BCHzyKlcfdwRY0FiTlQka+PFl5xAOuDQOD5KA
         JIXrrqS+QB4ezAKMGXZXb45DcQIH8mOy4rKe0DT0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ADD7E6043F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: Re: [PATCH 01/12] rtwlan: main files
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
        <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
        <20180927135040.GA4712@redhat.com>
        <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
        <20180928092918.GC8323@redhat.com>
        <F7CD281DE3E379468C6D07993EA72F84D17280C5@RTITMBSVM01.realtek.com.tw>
Date:   Thu, 04 Oct 2018 15:30:33 +0300
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17280C5@RTITMBSVM01.realtek.com.tw>
        (Tony Chuang's message of "Tue, 2 Oct 2018 09:35:35 +0000")
Message-ID: <87woqx28t2.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

> Hi Kale & Stanislaw,
>
> I am working on the driver code and making some changes that Stanislaw
> have mentioned. And I expected that I will finish them tomorrow, what
> should I do after I finished them?
>
> Should I send an RFCv2, or start a new RFC for it ?

Like Stanislaw said, RFCv2 is the right thing to do and I see that you
did that already.

> Because our driver will be renamed from rtwlan to rtw88 for
> 8822B/8822C

I like rtw88, a good choise.

-- 
Kalle Valo
