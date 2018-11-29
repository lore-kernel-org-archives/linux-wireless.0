Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF5DC04EBA
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 16:55:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4802E20868
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 16:55:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQ+sJ8Tm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4802E20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbeK3EBA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 23:01:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729753AbeK3EBA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 23:01:00 -0500
Received: from localhost (unknown [37.142.5.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C16A020868;
        Thu, 29 Nov 2018 16:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543510499;
        bh=DztOIO2I15ErJ7QYcFBQ0XKeRAGlAxL01yn5r+Ff+Wc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XQ+sJ8TmiIAyjvqQ+Nco9TQeQaR3O7zfdp3wNR+FnwbHVmNvMofQkK5ObDYWa97F9
         +ZVArpRpwaNiGJxROKsAoYfhUAG8Ycw8eVe6Gp7zcwXZrFCoDM5oztNX9ScW4kHw1r
         nkN08cWcw0C/iZYu97jy6Fx+ZBHkuJOFrNQ/5NVc=
Date:   Thu, 29 Nov 2018 11:54:56 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 06/68] brcmutil: really fix decoding channel
 info for 160 MHz bandwidth
Message-ID: <20181129165456.GC208508@sasha-vm>
References: <20181129055559.159228-1-sashal@kernel.org>
 <20181129055559.159228-6-sashal@kernel.org>
 <87y39c85ns.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y39c85ns.fsf@purkki.adurom.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Nov 29, 2018 at 01:49:43PM +0200, Kalle Valo wrote:
>Sasha Levin <sashal@kernel.org> writes:
>
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> [ Upstream commit 3401d42c7ea2d064d15c66698ff8eb96553179ce ]
>>
>> Previous commit /adding/ support for 160 MHz chanspecs was incomplete.
>> It didn't set bandwidth info and didn't extract control channel info. As
>> the result it was also using uninitialized "sb" var.
>>
>> This change has been tested for two chanspecs found to be reported by
>> some devices/firmwares:
>> 1) 60/160 (0xee32)
>>    Before: chnum:50 control_ch_num:36
>>     After: chnum:50 control_ch_num:60
>> 2) 120/160 (0xed72)
>>    Before: chnum:114 control_ch_num:100
>>     After: chnum:114 control_ch_num:120
>>
>> Fixes: 330994e8e8ec ("brcmfmac: fix for proper support of 160MHz bandwidth")
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please mark your stable patches with:
>
>X-Patchwork-Hint: ignore
>
>This way patchwork ignores them and this saves my time. Thank you.

Will do, thanks!

--
Thanks,
Sasha
