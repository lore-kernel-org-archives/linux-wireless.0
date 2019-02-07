Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F71C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B167221872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:43:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QQ+U4Tio";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QQ+U4Tio"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfBGOnC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:43:02 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfBGOnC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:43:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C37F360131; Thu,  7 Feb 2019 14:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549550581;
        bh=oG58Urn4p8k1q/NfB+XMR4HbjdcL59t1A7/Pp5RSNWw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QQ+U4Tioh4gitQSX0veJusGyWJUSfx6M0wcXJAHUkT9Ie/ezypQdyiJjWgCGW39M8
         T63jiFQVEjWkf013WtLj9PepN79klaDmux78gUBCMhRc/laB7jG+tArXsKkYEr0UQd
         bc5J+yR4wmPFhrVyyMNbYjkq3dTwv8ZPLozuhhOA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2EA2B602CC;
        Thu,  7 Feb 2019 14:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549550581;
        bh=oG58Urn4p8k1q/NfB+XMR4HbjdcL59t1A7/Pp5RSNWw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QQ+U4Tioh4gitQSX0veJusGyWJUSfx6M0wcXJAHUkT9Ie/ezypQdyiJjWgCGW39M8
         T63jiFQVEjWkf013WtLj9PepN79klaDmux78gUBCMhRc/laB7jG+tArXsKkYEr0UQd
         bc5J+yR4wmPFhrVyyMNbYjkq3dTwv8ZPLozuhhOA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2EA2B602CC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Peter Oh <peter.oh@bowerswilkins.com>
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        Zhi Chen <zhichen@codeaurora.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix incorrect multicast/broadcast rate setting
References: <1544504171-19810-1-git-send-email-pradeepc@codeaurora.org>
        <6a59f346-5c9b-190c-feef-39393d17933b@bowerswilkins.com>
Date:   Thu, 07 Feb 2019 16:42:57 +0200
In-Reply-To: <6a59f346-5c9b-190c-feef-39393d17933b@bowerswilkins.com> (Peter
        Oh's message of "Tue, 11 Dec 2018 19:22:38 +0000")
Message-ID: <87lg2r8xse.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Peter Oh <peter.oh@bowerswilkins.com> writes:

> On 12/10/2018 08:56 PM, Pradeep Kumar Chitrapu wrote:
>> From: Pradeep kumar Chitrapu <pradeepc@codeaurora.org>
>>
>> Invalid rate code is sent to firmware when multicast rate value of 0 is
>> sent to driver indicating disabled case, causing broken mesh path.
>> so fix that.
>>
>> Tested on QCA9984 with firmware 10.4-3.6.1-00827
>>
> Test data is too small. You need to provide at least QCA9880 and QCA4019 
> data together which share ath10k for mesh.

Pradeep, did you test those? Or someone else?

But isn't the firmware almost the same on those hardware anyway?

-- 
Kalle Valo
