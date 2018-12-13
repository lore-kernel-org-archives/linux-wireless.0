Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769B3C67839
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36D6B2086D
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JyZkZv3M";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ar83Dxhm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36D6B2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbeLMOyy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:54:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbeLMOyy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:54:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 383AD601D7; Thu, 13 Dec 2018 14:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544712893;
        bh=ag+O30y6oxfRsIE8OmRZN/kwwNYyRwuVRNMjKC//oko=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JyZkZv3MV0jHxRjWHm70ZmNWqVRgvCIatck0sTH+qsGIICkCU3A0VbbuDF0G9EStB
         Tx4Re3ICi1Qfxlp6VSzRzaX3GcF8J1MzHhQFFsnV3VCAWxq1P8/wKoBqzvI5fUq9+8
         EmySNIliAneeBiCRyFjXlbDY3oRMVJZW7v00UOlk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DEE28601EA;
        Thu, 13 Dec 2018 14:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544712892;
        bh=ag+O30y6oxfRsIE8OmRZN/kwwNYyRwuVRNMjKC//oko=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ar83Dxhm9rlO8fXE97VRh1PU6M12Dws6lpM7apWw5H5sNRTtL4rXbj3HJLoVQYbCw
         o9TgeWxgvIHq4pgE5ByY4sQ8Lo0BuS+5SKzV5wvmz+J/iALWD8hICrLaiitCrgJrBl
         NQkVH3e4MjZ9Al0wuozLlrma/YyYQ03ZHANLKN+k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DEE28601EA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mwifiex: debugfs: correct histogram spacing, formatting
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181203222654.GA155572@google.com>
References: <20181203222654.GA155572@google.com>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181213145453.383AD601D7@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 14:54:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> wrote:

> Currently, snippets of this file look like:
> 
> rx rates (in Mbps): 0=1M   1=2M2=5.5M  3=11M   4=6M   5=9M  6=12M
> 7=18M  8=24M  9=36M  10=48M  11=54M12-27=MCS0-15(BW20) 28-43=MCS0-15(BW40)
> 44-53=MCS0-9(VHT:BW20)54-63=MCS0-9(VHT:BW40)64-73=MCS0-9(VHT:BW80)
> ...
> noise_flr[--96dBm] = 22
> noise_flr[--95dBm] = 149
> noise_flr[--94dBm] = 9
> noise_flr[--93dBm] = 2
> 
> We're missing some spaces, and we're adding a minus sign ('-') on values
> that are already negative signed integers.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

4cb777c64e03 mwifiex: debugfs: correct histogram spacing, formatting

-- 
https://patchwork.kernel.org/patch/10710795/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

