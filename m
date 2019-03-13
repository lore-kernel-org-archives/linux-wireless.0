Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E92C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 07:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC67E2171F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 07:10:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NMm4XTvS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O8jlujMR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfCMHKP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 03:10:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58632 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbfCMHKP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 03:10:15 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9ABC1608CE; Wed, 13 Mar 2019 07:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552461014;
        bh=A46rVnsLdGMb2I2DUXWiqpEwGHy0MlO8Gf3jR+n3PNA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NMm4XTvSk8VbprRNyB0O3kreHRcwJgdqvX8hgDP13H8D1NL4jldestEHDWxBBnIZi
         s1MEg7p+FDLGpS101Q/lkqRK20IZczuavfw7Zivu7dTD3/pv2mpj1vlodbwNTxVt8Q
         ox1bgDnRViVYm/0CnTCBFHhfuhFrK3o1BYze8rcA=
Received: from x230.qca.qualcomm.com (85-76-44-132-nat.elisa-mobile.fi [85.76.44.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8453560208;
        Wed, 13 Mar 2019 07:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552461013;
        bh=A46rVnsLdGMb2I2DUXWiqpEwGHy0MlO8Gf3jR+n3PNA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=O8jlujMR+tZPEHw1YagW/9319k8cC4WCGAUiA/FxnCi2uSL2R+7012O8vKoOrTby+
         MtNa1uZhXbUzZfqWZG6aGAiCroeeXXiRxf6XVbi4WPz73cFM2dGuNlXd8Z87kWSa55
         jAzXGo7vwLJkHtwlNVLR1dKRFgWmXMBFkUupDb50=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8453560208
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "johannes\@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sgruszka\@redhat.com" <sgruszka@redhat.com>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris\@chromium.org" <briannorris@chromium.org>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
        <87wol31d8k.fsf@codeaurora.org>
        <F7CD281DE3E379468C6D07993EA72F84D17BF35B@RTITMBSVM04.realtek.com.tw>
Date:   Wed, 13 Mar 2019 09:10:09 +0200
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17BF35B@RTITMBSVM04.realtek.com.tw>
        (Tony Chuang's message of "Wed, 13 Mar 2019 07:06:24 +0000")
Message-ID: <877ed31c8e.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> > v8
>> >
>> >  - add prefix "rtw_" to *_rates and corresponding *_sizes, otherwise
>> >    the extern will confuse the linker there are multiple definitions
>> >    with brcmsmac driver
>> 
>> I tried to explain this already last time, but maybe I wasn't clear
>> enough so I'll try again: PLEASE do not submit any new versions of rtw88
>> until I explicitly ask you to send v9. If you post new versions too
>> frequently it makes the review harder. Reviewing full driver is very
>> different from reviewing normal patches, the patches are larger and it
>> takes more time to review.
>
> Sorry about that. I thought " please fix that in the next version " was asking
> me to send the next version. Now I get it, will include these fixes in my tree,
> and send v9 until you ask to.

Great, thank you.

-- 
Kalle Valo
