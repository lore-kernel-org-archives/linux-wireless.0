Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34769C6787E
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 02:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCED02075C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 02:28:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DCED02075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbeJHJh5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 05:37:57 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:53459 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725760AbeJHJh5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 05:37:57 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w982SHIH008320, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w982SHIH008320
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 8 Oct 2018 10:28:17 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCAS11.realtek.com.tw (172.21.6.12) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Mon, 8 Oct 2018 10:28:17 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Mon, 8 Oct 2018
 10:28:16 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v3 07/12] rtw88: phy files
Thread-Topic: [RFC v3 07/12] rtw88: phy files
Thread-Index: AQHUW+wB7nubplG6NkKgCqfORu1z4aUUnRXw
Date:   Mon, 8 Oct 2018 02:28:15 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D172B9F1@RTITMBSVM01.realtek.com.tw>
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
 <1538565659-29530-8-git-send-email-yhchuang@realtek.com>
 <20181004141015.GC20484@redhat.com>
In-Reply-To: <20181004141015.GC20484@redhat.com>
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
> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> Sent: Thursday, October 04, 2018 10:10 PM
> To: Tony Chuang
> Cc: kvalo@codeaurora.org; Larry.Finger@lwfinger.net; Pkshih; Andy Huang;
> linux-wireless@vger.kernel.org
> Subject: Re: [RFC v3 07/12] rtw88: phy files
> 
> On Wed, Oct 03, 2018 at 07:20:54PM +0800, yhchuang@realtek.com wrote:
> > +void rtw_phy_cfg_bb(struct rtw_dev *rtwdev, const struct rtw_table *tbl,
> > +		    u32 addr, u32 data)
> > +{
> > +	if (addr == 0xfe)
> > +		msleep(50);
> > +	else if (addr == 0xfd)
> > +		mdelay(5);
> > +	else if (addr == 0xfc)
> > +		mdelay(1);
> > +	else if (addr == 0xfb)
> > +		usleep_range(50, 60);
> > +	else if (addr == 0xfa)
> > +		udelay(5);
> > +	else if (addr == 0xf9)
> > +		udelay(1);
> > +	else
> > +		rtw_write32(rtwdev, addr, data);
> 
> This mix of mdelay(), msleep(), udelay() and usleep_range() looks strange.
> You should eigher use atomic versions *delay or non-atomic *sleep
> versions .

This is to make checkpatch.pl happy.

> 
> > +#define bcd_to_dec_pwr_by_rate(val, i) \
> > +	({ \
> > +		typeof(val) __val_ = val; \
> > +		typeof(i) __i_ = i; \
> > +		((s8)((((__val_ >> (__i_ * 8 + 4)) & 0xF)) * 10 + \
> > +		       ((__val_ >> (__i_ * 8)) & 0xF))); \
> > +	 })
> 
> Can use bcd2bin from include/linux/bcd.h instead ?
> 

OK

> 
> Thanks
> Stanislaw
> 

Yan-Hsuan Chuang
