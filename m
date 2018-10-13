Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C0DC28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 20:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51F7720693
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 20:28:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51F7720693
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725734AbeJNEGz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Oct 2018 00:06:55 -0400
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:33403 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725731AbeJNEGz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Oct 2018 00:06:55 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 75E5F182CF665;
        Sat, 13 Oct 2018 20:28:27 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: owl59_49a4b1548401b
X-Filterd-Recvd-Size: 3409
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Sat, 13 Oct 2018 20:28:25 +0000 (UTC)
Message-ID: <0a41d14b9a964b6b7825bf5c55c32f35166354cd.camel@perches.com>
Subject: Re: [RFC v4 08/13] rtw88: debug files
From:   Joe Perches <joe@perches.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com, sgruszka@redhat.com,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Date:   Sat, 13 Oct 2018 13:28:24 -0700
In-Reply-To: <87y3b1vpjk.fsf@codeaurora.org>
References: <1539421245-11847-1-git-send-email-yhchuang@realtek.com>
         <1539421245-11847-9-git-send-email-yhchuang@realtek.com>
         <a731948bf875867be4246b72a661ce71833620b8.camel@perches.com>
         <87y3b1vpjk.fsf@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2018-10-13 at 18:23 +0300, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > On Sat, 2018-10-13 at 17:00 +0800, yhchuang@realtek.com wrote:
> > > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > []
> > > diff --git a/drivers/net/wireless/realtek/rtw88/debug.c
> > > b/drivers/net/wireless/realtek/rtw88/debug.c
> > []
> > > +#ifdef CONFIG_RTW88_DEBUG
> > > +
> > > +void __rtw_dbg(struct rtw_dev *rtwdev, const char *fmt, ...)
> > > +{
> > > +	struct va_format vaf = {
> > > +		.fmt = fmt,
> > > +	};
> > > +	va_list args;
> > > +
> > > +	va_start(args, fmt);
> > > +	vaf.va = &args;
> > > +
> > > +	if (net_ratelimit())
> > > +		dev_dbg(rtwdev->dev, "%pV", &vaf);
> > > +
> > > +	va_end(args);
> > > +}
> > > +EXPORT_SYMBOL(__rtw_dbg);
> > > +
> > > +#define __rtw_fn(fn)							\
> > > +void __rtw_ ##fn(struct rtw_dev *rtwdev, const char *fmt, ...)		\
> > > +{									\
> > > +	struct va_format vaf = {					\
> > > +		.fmt = fmt,						\
> > > +	};								\
> > > +	va_list args;							\
> > > +									\
> > > +	va_start(args, fmt);						\
> > > +	vaf.va = &args;							\
> > > +	dev_ ##fn(rtwdev->dev, "%pV", &vaf);				\
> > > +	va_end(args);							\
> > > +}									\
> > > +EXPORT_SYMBOL(__rtw_ ##fn);
> > > +
> > > +__rtw_fn(info)
> > > +__rtw_fn(warn)
> > > +__rtw_fn(err)
> > 
> > It's very unusual to have _all_ the logging under a CONFIG_<FOO>_DEBUG
> > config guard flag.
> 
> For wireless drivers that is actually quite typical.

No, it isn't.

> IIRC at least ath6kl, ath9k and ath10k do that, most likely also others.

No, they don't.  Check again.

> > Typical debugging would dynamic debugging on a per-line instance andl
> > this uses a single dev_dbg for all debugging.
> 
> I don't recall seeing anyone using per-line dynamic debugging with
> wireless drivers. The drivers are so complex that enabling one message
> at a time doesn't really get you anywhere, that's why we mostly group
> messages into similar groups (or levels) to make it easier to enable
> certain debug messages.

You should look harder.  

> > This seems unnecessarily complexity for a negative gain.
> 
> I haven't reviewed the driver yet but from a quick look I don't see this
> as a problem.
  
It is unnecessarily complex.
This saves one dereference per call, but is it really worth it?


