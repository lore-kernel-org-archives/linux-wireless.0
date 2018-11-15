Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232C0C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 14:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6E5A2145D
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 14:15:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ac+YQsh9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ac+YQsh9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6E5A2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387839AbeKPAXI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 19:23:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56318 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729034AbeKPAXH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 19:23:07 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B320A60591; Thu, 15 Nov 2018 14:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542291306;
        bh=90h7w3fvMWSbEL3VO2e5raWPVXBDLggOVZms0qaFLaE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ac+YQsh9frBRHQLVRTjUYb/mZesDIE6W/JqCuHOP62ymyP319gmKRqTBHrg7hOl1c
         Pxp4Pp60LIcYIUQeDjpb0+cl/mQ5ZOYU3hbqT7bwrYUpI8KWhRvDJlR1VgBSLTXx+y
         YbfeP5K4Q+FdOXLlx6O6LI+0CdGSw7Tf/6D5cc+Y=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CABEB60386;
        Thu, 15 Nov 2018 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542291306;
        bh=90h7w3fvMWSbEL3VO2e5raWPVXBDLggOVZms0qaFLaE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ac+YQsh9frBRHQLVRTjUYb/mZesDIE6W/JqCuHOP62ymyP319gmKRqTBHrg7hOl1c
         Pxp4Pp60LIcYIUQeDjpb0+cl/mQ5ZOYU3hbqT7bwrYUpI8KWhRvDJlR1VgBSLTXx+y
         YbfeP5K4Q+FdOXLlx6O6LI+0CdGSw7Tf/6D5cc+Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CABEB60386
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
        <87y3b1vpjk.fsf@codeaurora.org>
        <0a41d14b9a964b6b7825bf5c55c32f35166354cd.camel@perches.com>
        <e85b7fa45cefc0bc3df15785f34792abe33f41c6.camel@perches.com>
Date:   Thu, 15 Nov 2018 16:15:01 +0200
In-Reply-To: <e85b7fa45cefc0bc3df15785f34792abe33f41c6.camel@perches.com> (Joe
        Perches's message of "Sat, 03 Nov 2018 21:45:50 -0700")
Message-ID: <878t1ubf6i.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Sat, 2018-10-13 at 13:28 -0700, Joe Perches wrote:
>> On Sat, 2018-10-13 at 18:23 +0300, Kalle Valo wrote:
>> > Joe Perches <joe@perches.com> writes:
> []
>> > > It's very unusual to have _all_ the logging under a CONFIG_<FOO>_DEBUG
>> > > config guard flag.
>> > 
>> > For wireless drivers that is actually quite typical.
>> 
>> No, it isn't.
>> 
>> > IIRC at least ath6kl, ath9k and ath10k do that, most likely also others.
>> 
>> No, they don't.  Check again.
>> 
>> > > Typical debugging would dynamic debugging on a per-line instance andl
>> > > this uses a single dev_dbg for all debugging.
>> > 
>> > I don't recall seeing anyone using per-line dynamic debugging with
>> > wireless drivers. The drivers are so complex that enabling one message
>> > at a time doesn't really get you anywhere, that's why we mostly group
>> > messages into similar groups (or levels) to make it easier to enable
>> > certain debug messages.
>> 
>> You should look harder.  
>> 
>> > > This seems unnecessarily complexity for a negative gain.
>> > 
>> > I haven't reviewed the driver yet but from a quick look I don't see this
>> > as a problem.
>>   
>> It is unnecessarily complex.
>> This saves one dereference per call, but is it really worth it?
>
> Kalle, did I miss a reply here?

I didn't bother to waste my time after reading comments like "check
again" and "look harder".

-- 
Kalle Valo
