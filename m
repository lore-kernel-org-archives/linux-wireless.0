Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C50C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AC482075C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:22:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AC482075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbeJHPc5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:32:57 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:52983 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbeJHPc5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:32:57 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w988M9Vw007449, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w988M9Vw007449
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Mon, 8 Oct 2018 16:22:09 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Mon, 8 Oct
 2018 16:22:09 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v2 02/12] rtw88: core files
Thread-Topic: [RFC v2 02/12] rtw88: core files
Thread-Index: AQHUW9dbza64vTLVQky7/BJW330RlqUUmnzw
Date:   Mon, 8 Oct 2018 08:22:08 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D172BD3B@RTITMBSVM01.realtek.com.tw>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-3-git-send-email-yhchuang@realtek.com>
 <20181004114235.GB16819@redhat.com>
In-Reply-To: <20181004114235.GB16819@redhat.com>
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
> Sent: Thursday, October 04, 2018 7:43 PM
> To: Tony Chuang
> Cc: kvalo@codeaurora.org; Larry.Finger@lwfinger.net; Pkshih; Andy Huang;
> linux-wireless@vger.kernel.org
> Subject: Re: [RFC v2 02/12] rtw88: core files
> 
> On Wed, Oct 03, 2018 at 04:02:18PM +0800, yhchuang@realtek.com wrote:
> > +static struct country_code_to_enum_rd all_countries[] = {
> > +	{COUNTRY_CODE_FCC, "US"},
> > +	{COUNTRY_CODE_IC, "US"},
> > +	{COUNTRY_CODE_ETSI, "EC"},
> > +	{COUNTRY_CODE_SPAIN, "EC"},
> > +	{COUNTRY_CODE_FRANCE, "EC"},
> > +	{COUNTRY_CODE_MKK, "JP"},
> > +	{COUNTRY_CODE_MKK1, "JP"},
> > +	{COUNTRY_CODE_ISRAEL, "EC"},
> > +	{COUNTRY_CODE_TELEC, "JP"},
> > +	{COUNTRY_CODE_MIC, "JP"},
> > +	{COUNTRY_CODE_GLOBAL_DOMAIN, "JP"},
> > +	{COUNTRY_CODE_WORLD_WIDE_13, "EC"},
> > +	{COUNTRY_CODE_TELEC_NETGEAR, "EC"},
> > +	{COUNTRY_CODE_WORLD_WIDE_13_5G_ALL, "US"},
> > +};
> > +
> > +/* Only these channels allow active
> > + * scan on all world regulatory domains
> > + */
> > +#define RTW_2GHZ_CH01_11	\
> > +	REG_RULE(2412 - 10, 2462 + 10, 40, 0, 20, 0)
> <snip>
> > +static const
> > +struct ieee80211_regdomain *rtw_regdomain_select(struct rtw_regulatory
> *reg)
> > +{
> > +	switch (reg->country_code) {
> > +	case COUNTRY_CODE_FCC:
> > +		return &rtw_regdom_no_midband;
> > +	case COUNTRY_CODE_IC:
> > +		return &rtw_regdom_11;
> > +	case COUNTRY_CODE_TELEC_NETGEAR:
> > +		return &rtw_regdom_60_64;
> > +	case COUNTRY_CODE_ETSI:
> > +	case COUNTRY_CODE_SPAIN:
> > +	case COUNTRY_CODE_FRANCE:
> > +	case COUNTRY_CODE_ISRAEL:
> > +		return &rtw_regdom_12_13;
> > +	case COUNTRY_CODE_MKK:
> > +	case COUNTRY_CODE_MKK1:
> > +	case COUNTRY_CODE_TELEC:
> > +	case COUNTRY_CODE_MIC:
> > +		return &rtw_regdom_14_60_64;
> > +	case COUNTRY_CODE_GLOBAL_DOMAIN:
> > +		return &rtw_regdom_14;
> > +	case COUNTRY_CODE_WORLD_WIDE_13:
> > +	case COUNTRY_CODE_WORLD_WIDE_13_5G_ALL:
> > +		return &rtw_regdom_12_13_5g_all;
> > +	default:
> > +		return &rtw_regdom_no_midband;
> > +	}
> 
> I'm not an expert on this, but I wonder if this is really needed
> and standard linux regd stuff can not be used and regulatory
> rules read from wireless-regd data-base.
> 

I think this should be removed. Will remove them.

> Thanks
> Stanislaw
> 


Yan-Hsuan Chuang
