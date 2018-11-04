Return-Path: <SRS0=r36G=NP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52E3C32789
	for <linux-wireless@archiver.kernel.org>; Sun,  4 Nov 2018 04:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40B642081D
	for <linux-wireless@archiver.kernel.org>; Sun,  4 Nov 2018 04:29:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40B642081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbeKDNmp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 4 Nov 2018 08:42:45 -0500
Received: from smtprelay0053.hostedemail.com ([216.40.44.53]:49144 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728984AbeKDNmp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Nov 2018 08:42:45 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 61221100E86C4;
        Sun,  4 Nov 2018 04:29:12 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: help26_6a4e6ea0a833a
X-Filterd-Recvd-Size: 1734
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Sun,  4 Nov 2018 04:28:50 +0000 (UTC)
Message-ID: <d6f81b74ede58f9a7cd3ce01cd8366d5df50d1de.camel@perches.com>
Subject: Re: [RFC v5 08/13] rtw88: debug files
From:   Joe Perches <joe@perches.com>
To:     yhchuang@realtek.com, kvalo@codeaurora.org, sgruszka@redhat.com
Cc:     Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
        pkshih@realtek.com, tehuang@realtek.com, johannes@sipsolutions.net
Date:   Sat, 03 Nov 2018 21:28:49 -0700
In-Reply-To: <1540980747-9297-9-git-send-email-yhchuang@realtek.com>
References: <1540980747-9297-1-git-send-email-yhchuang@realtek.com>
         <1540980747-9297-9-git-send-email-yhchuang@realtek.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-31 at 18:12 +0800, yhchuang@realtek.com wrote
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> debug files for Realtek 802.11ac wireless network chips
[]
> diff --git a/drivers/net/wireless/realtek/rtw88/debug.h b/drivers/net/wireless/realtek/rtw88/debug.h
[]
> +#ifdef CONFIG_RTW88_DEBUG
[]
> +#else
> +
> +static inline void rtw_dbg(struct rtw_dev *rtwdev, const char *fmt, ...) {}
> +static inline void rtw_info(struct rtw_dev *rtwdev, const char *fmt, ...) {}
> +static inline void rtw_warn(struct rtw_dev *rtwdev, const char *fmt, ...) {}
> +static inline void rtw_err(struct rtw_dev *rtwdev, const char *fmt, ...) {}

I still think it's _very, very bad_, and extremely
unusual to turn off _all_ logging, even for error
conditions, based on a debug config flag.


