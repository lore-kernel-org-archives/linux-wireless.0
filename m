Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97469C46465
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 04:32:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FDE920685
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 04:32:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nFn+IQ0m";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VbKcqNGR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FDE920685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbeKHOFd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 09:05:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36034 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728780AbeKHOFd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 09:05:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0FE146029D; Thu,  8 Nov 2018 04:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541651519;
        bh=7GpIraU0AHs+vUxuVdFwWZO9DMjK/LK5K/rWJN+2gZo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nFn+IQ0mjyT3Rd2MigYxneyvyJSWTdmJO2B8KPaspti/CNubpQFn9noN+8KLr+Tn7
         nxN9wnjZ82e11L8Adt2mASHyApuKE7iv9aJuL1LuADG8OXJrbtdz3VHQtdgh7E/KMr
         nnx/E+hKSefBfUHpXBb8XsF98DSzPP3omHVOXvtc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id BC8CF60741;
        Thu,  8 Nov 2018 04:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541651511;
        bh=7GpIraU0AHs+vUxuVdFwWZO9DMjK/LK5K/rWJN+2gZo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VbKcqNGRIMedMq/34xEEE4DmcCIVluxw+I9Zezjj5/SFS3xfNzp4HMS+2unQG1R6r
         8OSTinKjYhuKzUn9GrwnHfyxnY1KXdphx2FPZsQw20B1toTqxM4DpLNcyc9Lavomiq
         byNMplEDLwi0aBgbsdYvqxhKH9JInSHJoUNeTC/U=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 08 Nov 2018 10:01:51 +0530
From:   Govind Singh <govinds@codeaurora.org>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yu Wang <yyuwang@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>, stable@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH REGRESSION] Revert "ath10k: add quiet mode support for
 QCA6174/QCA9377"
In-Reply-To: <7f2ef494f4a2aba1845a157da8fec449@codeaurora.org>
References: <20181107185643.240346-1-briannorris@chromium.org>
 <7f2ef494f4a2aba1845a157da8fec449@codeaurora.org>
Message-ID: <b1a64bd66fa25f274af8c018c6fc02f4@codeaurora.org>
X-Sender: govinds@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-08 03:00, Rajkumar Manoharan wrote:
> On 2018-11-07 10:56, Brian Norris wrote:
>> This reverts commit cfb353c0dc058bc1619cc226d3cbbda1f360bdd3.
>> 
>> WCN3990 firmware does not yet implement this feature, and so it 
>> crashes
>> like this:
>> 
>>   fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN 
>> RT:207a:PC=b001b4f0
>> 
>> This feature can be re-implemented with a proper service bitmap or 
>> other
>> feature-discovery mechanism in the future. But it should not break
>> working boards.
>> 
> Brian,
> 
> The change "ath10k: add quiet mode support for QCA6174/QCA9377" was 
> merged even
> before full WCN3990 device support was added in ath10k. How come it
> could be regression
> for WCN3990. I know both are sharing same WMI-TLV interface but 
> reverting this
> will break QCA6174/QCA9377. no?
> 

This regression is found while we switched from 4.18 + WCN3990 
back-ports to 4.19.

> I would prefer to handle this within WMI callback or upper layer.
> 

IMO, we should use (WMI_SERVICE_THERMAL_MGMT | WMI_SERVICE_THERM_THROT ) 
service bitmap check and call
ath10k_thermal_set_throttling only if fw supports THERMAL THROTTLE 
feature. But we need to ensure all
available ath10k fw's are reporting this service.

> -Rajkumar

BR,
Govind
