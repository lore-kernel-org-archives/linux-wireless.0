Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99444C282C2
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 02:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC402083B
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 02:30:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfBKCaF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 21:30:05 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:41073 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfBKCaE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 21:30:04 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1B2Tich011877, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1B2Tich011877
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 11 Feb 2019 10:29:44 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Mon, 11 Feb 2019 10:29:44 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 24/24] rtw88: 8822b: turn rtw_write32s_mask into macro
Thread-Topic: [PATCH 24/24] rtw88: 8822b: turn rtw_write32s_mask into macro
Thread-Index: AQHUuV+dvM3bezbrhEu5gAS5rqj4sqXJoPsAgBBO8aA=
Date:   Mon, 11 Feb 2019 02:29:43 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17A2837@RTITMBSVM04.realtek.com.tw>
References: <1548937297-14660-1-git-send-email-yhchuang@realtek.com>
 <1548937297-14660-25-git-send-email-yhchuang@realtek.com>
 <20190201012446.GA103846@google.com>
In-Reply-To: <20190201012446.GA103846@google.com>
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
> 
> Hi,
> 
> >
> > +static inline void
> > +_rtw_write32s_mask(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32
> data)
> > +{
> > +	rtw_write32_mask(rtwdev, addr, mask, data);
> > +	rtw_write32_mask(rtwdev, addr + 0x200, mask, data);
> > +}
> > +
> > +/* 0xC00-0xCFF and 0xE00-0xEFF have the same layout */
> 
> Feels like this belongs with _rtw_write32s_mask() now, not here?

Yeah.

> 
> > +#define rtw_write32s_mask(rtwdev, addr, mask, data)			       \
> > +	do {								       \
> > +		BUILD_BUG_ON(addr < 0xC00 || addr >= 0xD00);		       \
> 
> You probably want parentheses around the 'addr'. You *probably* won't
> run into trouble with this particular macro, but if the caller is doing
> the wrong kinds of comparisons or arithmetic, this might not work they
> way you want.

Should add parentheses to protect in case of some coding mistakes.
Thanks

> 
> Brian
> 
> > +									       \
> > +		_rtw_write32s_mask(rtwdev, addr, mask, data);		       \
> > +	} while (0)
> > +
> >  /* phy status page0 */
> >  #define GET_PHY_STAT_P0_PWDB(phy_stat)
> \
> >  	le32_get_bits(*((__le32 *)(phy_stat) + 0x00), GENMASK(15, 8))
> > --

Yan-Hsuan
