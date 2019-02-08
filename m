Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784BBC282CB
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 474EE20844
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kchyguwX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cKFNS4jO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfBHNeK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:34:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48640 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbfBHNeK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:34:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8EA2B60791; Fri,  8 Feb 2019 13:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549632849;
        bh=uoDVSqZeTTjEUL8pFunZNPIVQjNLYje/J5NmT2qAcds=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kchyguwX1STvJ+CM+4zgIbjXcGFJloa5MP8uQhnuoqTFeSGJw7Q+v5ILVbNJ42HNK
         K6pj4VrPjr9HJzO6NeMSFNlNbzFuEAjZ04oqFHryqh25CcBtmv6TpXisZsWw5uAa6a
         XJeLsix1QNnVF7bDnjKlxHQrsob1YKVGIqkU+4Kc=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08A86601C4;
        Fri,  8 Feb 2019 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549632848;
        bh=uoDVSqZeTTjEUL8pFunZNPIVQjNLYje/J5NmT2qAcds=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cKFNS4jOEdQlGSm44980pKqrGJr4/vme5hq2kNu6RxlQr60YW3mi9742JBWCI++uC
         Y4+infZ1O9P891DsXIq+/7BAWCA4rSnHQxvctnKrU1YWPdKQ3WdL9uZrVYqDKGw634
         JTtQLK5GQVieUJELX1HIrsTz2IbS/6OoWMErR3h4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 08A86601C4
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
        <877eea8kys.fsf@kamboji.qca.qualcomm.com>
Date:   Fri, 08 Feb 2019 15:34:04 +0200
In-Reply-To: <877eea8kys.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Fri, 08 Feb 2019 15:32:11 +0200")
Message-ID: <8736oy8kvn.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

>> This change's purpose is to disallow user to trigger fw crash if the fw is not in a
>> Normal state.
>>
>> If the fw is in recovering state triggered by user's command or by fw, then it will
>> disallow user to run command to trigger fw crash again until fw become to a normal
>> State.
>
> I agree with Michal here and his proposal about having a crash counter
> sounds like a good to me. So I'm dropping this patch.

Bah, missed a word again. I meant "sounds like a good idea to me".

-- 
Kalle Valo
