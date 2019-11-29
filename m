Return-Path: <SRS0=lMj3=ZV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65C8C432C0
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Nov 2019 05:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6DE4215A5
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Nov 2019 05:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LLy/TBTm";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="SumgFk3z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfK2FX3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Nov 2019 00:23:29 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:43214
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725812AbfK2FX3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Nov 2019 00:23:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575005008;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=5LvzbzKAziNzoleQS/uDblYo8+DLP9mI9lwsWLF66Zo=;
        b=LLy/TBTmiPFe06suTXIIwANVOD/cajaI0QTfvRLLRdd5xiXjw7wScV3hKFehj9KD
        uVDRNHoQF/RH/qzypKisp5RRe3F2+PcV29/SF1BsbRaDYCkY3ONpelHjl8TzBujgpsN
        pqKiWVLwnAJCKOIgQsWHXZVFvpVRHgP7b4lXsVaY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575005008;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=5LvzbzKAziNzoleQS/uDblYo8+DLP9mI9lwsWLF66Zo=;
        b=SumgFk3zWRh535f+H/RdQucfDJpMEcqRNTltI2Rq6RTTBcuEEFHE7BNlclz6zCud
        Ls0r+rsTOcoDQqSkyoIQqF7X9XX2Js30QQqV0DRG1btUYuOan/I/Oabw4eIp3JChAr4
        6G8CXa2ZfPcQFvb86Wc1ZRVsFBxoO7/X8+K1zql8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 34205C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Chris Chiu <chiu@endlessm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: Re: [PATCH v3 1/2] rtw88: add regulatory process strategy for different chipset
References: <20191022101229.26044-1-yhchuang@realtek.com>
        <20191022101229.26044-2-yhchuang@realtek.com>
        <CAB4CAwf9vanVf7JA5ZD52Yn-ngtEkA6S6YqhUZssXaLsHYio1w@mail.gmail.com>
        <f93341159e4342479e646e49ec2ab8d2@realtek.com>
Date:   Fri, 29 Nov 2019 05:23:28 +0000
In-Reply-To: <f93341159e4342479e646e49ec2ab8d2@realtek.com> (Tony Chuang's
        message of "Fri, 29 Nov 2019 02:29:41 +0000")
Message-ID: <0101016eb59d3246-c013abc9-4fbf-4825-9780-a85cff3f43d2-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.11.29-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> -----Original Message-----
>> From: Chris Chiu [mailto:chiu@endlessm.com]
>> Sent: Friday, October 25, 2019 11:54 AM
>> To: Tony Chuang
>> Cc: Kalle Valo; linux-wireless; Brian Norris
>> Subject: Re: [PATCH v3 1/2] rtw88: add regulatory process strategy for
>> different chipset
>> 
>> On Tue, Oct 22, 2019 at 6:12 PM <yhchuang@realtek.com> wrote:
>> >
>> > From: Tzu-En Huang <tehuang@realtek.com>
>> >
>> > There are two kinds of country/regulatory efuse settings
>> > for Realtek's chipset, one is worldwide and the other is
>> > a specific country. For both settings, REGULATORY_STRICT_REG
>> > will be set, telling stack that devices original regulatory is
>> > the superset of any further settings.
>> >
>> > For the chipset with the country setting being a specific
>> > country, Realtek does not apply any new regulatory setting
>> > notifiers to the card.
>> >
>> > For the chipset with a worldwide regulatory setting,
>> > Realtek's custom worldwide regulatory setting will be
>> > provided via wiphy_apply_custom_regulatory().
>> > And if a new regulatory notification is set by
>> > NL80211_REGDOM_SET_BY_COUNTRY_IE, the new setting will be
>> > applied to the card.
>> >
>> > Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
>> > Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> Reviewed-by: Chris Chiu <chiu@endlessm.com>
>> 
>> Looks good to me.
>> 
>> Chris
>
> Gentle ping of this patch set :)

This is on my queue. I just want to investigate this in detail and
haven't found enough free time to do that.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
