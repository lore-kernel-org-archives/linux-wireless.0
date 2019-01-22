Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B87C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 868D8217D4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DTudGlb2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lAl/vyo/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbfAVPs5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:48:57 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58194 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728664AbfAVPs5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:48:57 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B441B60712; Tue, 22 Jan 2019 15:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548172136;
        bh=c3bqGCblV9YH62iQvi4K1pj3MExdGL1OvCIKkQ896Tk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DTudGlb2NQDVL7zVHuUnUoQ2f7qn/83KBhZl09V8SL19zhPRq2GZufgrVLLlGroAd
         xFL235DGQE7cOgjqRAHwv8xzB0azTTTadeCW5ckAk5rKnV8L4mNZFEHOlKUGG817P0
         HvQZqJxm4TPKjySurlS+XHjSDdkiX4TuoguxenKQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0F286601B4;
        Tue, 22 Jan 2019 15:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548172135;
        bh=c3bqGCblV9YH62iQvi4K1pj3MExdGL1OvCIKkQ896Tk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lAl/vyo/NXM3q8BE3dFZLatijjUCQzVyYBzExLtEJudNjoNfzpJaM+BPIF0WO1DlK
         PM4ALgDtMwWyTJufAm4UrKd0VKATJZbhkXKYWlsGQPGxxCpmDUnNsGxMuiAqatawEa
         lRib/F4v7vVUJJYrItqxYKZZjbvcsEwY9NGmDt+s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0F286601B4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] realtek: no need to check return value of debugfs_create functions
References: <20190122152151.16139-34-gregkh@linuxfoundation.org>
        <c09a1fb9-45e4-c21e-3c19-09ba94ebd859@lwfinger.net>
Date:   Tue, 22 Jan 2019 17:48:51 +0200
In-Reply-To: <c09a1fb9-45e4-c21e-3c19-09ba94ebd859@lwfinger.net> (Larry
        Finger's message of "Tue, 22 Jan 2019 09:44:37 -0600")
Message-ID: <87r2d4n15o.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 1/22/19 9:21 AM, Greg Kroah-Hartman wrote:
>> When calling debugfs functions, there is no need to ever check the
>> return value.  The function can work or not, but the code logic should
>> never do something different based on this.
>>
>> Cc: Ping-Ke Shih <pkshih@realtek.com>
>> Cc: Kalle Valo <kvalo@codeaurora.org>
>> Cc: linux-wireless@vger.kernel.org
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Greg,
>
> Please change the subject to read "rtlwifi: ...". Otherwise the patch is correct.

I can fix that during commit.

-- 
Kalle Valo
