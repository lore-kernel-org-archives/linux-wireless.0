Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A62FC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 06:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFC65204FD
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 06:13:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFC65204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbeKEPb7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 10:31:59 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:55369 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbeKEPb7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 10:31:59 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID wA56DKLk004871, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id wA56DKLk004871
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Mon, 5 Nov 2018 14:13:20 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Mon, 5 Nov
 2018 14:13:20 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Joe Perches <joe@perches.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: [RFC v5 08/13] rtw88: debug files
Thread-Topic: [RFC v5 08/13] rtw88: debug files
Thread-Index: AQHUc/bzHLayY0wVP0SGDq3Skhh+H6VAtEqg
Date:   Mon, 5 Nov 2018 06:13:18 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D173E96A@RTITMBSVM01.realtek.com.tw>
References: <1540980747-9297-1-git-send-email-yhchuang@realtek.com>
         <1540980747-9297-9-git-send-email-yhchuang@realtek.com>
 <d6f81b74ede58f9a7cd3ce01cd8366d5df50d1de.camel@perches.com>
In-Reply-To: <d6f81b74ede58f9a7cd3ce01cd8366d5df50d1de.camel@perches.com>
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
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Sunday, November 04, 2018 12:29 PM
> To: Tony Chuang; kvalo@codeaurora.org; sgruszka@redhat.com
> Cc: Larry.Finger@lwfinger.net; linux-wireless@vger.kernel.org; Pkshih; Andy
> Huang; johannes@sipsolutions.net
> Subject: Re: [RFC v5 08/13] rtw88: debug files
> 
> On Wed, 2018-10-31 at 18:12 +0800, yhchuang@realtek.com wrote
> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > debug files for Realtek 802.11ac wireless network chips
> []
> > diff --git a/drivers/net/wireless/realtek/rtw88/debug.h
> b/drivers/net/wireless/realtek/rtw88/debug.h
> []
> > +#ifdef CONFIG_RTW88_DEBUG
> []
> > +#else
> > +
> > +static inline void rtw_dbg(struct rtw_dev *rtwdev, const char *fmt, ...) {}
> > +static inline void rtw_info(struct rtw_dev *rtwdev, const char *fmt, ...) {}
> > +static inline void rtw_warn(struct rtw_dev *rtwdev, const char *fmt, ...) {}
> > +static inline void rtw_err(struct rtw_dev *rtwdev, const char *fmt, ...) {}
> 
> I still think it's _very, very bad_, and extremely
> unusual to turn off _all_ logging, even for error
> conditions, based on a debug config flag.
> 

So I think we should move rtw_[err/warn/info] out of the flag.
Should we need to send it in RFC v6 or in the next patch series?


YH Chuang
