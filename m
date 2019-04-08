Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C8BC10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 11:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 157B520663
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 11:33:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lCSBGmZd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="h8cU1D4I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfDHLdO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 07:33:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59066 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfDHLdN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 07:33:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D2C076086B; Mon,  8 Apr 2019 11:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554723192;
        bh=MA9NkMtdwK0mnFctPvNzrDj4wSNs1F2eFxBh/MOyQS0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lCSBGmZddpBKxFYpfWkg4GtRZ77XCIXyTZ+O8DnvT0QDipWP2W6rEn/KH61ub7UhH
         lqEZ18EJ3Vikvg0H1JRN6r2meaK8CbKqE2/8VnUa+c3tbU29WXzq6L0ePAgyLwcyZs
         jEJWSAS9PIM40KrPrrxj6H1F89qWXHM41TD2Qq3o=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C629E6086B;
        Mon,  8 Apr 2019 11:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554723191;
        bh=MA9NkMtdwK0mnFctPvNzrDj4wSNs1F2eFxBh/MOyQS0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=h8cU1D4I1Wz9/c8dl2lwBGO0tlf8ogD6MrhJKWzP4mt5+FCzSuDgIpMlAuzKvbFXV
         +UV/o2BTS6tKAyjutZeIs5FEWr82A2C8V1RCCh2xJGxLLMx+R5lerV1A++e9Xrd2hO
         JuYcZ3yyHGIHxzyyS42Jqhii6YkINZbo6CcSuY4I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C629E6086B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
References: <1552450443-351-1-git-send-email-yhchuang@realtek.com>
        <20190325143611.sjwwjqtrftxntwyk@penguin>
        <20190326075414.GA8598@redhat.com>
        <CA+ASDXNcCNcBmiHi468p1foWgSOXy9Mt8o+CD17Bd4PqhUXFoA@mail.gmail.com>
        <F7CD281DE3E379468C6D07993EA72F84D17CB940@RTITMBSVM04.realtek.com.tw>
        <20190327102623.GA20943@redhat.com>
        <F7CD281DE3E379468C6D07993EA72F84D17D50A4@RTITMBSVM04.realtek.com.tw>
Date:   Mon, 08 Apr 2019 14:33:06 +0300
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17D50A4@RTITMBSVM04.realtek.com.tw>
        (Tony Chuang's message of "Mon, 8 Apr 2019 02:14:49 +0000")
Message-ID: <87zhp0g2a5.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

> Hi Kalle
>
>> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
>> Sent: Wednesday, March 27, 2019 6:26 PM
>> To: Tony Chuang
>> Cc: Brian Norris; Kalle Valo; Johannes Berg; linux-wireless; Greg Kroah-Hartman;
>> Pkshih; Andy Huang; Larry Finger
>> Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
>> wireless network chips
>> 
>
> It's just a gentle reply to ask if rtw88 is getting merged.
> Are you still reviewing or is there anything I can help.

I just have been busy with other stuff, sorry. I'll try find time for
this soon.

-- 
Kalle Valo
