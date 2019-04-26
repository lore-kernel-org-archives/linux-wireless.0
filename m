Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94DAC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 07:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEDAD2084F
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 07:18:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CwzAMtiY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CgRHa1Db"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfDZHSY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 03:18:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfDZHSX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 03:18:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9FA476076C; Fri, 26 Apr 2019 07:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556263102;
        bh=13pIkGFjPBVaD7F0MYIB7FogfjwR5GR9h5H9B8AhtEM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CwzAMtiYnqfNeOS1+qZgbUDJvorCVduqOF63C1q8kP8e+Fljeg89z3C+Rg/6tX6Y2
         N2Qv+A4DwnUfPNi+F848CgmW4BVgiPnRFTJTLc5IDEFfaJqLVRGOaFd3N2e6UWCTMc
         afmf6biONQ4Dk7JBrnWgn+MKCEgIk+zoTMqbj/Eg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 618746022B;
        Fri, 26 Apr 2019 07:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556263101;
        bh=13pIkGFjPBVaD7F0MYIB7FogfjwR5GR9h5H9B8AhtEM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CgRHa1DbNVpCPVscDtuC1uzFn24UznN1EILGlKAonrYi5pwyh0E2UM7Fh74bskrZA
         R3hnS6jjX2QYBZOKbH3Rx9BbORtqz+vPjtI0QqFImEsNWn3A+KoN/amnUQxGZoTvwl
         MCkleJHhIqmjTsXCYdARAC28qYMe7qrWwBDrrTvI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 618746022B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Claire Chang <tientzu@google.com>,
        Sriram R <srirrama@codeaurora.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Todd Brandt <todd.e.brandt@intel.com>
Subject: Re: [PATCH] ath10k: Drop WARN_ON()s that always trigger during system resume
References: <2884043.Jv1Mn93hE8@aspire.rjw.lan>
        <20190403195718.GA74723@google.com>
Date:   Fri, 26 Apr 2019 10:18:16 +0300
In-Reply-To: <20190403195718.GA74723@google.com> (Brian Norris's message of
        "Wed, 3 Apr 2019 12:57:20 -0700")
Message-ID: <87o94tutdz.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> + Sriram, Pradeep, Claire
>
> On Sun, Mar 03, 2019 at 06:24:33PM +0100, Rafael J. Wysocki wrote:
>
> Ooh, exactly 1 month ago!
>
>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> 
>> ath10k_mac_vif_chan() always returns an error for the given vif
>> during system-wide resume which reliably triggers two WARN_ON()s
>> in ath10k_bss_info_changed() and they are not particularly
>> useful in that code path, so drop them.
>> 
>
> Particularly, when WOWLAN isn't enabled, we get called during resume via
> ieee80211_reconfig(), where we're not associated and don't have any
> channel contexts. AFAICT, we shouldn't need to communicate anything in
> particular to the firmware here, and so failing the 'if' is definitely
> not worth WARN-ing about.
>
> I'd love to see this get applied with:
>
> Fixes: cd93b83ad927 ("ath10k: support for multicast rate control")
> Fixes: f279294e9ee2 ("ath10k: add support for configuring management packet rate")
>
> and sent to stable. This has been bugging people since 4.19. Spurious
> WARN_ON()s can trigger reports to various crash trackers, and on some
> systems appear as user-visible warnings ("System problem detected").
>
>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Tested-by: Brian Norris <briannorris@chromium.org>

I added these now to the commit log, thanks Brian.

Rafael, could you please provide the hardware and firmware versions you
tested this on? We have so many different firmware branches to support
that I prefer to have that documented in the commit log. Providing
ath10k startup messages in dmesg are enough, I can then add it to the
commit log.

-- 
Kalle Valo
