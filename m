Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E65FC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03EC92087F
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:26:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfA1J0A convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:26:00 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:36848 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfA1JZ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 04:25:59 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0S9PXHA021024, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0S9PXHA021024
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 28 Jan 2019 17:25:33 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCAS12.realtek.com.tw (172.21.6.16) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 28 Jan 2019 17:25:33 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0435.000; Mon, 28 Jan
 2019 17:25:32 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHUtsz0oGWsIdSZ5km8koIDZ4UJzKXEW5SlgAAMGcA=
Date:   Mon, 28 Jan 2019 09:25:32 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D1793BB2@RTITMBSVM04.realtek.com.tw>
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
 <87tvht18mn.fsf@codeaurora.org>
In-Reply-To: <87tvht18mn.fsf@codeaurora.org>
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
> Sent: Monday, January 28, 2019 4:37 PM
> To: Tony Chuang
> Cc: johannes@sipsolutions.net; Larry.Finger@lwfinger.net; Pkshih; Andy Huang;
> briannorris@chromium.org; sgruszka@redhat.com;
> linux-wireless@vger.kernel.org
> Subject: Re: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
> wireless network chips
> 
> <yhchuang@realtek.com> writes:
> 
> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >
> > This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> > rtw88 supports 8822BE and 8822CE chips, and will be able to support
> > multi-vif combinations in run-time.
> >
> > For now, only PCI bus is supported, but rtw88 was originally designed
> > to optionally support three buses includes USB & SDIO. USB & SDIO modules
> > will soon be supported by rtw88, with configurable core module to fit
> > with different bus modules in the same time.
> >
> > For example, if we choose 8822BE and 8822CU, only PCI & USB modules will
> > be selected, built, loaded into kernel. This is one of the major
> > difference from rtlwifi, which can only support specific combinations.
> >
> > Another difference from rtlwifi is that rtw88 is designed to support
> > the latest Realtek 802.11ac wireless network chips like 8822B and
> > 8822C series. Compared to the earlier chips supported by rtlwifi like
> > the 802.11n 8192EE chipset or 802.11ac 8821AE/8812AE chips, newer ICs
> > have different MAC & PHY settings, such as new multi-port feature for the
> > MAC layer design and Jaguar2/Jaguar3 PHY layer IPs.
> >
> > Multi-Port feature is also supported under rtw88's software architecture.
> > rtlwifi can only support one vif in the same time, most because of the
> > hardware limitations for early chips, hence the original design of it
> > also restricts the usage of multi-vif support, so latest chipset seems not
> > take advantages from its new MAC engine.
> >
> > However, rtw88 can run multiple vifs concurrently by holding them on
> > hardware ports provided by MAC engine, hence can easily start different
> > roles on a single device.
> >
> > Based on the reasons mentioned before, we implemented rtw88. It had many
> > authors, they are listed here alphabetically:
> >
> > Ping-Ke Shih <pkshih@realtek.com>
> > Tzu-En Huang <tehuang@realtek.com>
> > Yan-Hsuan Chuang <yhchuang@realtek.com>
> >
> >
> > v2
> >
> >  - add comment for watch dog
> >
> >
> > v3
> >
> >  - change tree location to wireless-next
> 
> What does this mean? wireless-next has not been used for years, do you
> mean wireless-drivers-next instead?
> 
> --
> Kalle Valo

Sorry for the typo here. Yes, I mean " wireless-drivers-next ".
In MAINTAINERS file, I do change to "wireless-drivers-next" instead of "wireless-next".

Yan-Hsuan


