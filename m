Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2D6C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 14:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3B862145D
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 14:18:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gBRTvrsk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TP5t2tFW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3B862145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388265AbeKPA02 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 19:26:28 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57278 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729035AbeKPA02 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 19:26:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 62A8460591; Thu, 15 Nov 2018 14:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542291506;
        bh=5ll+ni5AdgpltgnbHy2wrkSfal8KI+LNzGzwW97PCCU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gBRTvrskJStLRbwaDboBPVNeUjUStxmMc+oKha2CuQnBEAn8mTyL+dpZkA2MxY4YV
         gDnw3s4NmHwtzpI2fo4hzcaAgws4/CYfpLAExgiPUYB8bwk8rufwJSzEC2JxweSNvc
         WboSqaSv/hrvHzA5Yz8ybIAzJwTlhHWXGgJFIwFM=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C42B260386;
        Thu, 15 Nov 2018 14:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542291505;
        bh=5ll+ni5AdgpltgnbHy2wrkSfal8KI+LNzGzwW97PCCU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TP5t2tFWG8K6fDxqvh2TwSDzVRXxJK7rXewpSiQRmyS1RkGQWutRvzpSf4DieMkYf
         tA4cM+RAQALbxI9AqbEF0G4WkLQp+jQBIMQ26iSzY7COYmL3tEknsEkLYUnK2rIvH2
         Ol6pzz9ACDg1DXw4YdsNJsHDX1owY2KLno5lOwgk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C42B260386
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka\@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3 01/12] rtw88: main files
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
        <1538565659-29530-2-git-send-email-yhchuang@realtek.com>
        <201810081447.w98ElQfu018110@rtits1.realtek.com.tw>
        <F7CD281DE3E379468C6D07993EA72F84D172DCB6@RTITMBSVM01.realtek.com.tw>
        <87lg7120xq.fsf@kamboji.qca.qualcomm.com>
        <F7CD281DE3E379468C6D07993EA72F84D1734F60@RTITMBSVM01.realtek.com.tw>
Date:   Thu, 15 Nov 2018 16:18:21 +0200
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1734F60@RTITMBSVM01.realtek.com.tw>
        (Tony Chuang's message of "Mon, 22 Oct 2018 03:40:27 +0000")
Message-ID: <87zhuaa0gi.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> -----Original Message-----
>> From: Kalle Valo [mailto:kvalo@codeaurora.org]
>> Sent: Sunday, October 14, 2018 1:48 AM
>> To: Tony Chuang
>> Cc: Johannes Berg; Larry.Finger@lwfinger.net; Pkshih; Andy Huang;
>> sgruszka@redhat.com; linux-wireless@vger.kernel.org
>> Subject: Re: [RFC v3 01/12] rtw88: main files
>> 
>> Tony Chuang <yhchuang@realtek.com> writes:
>> 
>> >> > +static void rtw_watch_dog_work(struct work_struct *work)
>> >> > +{
>> >> > +	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
>> >> > +					      watch_dog_work.work);
>> >> > +	struct rtw_vif *rtwvif;
>> >> > +
>> >> > +	if (!rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
>> >> > +		return;
>> >> > +
>> >> > +	ieee80211_queue_delayed_work(rtwdev->hw,
>> >> &rtwdev->watch_dog_work,
>> >> > +				     RTW_WATCH_DOG_DELAY_TIME);
>> >>
>> >> You're aware of the power cost of waking up every 2 seconds? That's a
>> >> really bad idea, in general, at the very least you should use a more
>> >> power efficient scheduling here to combine with other wakeups
>> >> (round_jiffies_relative, or so).
>> >
>> > Yeah I knew it, but so far we can only work like this...
>> > Will use round_jiffies_relative to combine the CPU wakeups.
>> 
>> Can you elaborate more why this horrible timer is needed? And it
>> definitely needs a comment in the code explaining the reason.
>> 
>
>
> The watchdog timer is required for our devices to enhance the performance.
> It does a lot of tx/rx statistics processing for the hardware.
> Those information process routines help the devices to adapt to the environment.
>
> However, status polling every two seconds is not a good solution.
> But it makes drive simpler to be implemented.
>
> We will try to change it to interrupt mode.
> But it will take a lot of time to work on it.
> So, before it's done, I think we can leave the timer here.

Yeah, interrupt mode sounds like a much better idea. But if you have to
keep two second polling at least add a proper comment to the code
explaining what you said above.

-- 
Kalle Valo
