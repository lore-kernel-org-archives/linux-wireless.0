Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54326C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2344D20835
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dVjuyoJs";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nWAEmbLc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388954AbfDRNzw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:55:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39104 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728074AbfDRNzv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 09:55:51 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EB60A60736; Thu, 18 Apr 2019 13:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555595750;
        bh=xN6ChoxE1j0m5EvhrKqqSNI/QjLCetCKnu6iJh/XmXA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dVjuyoJsXmZvmV9ScNfRWGibujuruxL4Gf4kSZrlOlFZrcDC487ebwD0bTFeYsiBi
         wCSgQDDj4X8cDE6S9TlPqBYmO+/f1UXGWX3V/KIkMclYO+gTa3gMl2KpRc7aFPmDjn
         f1YoQjoX192sDSiGFzreVxmmsDzIiLLHCb0Q/JhM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F05796019D;
        Thu, 18 Apr 2019 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555595749;
        bh=xN6ChoxE1j0m5EvhrKqqSNI/QjLCetCKnu6iJh/XmXA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nWAEmbLcFqoBZNuf4N6niC0VopmAJNxX8s10V7wbnI9ecLcTCOHpJUuCkbNxwB89X
         q1Htcx4UP3U4hmOr6tpzyA1vHqSSXuuT+vLznWrhB8vE43Biql3spM0c2iFKzY4ThB
         ip1210o78nsb8HQsHNpz1e9tpBusjRla6JUdGLbY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F05796019D
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
        <87zhp0g2a5.fsf@codeaurora.org>
        <F7CD281DE3E379468C6D07993EA72F84D17D6AD6@RTITMBSVM04.realtek.com.tw>
Date:   Thu, 18 Apr 2019 16:55:44 +0300
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17D6AD6@RTITMBSVM04.realtek.com.tw>
        (Tony Chuang's message of "Tue, 9 Apr 2019 10:12:16 +0000")
Message-ID: <87ftqf2za7.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> From: Kalle Valo [mailto:kvalo@codeaurora.org]
>> Sent: Monday, April 08, 2019 7:33 PM
>> To: Tony Chuang
>> Cc: Brian Norris; Johannes Berg; linux-wireless; Greg Kroah-Hartman; Pkshih;
>> Andy Huang; Larry Finger; Stanislaw Gruszka
>> Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
>> wireless network chips
>> 
>> Tony Chuang <yhchuang@realtek.com> writes:
>> 
>> > Hi Kalle
>> >
>> >> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
>> >> Sent: Wednesday, March 27, 2019 6:26 PM
>> >> To: Tony Chuang
>> >> Cc: Brian Norris; Kalle Valo; Johannes Berg; linux-wireless; Greg
>> Kroah-Hartman;
>> >> Pkshih; Andy Huang; Larry Finger
>> >> Subject: Re: [PATCH v8 00/14] rtw88: mac80211 driver for Realtek 802.11ac
>> >> wireless network chips
>> >>
>> >
>> > It's just a gentle reply to ask if rtw88 is getting merged.
>> > Are you still reviewing or is there anything I can help.
>> 
>> I just have been busy with other stuff, sorry. I'll try find time for
>> this soon.
>> 
>
> It's OK. If you need any help just let me know. :)

Sorry, still haven't been able to review the driver. But something what
I found strange was "default y" in Kconfig, is that really necessary?

> BTW, I want to change the license from GPL to Dual BSD/GPL.
> Would you want to change them in the initial patch set, or I send a separate
> one after it got merged?

Please submit a new version with the new license. But don't any other
changes than change the license and possibly remove the default line in
Kconfig.

-- 
Kalle Valo
