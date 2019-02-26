Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6402FC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 08:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B550213A2
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 08:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfBZIV2 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 03:21:28 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:56323 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfBZIV2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 03:21:28 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1Q8KYWl021553, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1Q8KYWl021553
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 26 Feb 2019 16:20:34 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Tue, 26 Feb
 2019 16:20:34 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>
Subject: RE: [PATCH v2 00/24] rtw88: major fixes for 8822c to have stable functionalities
Thread-Topic: [PATCH v2 00/24] rtw88: major fixes for 8822c to have stable
 functionalities
Thread-Index: AQHUxEOb0yFc6s8EE0SGFcmTQG9t/6Xxzprg
Date:   Tue, 26 Feb 2019 08:20:33 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17AE4FD@RTITMBSVM04.realtek.com.tw>
References: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
In-Reply-To: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Note this patch set is based on patch set "rtw88: mac80211 driver for
> Realtek 802.11ac wireless network chips". For reference:
> https://patchwork.kernel.org/cover/10811967/
> https://lkml.kernel.org/linux-wireless/1550131671-2601-1-git-send-email-yhch
> uang@realtek.com/
> 
> These patches are mean to make sure 8822c chip to operate normal for most
> of the basic functionalities, such as power on, switch channel, scan,
> connection establish and connection monitor.
> 
> As the original patch set was sent 3 months ago, progress has been made
> by Realtek during the past months. Now we have tested on more chips and
> released tables and parameters for them. Also the chips are all
> programed with efuse map released for 8822c.
> 
> Most of the changes are about BB and RF, both control the tx/rx path.
> PHY parameters/seq and efuse info make sure the hardware is powered on
> correctly. And channel setting updates help driver to switch to target
> channel accurately. Then trx mode setting and DACK will make hardware to
> have stable performance to tx/rx to connect to AP.
> 
> Here tx power control is also required to transmit with a precise power.
> Otherwise if the power is too high or too low, the peer might not be able
> to receive the signal.
> 
> Finally, we need to report correct tx status for mac80211's connection
> monitor system, this requires firmware's C2H of tx status report. After
> this, users can use 8822c chips for more stable wireless communication.
> 
> 
> v2
> 
> This v2 is sent for that https://patchwork.kernel.org/cover/10811967/
> has many modifications and the original patch set would not apply.
> Also with a few changes in this one. Listed below
> 
>  - report ACK for tx frames not have IEEE80211_TX_CTL_REQ_TX_STATUS,
>    otherwise they will be marked as "drop"
>  - add more rf register write protection for patch "rtw88: add a delay
>    after writing a rf register"
> 

Hi Kalle,

Can I ask that when will this patch set probably be applied into your tree?
Thanks!

Yan-Hsuan
