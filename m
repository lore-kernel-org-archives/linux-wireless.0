Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E2BC0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 21:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 943DC20989
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 21:30:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="e7LIzGrF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="e7LIzGrF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 943DC20989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbeKHHCh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 02:02:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38152 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbeKHHCh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 02:02:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A27D8605FD; Wed,  7 Nov 2018 21:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541626223;
        bh=g6kMeXY0nWbdJh1+3VC20Sr5/Z/iTf+1TilbkUlMq50=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e7LIzGrFrcB7hioLeSaxZlp4g9k4doqfexVHQuW8oQ25BhTilBAF7IAenvDudICbg
         KJKfWg3ojglltmuqlli7KaBt9/zHV35UAlBeQh6jhTT8MshcH0wU8AXKdAvtQu3vqu
         ZMCG0bt1Nco0RnwO+0KtPB0jIqBXDgtahuwEV2Ic=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3AD62601DA;
        Wed,  7 Nov 2018 21:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541626223;
        bh=g6kMeXY0nWbdJh1+3VC20Sr5/Z/iTf+1TilbkUlMq50=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e7LIzGrFrcB7hioLeSaxZlp4g9k4doqfexVHQuW8oQ25BhTilBAF7IAenvDudICbg
         KJKfWg3ojglltmuqlli7KaBt9/zHV35UAlBeQh6jhTT8MshcH0wU8AXKdAvtQu3vqu
         ZMCG0bt1Nco0RnwO+0KtPB0jIqBXDgtahuwEV2Ic=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 07 Nov 2018 13:30:23 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yu Wang <yyuwang@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>,
        Govind Singh <govinds@codeaurora.org>, stable@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH REGRESSION] Revert "ath10k: add quiet mode support for
 QCA6174/QCA9377"
In-Reply-To: <20181107185643.240346-1-briannorris@chromium.org>
References: <20181107185643.240346-1-briannorris@chromium.org>
Message-ID: <7f2ef494f4a2aba1845a157da8fec449@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-07 10:56, Brian Norris wrote:
> This reverts commit cfb353c0dc058bc1619cc226d3cbbda1f360bdd3.
> 
> WCN3990 firmware does not yet implement this feature, and so it crashes
> like this:
> 
>   fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN 
> RT:207a:PC=b001b4f0
> 
> This feature can be re-implemented with a proper service bitmap or 
> other
> feature-discovery mechanism in the future. But it should not break
> working boards.
> 
Brian,

The change "ath10k: add quiet mode support for QCA6174/QCA9377" was 
merged even
before full WCN3990 device support was added in ath10k. How come it 
could be regression
for WCN3990. I know both are sharing same WMI-TLV interface but 
reverting this
will break QCA6174/QCA9377. no?

I would prefer to handle this within WMI callback or upper layer.

-Rajkumar
