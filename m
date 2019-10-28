Return-Path: <SRS0=NkA/=YV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7B0CA9EA0
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Oct 2019 09:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2A8D21850
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Oct 2019 09:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WKz+T/W5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BdpVt/oh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387988AbfJ1JVP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Oct 2019 05:21:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53488 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731818AbfJ1JVO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Oct 2019 05:21:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1804D60AD7; Mon, 28 Oct 2019 09:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572254474;
        bh=VadqlEYYfxB7OwaJryx2n7rtLMjDQtS6L+9F+QovAbc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WKz+T/W5uKEyyW/O27wOpwhCdee/+JYZpj1lC8uhPHZeMV90qnZBEUU1hE1ATU3zx
         dvnwkzNs+ZpMRGQnPmacOBk/D9ImEwzBEuVUJTXBYeTaG8GQpAYL93+GkJZWlO/YD3
         9LamebTs+Mukr5XHg1mk2pqXAUuHOOuTay0smbYA=
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 245736078F;
        Mon, 28 Oct 2019 09:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572254472;
        bh=VadqlEYYfxB7OwaJryx2n7rtLMjDQtS6L+9F+QovAbc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BdpVt/ohSPBR7p2rO6SPXPW9cFEAK4uwm4aH6CJZR/v9kZuK6rWpRnmdFTQvQujEs
         4gvci4q/6+ySyXE/Ivj6B4mNKOWYeN+N8su3LLoY4EiR7Ah1cyAnR1DRl4hMr7933u
         UGuNnejw+TkYRIXHydpStd+SJZFa410ecaGvD1Ko=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 245736078F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     davem@davemloft.net, allison@lohutok.net,
        kstewart@linuxfoundation.org, opensource@jilayne.com,
        mcgrof@kernel.org, saurav.girepunje@gmail.com, tglx@linutronix.de,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
Subject: Re: [PATCH] net: wireless: broadcom: Fix use true/false for bool type variable.
References: <20191027042422.GA7956@saurav>
Date:   Mon, 28 Oct 2019 11:21:05 +0200
In-Reply-To: <20191027042422.GA7956@saurav> (Saurav Girepunje's message of
        "Sun, 27 Oct 2019 09:54:26 +0530")
Message-ID: <87wocp8bum.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(manually fixing the Cc field)

Saurav Girepunje <saurav.girepunje@gmail.com> writes:

> use true/false for bool type variables assignment.
>
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>

I don't see any of your three patches in linux-wireless list and hence
neither in patchwork:

https://patchwork.kernel.org/project/linux-wireless/list/?state=*

One reason might be the ';' character in the To field:

To: kvalo@codeaurora.org;, davem@davemloft.net;, allison@lohutok.net;,
	kstewart@linuxfoundation.org;, opensource@jilayne.com;,
	mcgrof@kernel.org;, saurav.girepunje@gmail.com;, tglx@linutronix.de
	;, linux-wireless@vger.kernel.org;, b43-dev@lists.infradead.org;,
	netdev@vger.kernel.org;, linux-kernel@vger.kernel.org;

Please fix that and resend all patches. Also the title prefix should be
'b43:':

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
