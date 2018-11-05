Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DAEC0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C92C20862
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 09:02:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W0mTXqQt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W0mTXqQt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C92C20862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbeKESVP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 13:21:15 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50728 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbeKESVP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 13:21:15 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E193D6044B; Mon,  5 Nov 2018 09:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541408554;
        bh=y3Fkx/UYzJ5v7+iCc7BmW9gdprFvsXnZJg8ckuLlL6c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=W0mTXqQtHNzbPKJPL36axOAbH9c4ahoFtvIejiEyC7u/NWxkujrBzZx6zpZUuu/tH
         5f2b8GoWnjl6sNgJgnavAFOOudY036o4LlMJ2BfI0KqJsOT9yO4hSVdYKBcWQjiyxU
         zeCsooJOO894p6YfXgOJ5LEjitAByFDFZuaLXaPQ=
Received: from x230.qca.qualcomm.com (37-33-75-124.bb.dnainternet.fi [37.33.75.124])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 600336044B;
        Mon,  5 Nov 2018 09:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541408554;
        bh=y3Fkx/UYzJ5v7+iCc7BmW9gdprFvsXnZJg8ckuLlL6c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=W0mTXqQtHNzbPKJPL36axOAbH9c4ahoFtvIejiEyC7u/NWxkujrBzZx6zpZUuu/tH
         5f2b8GoWnjl6sNgJgnavAFOOudY036o4LlMJ2BfI0KqJsOT9yO4hSVdYKBcWQjiyxU
         zeCsooJOO894p6YfXgOJ5LEjitAByFDFZuaLXaPQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 600336044B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Priit Laes <plaes@plaes.org>, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
Subject: Re: [PATCH 0/5] Use common cordic algorithm for b43
References: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
        <87muqoar5i.fsf@purkki.adurom.net>
        <870a5f59-1031-c62d-0ee8-742bd0f16d8a@broadcom.com>
Date:   Mon, 05 Nov 2018 11:02:29 +0200
In-Reply-To: <870a5f59-1031-c62d-0ee8-742bd0f16d8a@broadcom.com> (Arend van
        Spriel's message of "Mon, 5 Nov 2018 09:17:40 +0100")
Message-ID: <87bm73hp7e.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 11/5/2018 9:02 AM, Kalle Valo wrote:
>> Also I don't see MAINTAINERS entry for cordic.[c|h], that would be good
>> to have as well.
>
> We added the cordic library functions during brcm80211 staging
> cleanup. We can add it to MAINTAINERS file.

Great, thanks.

-- 
Kalle Valo
