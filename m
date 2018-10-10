Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F0FC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 648312064E
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:57:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="b9GuCckn";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="htJV+ioB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 648312064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbeJJPSn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 11:18:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59982 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbeJJPSn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 11:18:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 514B060769; Wed, 10 Oct 2018 07:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539158265;
        bh=Drq9ZoyggPvU77yschP3Ub5ayjGr9hUOxcYxydi+8S8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=b9GuCcknSbGbCbSLZxAwTnUdTUYtCMrmLJzMQZ4D3w5n0mntzAgnueX0gnrdDbuXg
         hdEBwmfQzWhASf5/64umiTqVjkqTplxclX4BtAMC98AEpNDhEjlXDqxo4jow+BeEmu
         7Z0hUky0WffyjX8ojH2X1zGrBFh1Wbt3OTMTcXZk=
Received: from x230.qca.qualcomm.com (188-67-121-187.bb.dnainternet.fi [188.67.121.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ACF7D60769;
        Wed, 10 Oct 2018 07:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539158264;
        bh=Drq9ZoyggPvU77yschP3Ub5ayjGr9hUOxcYxydi+8S8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=htJV+ioBlYV8btiRiw7aM5/FpD9unE6AHnCO8184ly6IKInbWxhhpjbDy/Iy4G6GO
         9FR2x5Q4F9DAA/UDARjZ6yOANxcazpdWpwM0CcFTLnSzOm4pshNELtWVXo+HYnWtXZ
         VvNC4uMxmGPlOQ2n8DBVbI4sVCLbsnxomWgmuae4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ACF7D60769
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 5/6] brcmfmac: Set board_type from DMI on x86 based machines
References: <20181009124755.25402-1-hdegoede@redhat.com>
        <20181009124755.25402-5-hdegoede@redhat.com>
        <87murmxop9.fsf@codeaurora.org>
        <7397e1f5-5df6-4b49-78dd-ddc9774de16b@redhat.com>
        <12cc4f0d-38d4-bb7b-8b02-dbb57db284b3@broadcom.com>
Date:   Wed, 10 Oct 2018 10:57:40 +0300
In-Reply-To: <12cc4f0d-38d4-bb7b-8b02-dbb57db284b3@broadcom.com> (Arend van
        Spriel's message of "Wed, 10 Oct 2018 09:52:15 +0200")
Message-ID: <87efcyxmh7.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 10/10/2018 9:28 AM, Hans de Goede wrote:
>> So how do you want to proceed with this, do you want me to just
>> put the full ISC text in the header for now as the rest of brcmfmac
>> does?
>
> This is not entirely true as far as I know. I assume you are referring
> to this:
>
> /*
>  * Copyright (c) 2010 Broadcom Corporation
>  *
>  * Permission to use, copy, modify, and/or distribute this software for any
>  * purpose with or without fee is hereby granted, provided that the above
>  * copyright notice and this permission notice appear in all copies.
>  *
>  * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
>  * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>  * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
> FOR ANY
>  * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
>  * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
> AN ACTION
>  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
>  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>  */
>
> As far as I recall we opted for BSD license and ISC is equivalent.

Oh, sorry for missing that.

> However, The BSD license are already in place so why not use that. I
> would say BSD-2-Clause should cover it. As this is a new file I guess
> it is up to you although I would prefer to stick with a permissive
> license.

From maintainer's point of view I very much prefer that a driver uses
the same license in all files. It's very confusing if the license
changes within different files.

-- 
Kalle Valo
