Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83E0C004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 07:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FA1020831
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 07:51:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YlGqoIpK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="isDlkWvq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FA1020831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbeJXQRn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 12:17:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40978 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbeJXQRn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 12:17:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6D8C460F39; Wed, 24 Oct 2018 07:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540367444;
        bh=airQKr2hQAfcDpd0qV4dEfogZh+vEH9IDTk9ys52p0k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YlGqoIpKJCSTirEIdiX3Iep+XHlTHOT9bWJBasfeTvcI7VaeU8hc8ZSjCCvT6mSE+
         NWiCa/mpznZehpO7jMK3OhGGEm3dP4gm4Td91Ku+M4AmPjZCQcSk9itnm+GTzkNG+Z
         GR/PpZUnopRqfzXCO2oCApLHscZk9iyziLTe+we4=
Received: from x230.qca.qualcomm.com (87-93-79-96.bb.dnainternet.fi [87.93.79.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 86A6E6034D;
        Wed, 24 Oct 2018 07:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540367443;
        bh=airQKr2hQAfcDpd0qV4dEfogZh+vEH9IDTk9ys52p0k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=isDlkWvqfETGCoQQl/S8bw4tZe932qnyQJcK0O0D1ztsrLZ/+r2gsGltHzVYeLMTi
         Qf8GiDvPTrAS573tP8c9YrFSDof40BpgZknb24EDoq5VGgLbZAJZ/IQX70cmrrrUOL
         q5ScqBbYQrT2/fjBlHWCh0PZ0NKzEYZhyNrAcF0s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 86A6E6034D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Govind Singh <govinds@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>
Subject: Re: [GIT] Networking
References: <20181023.202921.1185045750138652543.davem@davemloft.net>
        <CAHk-=whuhCGujWKO8JObGQaSdWOpJBXdkM-B-vD80QZifveScw@mail.gmail.com>
        <CAHk-=wh2H9jE2RXibQgWs3_Q539roj62_gzPXKjnhhKqSFcw2g@mail.gmail.com>
Date:   Wed, 24 Oct 2018 10:50:38 +0300
In-Reply-To: <CAHk-=wh2H9jE2RXibQgWs3_Q539roj62_gzPXKjnhhKqSFcw2g@mail.gmail.com>
        (Linus Torvalds's message of "Wed, 24 Oct 2018 08:23:44 +0100")
Message-ID: <87lg6nu6k1.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Oct 24, 2018 at 7:01 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Hmm. Tentatively pulled, but there's something wrong with the Kconfig rules.
>
> Confirmed.

BTW, our emails crossed and more info in the other email[1].

> I did a978a5b8d83f ("net/kconfig: Make QCOM_QMI_HELPERS available when
> COMPILE_TEST") to fix the breakage.

Thanks, though I don't see it yet as I guess you haven't pushed it yet.
Do note that it _might_ conflict the other commit which I suspect is in
also coming to you:

ccfb464cd106 ("soc: qcom: Allow COMPILE_TEST of qcom SoC Kconfigs")

> Why wasn't this noticed in testing?

Mostly bad timing due to my vacation. I did do allmodconfig build but
not sure why I missed the warning, also the kbuild bot didn't report
anything. Jeff did report[2] it last week but I was on vacation at the
time and just came back yesterday and didn't have time to react to it
yet. Really sorry for the mess.

[1] https://lkml.kernel.org/r/87pnvzu7i6.fsf@codeaurora.org

[2] http://lists.infradead.org/pipermail/ath10k/2018-October/012330.html

-- 
Kalle Valo
