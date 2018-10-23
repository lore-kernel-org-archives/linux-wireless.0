Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8151C46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 11:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CEF4204EC
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 11:59:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NcyXLbkm";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Af4EgwXS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CEF4204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbeJWUXH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 16:23:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeJWUXH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 16:23:07 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 47C4160ADB; Tue, 23 Oct 2018 11:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540295996;
        bh=81YErSJdWaJrW6aUiNxQRuH+PAHtd3L5slRG4fJpAJc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NcyXLbkmsIlun3CCfJQFZ60Qywqe3AOHZmNKA2DR1J1+E0jZOMOoNUrt8/ZspxDrV
         GDeTNhH+u0HXhfPrE4U5/zZ4mYxhmYlM+77POkLOuWb2tagxl9OGhF0sewMXCIXzWj
         iJQqED8Os5zSes6J65FraA0vRgLfik8Ak0KfbkpI=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9CC1B601A0;
        Tue, 23 Oct 2018 11:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540295995;
        bh=81YErSJdWaJrW6aUiNxQRuH+PAHtd3L5slRG4fJpAJc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Af4EgwXSDVAHY3WwQiUPJ+6AyujchbVwbO4TlRROEgRfZk5VLvZBa2M20NCYZW+2O
         PISsWfp+d/IGbDrDWbYEuxJfJ6kOvU8oRpdwnwrBDZLSlkcpzB5LSKkeQuwT1/iXvg
         xKLxgSAiDTNR2adaU5LdBcbweyVFKVm4FE+I0bpQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9CC1B601A0
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Johannes Stezenbach <js@sig21.net>,
        Arend van Spriel <aspriel@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: 4.18.16: memory leak in sta_set_sinfo
References: <20181022080214.GA6379@sig21.net>
        <f1f5e0839f4b1b68510b9db398995c859a19a19e.camel@sipsolutions.net>
        <20181022083552.GA6878@sig21.net>
        <90015710a62fa0a6d9da17f5760616101b19c206.camel@sipsolutions.net>
        <2ad39f6f-c01a-f51c-e114-641d11a5eb22@broadcom.com>
Date:   Tue, 23 Oct 2018 14:59:51 +0300
In-Reply-To: <2ad39f6f-c01a-f51c-e114-641d11a5eb22@broadcom.com> (Arend van
        Spriel's message of "Mon, 22 Oct 2018 12:48:31 +0200")
Message-ID: <87bm7kdgaw.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 10/22/2018 10:37 AM, Johannes Berg wrote:
>> On Mon, 2018-10-22 at 10:35 +0200, Johannes Stezenbach wrote:
>>
>>>> commit 848e616e66d4592fe9afc40743d3504deb7632b4
>>>> Author: Stefan Seyfried <seife+kernel@b1-systems.com>
>>>> Date:   Sun Sep 30 12:53:00 2018 +0200
>>>>
>>>>     cfg80211: fix wext-compat memory leak
>>>>
>>>> Hopefully that'll eventually propagate to stable.
>>>
>>> Good to know it's fixed, but "hopefully" makes me wonder,
>>> I'd love to hear the confirmation that it's been queued.
>>
>> Well, normally it works automatically when you have a Fixes tag, so I
>> don't usually try to queue anything manually. Maybe Greg has had his
>> hands full with the 4.19 release :-)
>
> Missed the memo. Does that mean Cc: to stable is no longer needed? It
> is still documented as such in
> Documentation/process/stable-kernel-rules.rst.

I haven't seen any memos either but in lot of cases having just Fixes
line seems to be enough to get the patch to stable releases. If someone
has any documentation about this, please do share.

-- 
Kalle Valo
