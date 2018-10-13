Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D065C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 15:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2312B20877
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 15:23:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hgZKMaLz";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LMXQ7Uml"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2312B20877
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbeJMXBI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 19:01:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51894 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbeJMXBI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 19:01:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id ECCA460C60; Sat, 13 Oct 2018 15:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539444213;
        bh=97QntL+EBWLV+4mX/R40OTde94JLHuTUzdRzRs3z63Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hgZKMaLz0wMDDYO/cLOI/fc2B3moT4vxNQ3pu93G0XYG9S5Tw/pG7uTcefqu2oy9S
         DW/DdjpT9MMswIBR3MnsqOyQA00FE0w0ZYdsdd3jKkz1HC5X8hiEJWURb8xjhCDHFe
         inENNmMxALotAeoFt/FuGnO0tp6U+Po9IyzrmFlA=
Received: from x230.qca.qualcomm.com (85-76-48-32-nat.elisa-mobile.fi [85.76.48.32])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08EFE60452;
        Sat, 13 Oct 2018 15:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539444212;
        bh=97QntL+EBWLV+4mX/R40OTde94JLHuTUzdRzRs3z63Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LMXQ7UmlrxMooW3A1uNQ5liX4j9t6YAqGQzNI5pSf2K3ymI+bDILZpCNq7XvnbYUk
         aokBvLGdIBYkpKIzhTgRxJKEsg4nVkO7iDKQbPaWhvNnbNyzQC59PBdA2hPyvfwxSd
         Aaf+6btj/UYaUP3m46IzjAU69/7xAG7DwIWhyKuM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 08EFE60452
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Joe Perches <joe@perches.com>
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com, sgruszka@redhat.com,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC v4 08/13] rtw88: debug files
References: <1539421245-11847-1-git-send-email-yhchuang@realtek.com>
        <1539421245-11847-9-git-send-email-yhchuang@realtek.com>
        <a731948bf875867be4246b72a661ce71833620b8.camel@perches.com>
Date:   Sat, 13 Oct 2018 18:23:27 +0300
In-Reply-To: <a731948bf875867be4246b72a661ce71833620b8.camel@perches.com> (Joe
        Perches's message of "Sat, 13 Oct 2018 07:19:31 -0700")
Message-ID: <87y3b1vpjk.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Sat, 2018-10-13 at 17:00 +0800, yhchuang@realtek.com wrote:
>> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> []
>> diff --git a/drivers/net/wireless/realtek/rtw88/debug.c
>> b/drivers/net/wireless/realtek/rtw88/debug.c
> []
>> +#ifdef CONFIG_RTW88_DEBUG
>> +
>> +void __rtw_dbg(struct rtw_dev *rtwdev, const char *fmt, ...)
>> +{
>> +	struct va_format vaf = {
>> +		.fmt = fmt,
>> +	};
>> +	va_list args;
>> +
>> +	va_start(args, fmt);
>> +	vaf.va = &args;
>> +
>> +	if (net_ratelimit())
>> +		dev_dbg(rtwdev->dev, "%pV", &vaf);
>> +
>> +	va_end(args);
>> +}
>> +EXPORT_SYMBOL(__rtw_dbg);
>> +
>> +#define __rtw_fn(fn)							\
>> +void __rtw_ ##fn(struct rtw_dev *rtwdev, const char *fmt, ...)		\
>> +{									\
>> +	struct va_format vaf = {					\
>> +		.fmt = fmt,						\
>> +	};								\
>> +	va_list args;							\
>> +									\
>> +	va_start(args, fmt);						\
>> +	vaf.va = &args;							\
>> +	dev_ ##fn(rtwdev->dev, "%pV", &vaf);				\
>> +	va_end(args);							\
>> +}									\
>> +EXPORT_SYMBOL(__rtw_ ##fn);
>> +
>> +__rtw_fn(info)
>> +__rtw_fn(warn)
>> +__rtw_fn(err)
>
> It's very unusual to have _all_ the logging under a CONFIG_<FOO>_DEBUG
> config guard flag.

For wireless drivers that is actually quite typical. IIRC at least
ath6kl, ath9k and ath10k do that, most likely also others.

> Typical debugging would dynamic debugging on a per-line instance and
> this uses a single dev_dbg for all debugging.

I don't recall seeing anyone using per-line dynamic debugging with
wireless drivers. The drivers are so complex that enabling one message
at a time doesn't really get you anywhere, that's why we mostly group
messages into similar groups (or levels) to make it easier to enable
certain debug messages.

> This seems unnecessarily complexity for a negative gain.

I haven't reviewed the driver yet but from a quick look I don't see this
as a problem.

> Also, many callers of the rtw_<level> logging function do not include
> a terminating newline.
>
> Please consistently use a newline for each format.

But with this I do agree.

-- 
Kalle Valo
