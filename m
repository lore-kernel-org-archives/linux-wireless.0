Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38380C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB9A32085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:08:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bl2FHE7W";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MsCg9Ui5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB9A32085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbeJKPex (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 11:34:53 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58518 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbeJKPew (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 11:34:52 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 397B1605FF; Thu, 11 Oct 2018 08:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539245324;
        bh=bztY30R0HqdBYmuvB1jSZupIQZODwSH/1kw7SYce3xE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bl2FHE7Wx4Ha2OHxJ6So2bj82WdjSE+jDmg4waHuEoYscAsadkDP3B1P/xudsnHDL
         IheEUnWrSR1JTGmdi340r3fR67Jc3Z6doSvkNi012UzVIO67FDKYLlf43qGIfq3B2Z
         tDeUgF5XCmrSVUmeqxQdjg7zzM9TvncT7P5k1i0I=
Received: from x230.qca.qualcomm.com (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 18508605FF;
        Thu, 11 Oct 2018 08:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539245323;
        bh=bztY30R0HqdBYmuvB1jSZupIQZODwSH/1kw7SYce3xE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MsCg9Ui5qse6Tvwo0AGHqkS9KcmHtEV6xQI95D5McekLqGZTTx03Iv4bkFbew4Arb
         SpHDIG8Sd0quCLCR9qSbvFlpySVDDNy6dRhC4pnjdA6Lu2V93XqTeft45pOd954+rz
         j+LzmIkQoXRrzoxybD9V9QoYE+6T7RQasuGrK63c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 18508605FF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     Igor Mitsyanko <imitsyanko@quantenna.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] qtnfmac: avoid uninitialized variable access
References: <20181009155757.494212-1-arnd@arndb.de>
        <20181009202507.xs5bcaq5pi4zcps3@bars>
        <20181010145625.fn2dy2np7e6xxdci@bars>
Date:   Thu, 11 Oct 2018 11:08:38 +0300
In-Reply-To: <20181010145625.fn2dy2np7e6xxdci@bars> (Sergey Matyukevich's
        message of "Wed, 10 Oct 2018 14:56:33 +0000")
Message-ID: <87bm80x5vd.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

>> > When qtnf_trans_send_cmd_with_resp() fails, we have not yet initialized
>> > 'resp', as pointed out by a valid gcc warning:
>> >
>> > drivers/net/wireless/quantenna/qtnfmac/commands.c: In function
>> > 'qtnf_cmd_send_with_reply':
>> > drivers/net/wireless/quantenna/qtnfmac/commands.c:133:54: error:
>> > 'resp' may be used uninitialized in this function
>> > [-Werror=maybe-uninitialized]
>> >
>> > Since 'resp_skb' is also not set here, we can skip all further
>> > processing and just print the warning and return the failure code.
>> >
>> > Fixes: c6ed298ffe09 ("qtnfmac: cleanup and unify command error handling")
>> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> 
>> Thanks for the patch! And for reminding me that I forgot to enable
>> gcc warnings in CI builds in addition to sparse checks.
>> 
>> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>
> Hi Kalle,
>
> Could you please hold back applying this patch for now. We have got
> another report for the same function, this time static analysis tool
> warning. It looks like the patch from Arnd does not cover both cases.
> So we will take a closer look and send a combined fix later.

Ok, I'll drop this from my queue. Please resend whatever patch I need to
apply.

-- 
Kalle Valo
