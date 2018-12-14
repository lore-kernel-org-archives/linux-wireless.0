Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB526C67839
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 12:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AF12208E7
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 12:59:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EWceAEu5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JhilviqW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AF12208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbeLNM7t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 07:59:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51622 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbeLNM7t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 07:59:49 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5BF3F6071A; Fri, 14 Dec 2018 12:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544792388;
        bh=OBtjHy/GQq8q1an/HFJxqXrfC5852+ayEaGntQAdFA4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EWceAEu5tDikLV+TyrbYkBt/p4V9+HjcmNqrIoSB5gRNEHkeQSpbLXMk5SwcN9W3i
         1N7201orDRxZsgJrlttUh78W4eXG5FFdPBjYSHKpr1k1oauFk9i1FyCe/j55+A39UZ
         loT22sGfybQ1GE7SU6vXrAVEns1Q2Ijw48lBJpCg=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id D2564601E7;
        Fri, 14 Dec 2018 12:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544792387;
        bh=OBtjHy/GQq8q1an/HFJxqXrfC5852+ayEaGntQAdFA4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JhilviqWIYeRGUJQnzIgViqVzu6+xVEn6/I6RMcEI3+yRTa4q4YGyn44/wD7Z2tky
         9Wl72pWmsnygRfjU6jubNWiRjuoTfxLqjLKrgF6czXd9HWO5ltHydPQ30GGd1Ktrc4
         mW4NSa1IkpRSElwGL90eJYiDxlTwYzOXuZjQWFsM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 14 Dec 2018 18:29:47 +0530
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, Govind Singh <govinds@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: skip sending quiet mode cmd for WCN3990
In-Reply-To: <87ftv0xqwp.fsf@kamboji.qca.qualcomm.com>
References: <1544782666-24837-1-git-send-email-kvalo@codeaurora.org>
 <87ftv0xqwp.fsf@kamboji.qca.qualcomm.com>
Message-ID: <b243c620f222584ac175a92e8f7a39d2@codeaurora.org>
X-Sender: pillair@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,
I tested this patch on WCN3990 and did basic STA mode sanity. I do not 
see any crash with this fix.

Thanks,
Rakesh Pillai.

On 2018-12-14 17:26, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
>> From: Rakesh Pillai <pillair@codeaurora.org>
>> 
>> HL2.0 firmware does not support setting quiet mode.  If the host 
>> driver sends
>> the quiet mode setting command to the HL2.0 firmware, it crashes with 
>> the below
>> signature.
>> 
>> fatal error received: err_qdi.c:456:EX:wlan_process:1:WLAN 
>> RT:207a:PC=b001b4f0
>> 
>> The quiet mode command support is exposed by the firmware via thermal 
>> throttle
>> wmi service. Enable ath10k thermal support if thermal throttle wmi 
>> service bit
>> is set.  10.x firmware versions support this feature by default, but
>> unfortunately do not advertise the support via service flags, hence 
>> have to
>> manually set the service flag in ath10k_core_compat_services().
>> 
>> Compile tested only.
> 
> I'm planning to queue this for 4.20 as wcn3990 support won't work
> otherwise. But I wasn't able to test this so can someone help, please?
