Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5E2C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E3B20693
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jaWmglcM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jaWmglcM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90E3B20693
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbeJNBZ7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 21:25:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58464 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbeJNBZ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 21:25:59 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C575960C60; Sat, 13 Oct 2018 17:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539452875;
        bh=gumKGbA5moUlYaJqUD05/O7+Mn4vG1AWhKChreuyQaw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jaWmglcMcjML9twoQWYgrMX1mrVMVfld7oclnAtL4rwmkkdx6OPBi1167iw+bzSwG
         GxPvVJIOL6wSblQYX4J2Y/67ui+vvD65pFcMJdVA4Ke4Z5prpb93WncRoFaYGnpdYd
         Em5xageOIS4dpnZXlXjmE4MMS3QnWDc8vZn0+2hM=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1F45F60209;
        Sat, 13 Oct 2018 17:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539452875;
        bh=gumKGbA5moUlYaJqUD05/O7+Mn4vG1AWhKChreuyQaw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jaWmglcMcjML9twoQWYgrMX1mrVMVfld7oclnAtL4rwmkkdx6OPBi1167iw+bzSwG
         GxPvVJIOL6wSblQYX4J2Y/67ui+vvD65pFcMJdVA4Ke4Z5prpb93WncRoFaYGnpdYd
         Em5xageOIS4dpnZXlXjmE4MMS3QnWDc8vZn0+2hM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1F45F60209
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
Date:   Sat, 13 Oct 2018 20:47:45 +0300
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D172DCB6@RTITMBSVM01.realtek.com.tw>
        (Tony Chuang's message of "Thu, 11 Oct 2018 07:23:25 +0000")
Message-ID: <87lg7120xq.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> > +static void rtw_watch_dog_work(struct work_struct *work)
>> > +{
>> > +	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
>> > +					      watch_dog_work.work);
>> > +	struct rtw_vif *rtwvif;
>> > +
>> > +	if (!rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
>> > +		return;
>> > +
>> > +	ieee80211_queue_delayed_work(rtwdev->hw,
>> &rtwdev->watch_dog_work,
>> > +				     RTW_WATCH_DOG_DELAY_TIME);
>> 
>> You're aware of the power cost of waking up every 2 seconds? That's a
>> really bad idea, in general, at the very least you should use a more
>> power efficient scheduling here to combine with other wakeups
>> (round_jiffies_relative, or so).
>
> Yeah I knew it, but so far we can only work like this...
> Will use round_jiffies_relative to combine the CPU wakeups.

Can you elaborate more why this horrible timer is needed? And it
definitely needs a comment in the code explaining the reason.

-- 
Kalle Valo
