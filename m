Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C292C46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 15:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40FFC2085A
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 15:05:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ovG4EYdU";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nYj4WZAI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40FFC2085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbeKFAZ6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 19:25:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59020 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbeKFAZ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 19:25:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F0FCB60AD8; Mon,  5 Nov 2018 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541430350;
        bh=9l5L26Jva/IHSyHZRwT+NzM0X8tN7vtJ4w5oa44EOiQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ovG4EYdUSlVw4G5q5X30qCEwroHansofQMYoJfVKdZ31mcgUzAHNbX7ajpNQRdlWb
         SpocggNK4nr6UocUPMGevsO0NoEVdxsz1C372ObPkxpEpRk4YYsrELQD8le+6DLGYg
         f/rGHMbNSCNW+DaX6xXAFWrWW12psegvKX5eoKgs=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 23C2260C54;
        Mon,  5 Nov 2018 15:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541430349;
        bh=9l5L26Jva/IHSyHZRwT+NzM0X8tN7vtJ4w5oa44EOiQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nYj4WZAI2AJ0YRZCpUXk9ltdjbWJ3sJ/yydh/03uzdkrOVZXEADJuZEMpYxGO4J4Q
         zJK65p+IwfKktaEeYcox5DUgPx+xCeq8IW8zJNLSMImxK7uss+fQaM9O1tgXHrCVJc
         s19XMZJL7Nc9+SzzitSwVwytehVEbvg2A7INJMTI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 23C2260C54
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
Subject: Re: [PATCH 1/6] brcmfmac: Remove firmware-loading code duplication
References: <20181009124755.25402-1-hdegoede@redhat.com>
        <c6dd19e3-58e2-2eb2-5724-e6718b3fb2cf@broadcom.com>
Date:   Mon, 05 Nov 2018 17:05:46 +0200
In-Reply-To: <c6dd19e3-58e2-2eb2-5724-e6718b3fb2cf@broadcom.com> (Arend van
        Spriel's message of "Mon, 5 Nov 2018 12:40:45 +0100")
Message-ID: <87a7mnbm45.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 10/9/2018 2:47 PM, Hans de Goede wrote:
>> brcmf_fw_request_next_item and brcmf_fw_request_done both have identical
>> code to complete the fw-request depending on the item-type.
>>
>> This commit adds a new brcmf_fw_complete_request helper removing this code
>> duplication.
>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

For some reason you commented on v1 but there was v2 posted already:

https://patchwork.kernel.org/patch/10634355/

I guess I can take v2 still?

-- 
Kalle Valo
