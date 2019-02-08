Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D685C282CC
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BFC820857
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:32:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AndHQEMS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AndHQEMS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfBHNcR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:32:17 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45862 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfBHNcR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:32:17 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DE78C602CC; Fri,  8 Feb 2019 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549632735;
        bh=61EGU6tzkXMnOx8Y9QbIRzeijAJcvTJ/ObWCNgUSKX0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AndHQEMSs0BgjxZLlDp96yuw+ZaM1R/0ywQD3U6ZVSjnjOPHSqwZNLmaeJef9c0bd
         OogWDlg3fU0cMX3deGyuaf9TOU4cQJjQJ/bAsngGbOe4z423BMftBWLcDaEr7VXmH8
         g+vViJ36CYH06LvAYKH9+4UGqMxc5PGoZDoz0Qjo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D0B3460264;
        Fri,  8 Feb 2019 13:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549632735;
        bh=61EGU6tzkXMnOx8Y9QbIRzeijAJcvTJ/ObWCNgUSKX0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=AndHQEMSs0BgjxZLlDp96yuw+ZaM1R/0ywQD3U6ZVSjnjOPHSqwZNLmaeJef9c0bd
         OogWDlg3fU0cMX3deGyuaf9TOU4cQJjQJ/bAsngGbOe4z423BMftBWLcDaEr7VXmH8
         g+vViJ36CYH06LvAYKH9+4UGqMxc5PGoZDoz0Qjo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D0B3460264
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Wen Gong <wgong@qti.qualcomm.com>
Cc:     =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        Wen Gong <wgong@codeaurora.org>
Subject: Re: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
References: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
        <CABvG-CWg-VXAtoN8HZumW-ZdP6dX9cO_8fWJ58C22kD2yDcXdw@mail.gmail.com>
        <195f3bb0c88c43a6b1ca0ad336f947c0@aptaiexm02f.ap.qualcomm.com>
        <CABvG-CWAfB8jjCDW4ggjJ8_YC++CjttJOMOt4s24F3mymvNR9A@mail.gmail.com>
        <e18e50cae69e44f4b9e4abb1fa110193@aptaiexm02f.ap.qualcomm.com>
Date:   Fri, 08 Feb 2019 15:32:11 +0200
In-Reply-To: <e18e50cae69e44f4b9e4abb1fa110193@aptaiexm02f.ap.qualcomm.com>
        (Wen Gong's message of "Tue, 8 Jan 2019 08:45:26 +0000")
Message-ID: <877eea8kys.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@qti.qualcomm.com> writes:

>> > > > It is because the state has not changed to ATH10K_STATE_ON
>> > > > immediately, then it will have more than two simulate crash
>> > > > process running meanwhile, and complete/wakeup some field twice,
>> > > > it destroy the normal recovery process.
>> > >
>> > > This was intended to allow testing not only firmware crash path (and
>> > > recovery) but also firmware crash while recovering from a firmware crash.
>> > >
>> > If firmware is recovering from crash, then simulate a new crash will trigger
>> error.
>> > So remove it.
>> 
>> That's actually a feature, not a bug. If firmware crashes while driver is
>> restarting after a crash then its likely going to fail again and again causing a
>> crash-restart loop which can affect system performance and responsiveness.
>> It's better to give up and let the system admin take over.
>> 
>> If it's still bothering you then please consider a crash counter threshold so
>> that, e.g. after 5 crash-while-restarting it's going to give up. However I doubt
>> it's worth the effort. My experience tells me firmware crashes during
>> recovery are rarely, if at all, transient.
>> 
>> The simulated fw crash is not representative here. It's a mere tool to test
>> driver code.
>
> The simulated fw crash is only a tool for user to trigger fw crash
> with command

I think Michal knows what simulate_fw_crash as he is the one who
implemented it in commit 278c4a85e626 :)

> This change's purpose is to disallow user to trigger fw crash if the fw is not in a
> Normal state.
>
> If the fw is in recovering state triggered by user's command or by fw, then it will
> disallow user to run command to trigger fw crash again until fw become to a normal
> State.

I agree with Michal here and his proposal about having a crash counter
sounds like a good to me. So I'm dropping this patch.

-- 
Kalle Valo
