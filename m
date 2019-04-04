Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B71C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 04:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6838E205C9
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 04:06:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VasViqSY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bqLNY1Ck"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfDDEGz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 00:06:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56764 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfDDEGz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 00:06:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 925E460CF0; Thu,  4 Apr 2019 04:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554350814;
        bh=NuC7QLicJkutOyY4NZDUGtRXP9q+TDCfs7OoYX3Jx0A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VasViqSY9eqBomTPgHO9Yc6it/K26mN00dJFlJbbg5DsqLUlZVblr5K7hI6lVE4Mr
         U9qRLpTMwQ0RUOxv2OlXvTFhkGz73v32GAWGFLI+Lt0vvREFeeoEHvYQsJ7oCpPjWl
         BWJnp7LnUl7eyKsbak4vp6Yh3EaWcnZ+XBdYgb14=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 916D0602F2;
        Thu,  4 Apr 2019 04:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554350812;
        bh=NuC7QLicJkutOyY4NZDUGtRXP9q+TDCfs7OoYX3Jx0A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bqLNY1CkK5g5tLbQXAwcU3EA6Uzv5HDl+RCWkr0NXZnHsgp4GcVRJrl9Rnl7Cn49i
         8Ni3kzuCE+yF/LCbHlNDqH1b6hWWNfyPZWveS21kXH17K3nhQtU6HNDnMBj8ojOlBy
         jUx80bPejmVnMdCSD350H+mHrPsXGGau43vSG6Uc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 916D0602F2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM <linux-pm@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        ath10k@lists.infradead.org, Todd Brandt <todd.e.brandt@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Sriram R <srirrama@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Claire Chang <tientzu@google.com>
Subject: Re: [PATCH] ath10k: Drop WARN_ON()s that always trigger during system resume
References: <2884043.Jv1Mn93hE8@aspire.rjw.lan>
        <20190403195718.GA74723@google.com>
        <1645947.WPhbVaNX0l@aspire.rjw.lan>
        <CA+ASDXPoB94o0pbY0TQGS7Dtp2RNz=3goH38gpLtBoJ15i7eoQ@mail.gmail.com>
Date:   Thu, 04 Apr 2019 07:06:46 +0300
In-Reply-To: <CA+ASDXPoB94o0pbY0TQGS7Dtp2RNz=3goH38gpLtBoJ15i7eoQ@mail.gmail.com>
        (Brian Norris's message of "Wed, 3 Apr 2019 14:54:19 -0700")
Message-ID: <87k1gatnvt.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Wed, Apr 3, 2019 at 2:47 PM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> I have been wondering whether or not I need to resend this patch or something ...
>
> I think the linux-wireless Patchwork instance is the source of truth
> -- Kalle and Johannes use it for tracking status, IIUC. So this says
> your patch is still "New":
>
> https://patchwork.kernel.org/patch/10837139/

Yeah, that's right:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork

So no need to resend, it's in my queue.

I was travelling and then busy with something else so I haven't had a
chance to process patches, I'll try to catch up now but I'm sure it will
take a while as there are so many patches. Sorry for the delay.

-- 
Kalle Valo
