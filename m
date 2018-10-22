Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252FCC67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 03:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2EB12083A
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 03:40:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2EB12083A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbeJVL5f convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 07:57:35 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:49301 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbeJVL5f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 07:57:35 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w9M3eS7G008446, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w9M3eS7G008446
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 22 Oct 2018 11:40:28 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCAS12.realtek.com.tw (172.21.6.16) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 22 Oct 2018 11:40:28 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Mon, 22 Oct
 2018 11:40:27 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     Johannes Berg <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v3 01/12] rtw88: main files
Thread-Topic: [RFC v3 01/12] rtw88: main files
Thread-Index: AQHUYxzYH/Zu3N4AK0aJXCSsksiUEqUqq1yg
Date:   Mon, 22 Oct 2018 03:40:27 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D1734F60@RTITMBSVM01.realtek.com.tw>
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
        <1538565659-29530-2-git-send-email-yhchuang@realtek.com>
        <201810081447.w98ElQfu018110@rtits1.realtek.com.tw>
        <F7CD281DE3E379468C6D07993EA72F84D172DCB6@RTITMBSVM01.realtek.com.tw>
 <87lg7120xq.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87lg7120xq.fsf@kamboji.qca.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Sunday, October 14, 2018 1:48 AM
> To: Tony Chuang
> Cc: Johannes Berg; Larry.Finger@lwfinger.net; Pkshih; Andy Huang;
> sgruszka@redhat.com; linux-wireless@vger.kernel.org
> Subject: Re: [RFC v3 01/12] rtw88: main files
> 
> Tony Chuang <yhchuang@realtek.com> writes:
> 
> >> > +static void rtw_watch_dog_work(struct work_struct *work)
> >> > +{
> >> > +	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
> >> > +					      watch_dog_work.work);
> >> > +	struct rtw_vif *rtwvif;
> >> > +
> >> > +	if (!rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
> >> > +		return;
> >> > +
> >> > +	ieee80211_queue_delayed_work(rtwdev->hw,
> >> &rtwdev->watch_dog_work,
> >> > +				     RTW_WATCH_DOG_DELAY_TIME);
> >>
> >> You're aware of the power cost of waking up every 2 seconds? That's a
> >> really bad idea, in general, at the very least you should use a more
> >> power efficient scheduling here to combine with other wakeups
> >> (round_jiffies_relative, or so).
> >
> > Yeah I knew it, but so far we can only work like this...
> > Will use round_jiffies_relative to combine the CPU wakeups.
> 
> Can you elaborate more why this horrible timer is needed? And it
> definitely needs a comment in the code explaining the reason.
> 


The watchdog timer is required for our devices to enhance the performance.
It does a lot of tx/rx statistics processing for the hardware.
Those information process routines help the devices to adapt to the environment.

However, status polling every two seconds is not a good solution.
But it makes drive simpler to be implemented.

We will try to change it to interrupt mode.
But it will take a lot of time to work on it.
So, before it's done, I think we can leave the timer here.


Yan-Hsuan Chuang
