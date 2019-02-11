Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FF4C282C2
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 02:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE2082083B
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 02:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfBKCbQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 21:31:16 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:41157 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfBKCbP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 21:31:15 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1B2UwcZ012107, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1B2UwcZ012107
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 11 Feb 2019 10:30:59 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCAS12.realtek.com.tw (172.21.6.16) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 11 Feb 2019 10:30:59 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0435.000; Mon, 11 Feb
 2019 10:30:58 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 00/24] rtw88: major fixes for 8822c to have stable functionalities
Thread-Topic: [PATCH 00/24] rtw88: major fixes for 8822c to have stable
 functionalities
Thread-Index: AQHUuV+TtXNINyxKz06KyTixZeqEA6XJtjKAgBA6eWA=
Date:   Mon, 11 Feb 2019 02:30:57 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17A2858@RTITMBSVM04.realtek.com.tw>
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
 <20190201024042.GB125494@google.com>
In-Reply-To: <20190201024042.GB125494@google.com>
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


> From: Brian Norris [mailto:briannorris@chromium.org]
> Subject: Re: [PATCH 00/24] rtw88: major fixes for 8822c to have stable
> functionalities
> 
> On Thu, Jan 31, 2019 at 08:21:13PM +0800, yhchuang@realtek.com wrote:
> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >
> > Note this patch set is based on the original patch set "rtw88: mac80211
> > driver for Realtek 802.11ac wireless network chips".
> 
> The latest would be here, for reference:
> 
> https://patchwork.kernel.org/cover/10787651/
> http://lkml.kernel.org/linux-wireless/1548820940-15237-1-git-send-email-yhch
> uang@realtek.com
> 
> > These patches are mean to make sure 8822c chip to operate normal for most
> > of the basic functionalities, such as power on, switch channel, scan,
> > connection establish and connection monitor.
> >
> > As the original patch set was sent 3 months ago, progress has been made
> > by Realtek during the past months. Now we have tested on more chips and
> > released tables and parameters for them. Also the chips are all
> > programed with efuse map released for 8822c.
> >
> > Most of the changes are about BB and RF, both control the tx/rx path.
> > PHY parameters/seq and efuse info make sure the hardware is powered on
> > correctly. And channel setting updates help driver to switch to target
> > channel accurately. Then trx mode setting and DACK will make hardware to
> > have stable performance to tx/rx to connect to AP.
> >
> > Here tx power control is also required to transmit with a precise power.
> > Otherwise if the power is too high or too low, the peer might not be able
> > to receive the signal.
> >
> > Finally, we need to report correct tx status for mac80211's connection
> > monitor system, this requires firmware's C2H of tx status report. After
> > this, users can use 8822c chips for more stable wireless communication.
> 
> Besides the comments I added (and needing to fix the out-of-bounds
> reads), this series helpfully adds RFE 1 support, so the 8822C chip I
> have works for some basic functions -- it's not too snappy, and I feel
> like there's still plenty of room for improvement but:
> 
> Tested-by: Brian Norris <briannorris@chromium.org>
> 
> And except for a handful of patches (should look at patch 1 closer),
> these all look pretty sane and helpful.
> 
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> 
> I still need to pass back over the original patchset and try a few more
> things out.
> 
> Regards,
> Brian

Thanks for your review, helps a lot!

Yan-Hsuan
