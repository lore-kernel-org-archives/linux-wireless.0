Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4A3C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 10:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F06E2171F
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 10:36:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="meNO7Ksz";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fTdp5r4y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731445AbfB1Kg5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 05:36:57 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47058 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfB1Kg5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 05:36:57 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 66E7D60DAA; Thu, 28 Feb 2019 10:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551350216;
        bh=vqzRbF82ca3ksxMcB+KBiVRS0Frj6d67nZH+ZT61/UQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=meNO7KszCKxzxlXb6XfJXR69JopNxP4doU8EJmulJnVbIZpGu5F6x92/mkqCUilLr
         A1Jg0oIebrveAMf3DekNXpgAZoy9H7rZDO4v8fNPhL46nlJ4xyfPbl4UKQhwxSyNSD
         VrQz0HOogfN+KWNJ5R4tiBfQEGNEN0hRjB015mbg=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 271CB60A43;
        Thu, 28 Feb 2019 10:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551350215;
        bh=vqzRbF82ca3ksxMcB+KBiVRS0Frj6d67nZH+ZT61/UQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fTdp5r4yQ1PeoC1cmx9eXmO23aMgnSiCO3uLCOL4wAUHu74QKEa2RvhUQafg9BIUC
         a0UomSJXyScnAHNeWl8iB+2JVTh6zdAPdsuRgGISGNqU/pQ6OYNPsfBjN3ePdysrgp
         3R3+m4VKC3pi1fwWg864LQa2sCFoW/Kztjvb97II=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 28 Feb 2019 12:36:54 +0200
From:   merez@codeaurora.org
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 03/21] wil6210: support up to 20 stations in AP mode
In-Reply-To: <87va14z2zg.fsf@purkki.adurom.net>
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
 <1550845279-16103-4-git-send-email-merez@codeaurora.org>
 <87va14z2zg.fsf@purkki.adurom.net>
Message-ID: <e92624892cce4bf845f60fb4334c01d7@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-02-28 11:17, Kalle Valo wrote:
> Maya Erez <merez@codeaurora.org> writes:
> 
>> From: Ahmad Masri <amasri@codeaurora.org>
>> 
>> +
>> +	max_assoc_sta = min_t(uint, max_assoc_sta, fw_max_assoc_sta);
> 
> You shouldn't modify max_assoc_sta like this. If you have two wil6210
> devices on the same host they will share that variable and there's a
> race condition. Sure, I guess currently they will use the same firmware
> so the values will be the same, but still this is a bug. I think you
> should have wil->max_assoc_sta to make this device specific value.
> 
> I'll apply this anyway as it breaks all other patches if I remove this
> patch. But please fix this in a follow up patch.

we'll fix that.

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
