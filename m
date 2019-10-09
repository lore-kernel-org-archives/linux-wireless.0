Return-Path: <SRS0=Z1rL=YC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B1FC47404
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 13:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DEBF21721
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 13:05:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DpAT1j6g";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DpAT1j6g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbfJINFU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Oct 2019 09:05:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59582 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730858AbfJINFU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Oct 2019 09:05:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7FC4860A0A; Wed,  9 Oct 2019 13:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570626319;
        bh=bjOfTcUli05MCxYRKbenEga8hmz//QUQKdpP/IaUV+c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DpAT1j6gClBIihophJBzw1a7tHsaek11AZUCDBiEboBeX8Rhv4igF4+NqLzt6j51w
         VZVn7GopBY1O3V6FvCQ39ZXhrY817REUNwdq/nGw4pk44jvm8UM5+SBiwDFFiSbvNi
         IiyAO0IakIzp9bEa3NsM28BC1K0SxiK1QDFN1pU4=
Received: from x230.qca.qualcomm.com (85-76-42-199-nat.elisa-mobile.fi [85.76.42.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9727F602E1;
        Wed,  9 Oct 2019 13:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570626319;
        bh=bjOfTcUli05MCxYRKbenEga8hmz//QUQKdpP/IaUV+c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DpAT1j6gClBIihophJBzw1a7tHsaek11AZUCDBiEboBeX8Rhv4igF4+NqLzt6j51w
         VZVn7GopBY1O3V6FvCQ39ZXhrY817REUNwdq/nGw4pk44jvm8UM5+SBiwDFFiSbvNi
         IiyAO0IakIzp9bEa3NsM28BC1K0SxiK1QDFN1pU4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9727F602E1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "zhengbin \(A\)" <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH RESEND] rtlwifi: rtl8192ee: Remove set but not used variable 'err'
References: <1570612107-13286-1-git-send-email-zhengbin13@huawei.com>
        <8736g2rs86.fsf@codeaurora.org>
        <0135c3c7-a827-941a-1bad-90129c49d0ac@huawei.com>
Date:   Wed, 09 Oct 2019 16:05:15 +0300
In-Reply-To: <0135c3c7-a827-941a-1bad-90129c49d0ac@huawei.com> (zhengbin's
        message of "Wed, 9 Oct 2019 21:01:54 +0800")
Message-ID: <87y2xuqdbo.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"zhengbin (A)" <zhengbin13@huawei.com> writes:

> On 2019/10/9 20:58, Kalle Valo wrote:
>> zhengbin <zhengbin13@huawei.com> writes:
>>
>>> Fixes gcc '-Wunused-but-set-variable' warning:
>>>
>>> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
>>> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning:
>>> variable err set but not used [-Wunused-but-set-variable]
>>>
>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
>>> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
>> There's no changelog, why did you resend? Document clearly the changes
>> so that maintainers don't need to guess what has changed:
>
> Failed to apply:
>
> fatal: corrupt patch at line 13
> error: could not build fake ancestor
> Applying: rtlwifi: rtl8192ee: Remove set but not used variable 'err'
> Patch failed at 0001 rtlwifi: rtl8192ee: Remove set but not used variable 'err'
> The copy of the patch that failed is found in: .git/rebase-apply/patch
>
> So I resend this. 

Ok, thanks. But next time include the changelog automatically and mark
the patch as v2. And read the documentation:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

-- 
Kalle Valo
