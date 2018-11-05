Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE29C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 07:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5900720827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 07:12:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5900720827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbeKEQaS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 11:30:18 -0500
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:38259 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729121AbeKEQaL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 11:30:11 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 20635100E86C6;
        Mon,  5 Nov 2018 07:11:57 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: grip25_853fb71382905
X-Filterd-Recvd-Size: 3121
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Mon,  5 Nov 2018 07:11:55 +0000 (UTC)
Message-ID: <de73f12cdfbd52995c44b74df0d94142493de4e9.camel@perches.com>
Subject: Re: [RFC v5 08/13] rtw88: debug files
From:   Joe Perches <joe@perches.com>
To:     Tony Chuang <yhchuang@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>
Cc:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Date:   Sun, 04 Nov 2018 23:11:54 -0800
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D173E96A@RTITMBSVM01.realtek.com.tw>
References: <1540980747-9297-1-git-send-email-yhchuang@realtek.com>
         <1540980747-9297-9-git-send-email-yhchuang@realtek.com>
         <d6f81b74ede58f9a7cd3ce01cd8366d5df50d1de.camel@perches.com>
         <F7CD281DE3E379468C6D07993EA72F84D173E96A@RTITMBSVM01.realtek.com.tw>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-11-05 at 06:13 +0000, Tony Chuang wrote:
> > -----Original Message-----
> > From: Joe Perches [mailto:joe@perches.com]
> > Sent: Sunday, November 04, 2018 12:29 PM
> > To: Tony Chuang; kvalo@codeaurora.org; sgruszka@redhat.com
> > Cc: Larry.Finger@lwfinger.net; linux-wireless@vger.kernel.org; Pkshih; Andy
> > Huang; johannes@sipsolutions.net
> > Subject: Re: [RFC v5 08/13] rtw88: debug files
> > 
> > On Wed, 2018-10-31 at 18:12 +0800, yhchuang@realtek.com wrote
> > > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > > debug files for Realtek 802.11ac wireless network chips
> > []
> > > diff --git a/drivers/net/wireless/realtek/rtw88/debug.h
> > b/drivers/net/wireless/realtek/rtw88/debug.h
> > []
> > > +#ifdef CONFIG_RTW88_DEBUG
> > []
> > > +#else
> > > +
> > > +static inline void rtw_dbg(struct rtw_dev *rtwdev, const char *fmt, ...) {}
> > > +static inline void rtw_info(struct rtw_dev *rtwdev, const char *fmt, ...) {}
> > > +static inline void rtw_warn(struct rtw_dev *rtwdev, const char *fmt, ...) {}
> > > +static inline void rtw_err(struct rtw_dev *rtwdev, const char *fmt, ...) {}
> > 
> > I still think it's _very, very bad_, and extremely
> > unusual to turn off _all_ logging, even for error
> > conditions, based on a debug config flag.
> > 
[]
> So I think we should move rtw_[err/warn/info] out of the flag.
> Should we need to send it in RFC v6 or in the next patch series?

Up to you.

I think you should look at all the rtw_err/rtw_warn/rtw_info uses
as many seem to be more like they should use rtw_dbg instead.

Also, I think the rtw_err/rtw_warn/rtw_info function calls aren't
particularly useful and these should be simple macros or static
inlines and not use %pV at all.

#define rtw_err(rtw_dev, fmt, ...)	\
	dev_err((rtw_dev)->dev, fmt, ##__VA_ARGS__)

etc


