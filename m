Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40225C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 09:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03CD720685
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 09:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IWM3pLq7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E9mToPlZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03CD720685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394471AbeKWU2n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 15:28:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53282 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390621AbeKWU2m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 15:28:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 251A761805; Fri, 23 Nov 2018 09:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542966311;
        bh=KgTgwfn6oJLuORyaOwV4ggCv8budLYOJF7toWsrPwiw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IWM3pLq7ZnAnwsE+1QIyGXOHvVbcfKrYulMr0rR0qZL7QyBCEYEJI9fSpb97Y3077
         MNbnr1XKptUDCejYWE210drQOoVqKgfh1POuh2GyK7Fc3IeunsywyuPZo+UmlDEbEo
         P4OFQWtqqWhTK4NhpQ0wfiwbljfIsVza4T/RyvK0=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A98F561609;
        Fri, 23 Nov 2018 09:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542966309;
        bh=KgTgwfn6oJLuORyaOwV4ggCv8budLYOJF7toWsrPwiw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=E9mToPlZW65P/qCN/Dbw7nxR+UgWlIcmVtxEB6RDPMrxsPRojOiTWTZ1n78ipol8+
         Xpty/llJhmfZdxa6m8va5oXfUZToizMN/99v8iuLDNrKWgRoB9fEG4bWGEVLjWfRKR
         J+0CP/KQxwgjZg2A9HTNkwEzUQn6GVw6OB7k3emM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A98F561609
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Peter Robinson <pbrobinson@gmail.com>
Subject: Re: [PATCH] brcmfmac: Call brcmf_dmi_probe before brcmf_of_probe
References: <20181123091148.12742-1-hdegoede@redhat.com>
Date:   Fri, 23 Nov 2018 11:45:04 +0200
In-Reply-To: <20181123091148.12742-1-hdegoede@redhat.com> (Hans de Goede's
        message of "Fri, 23 Nov 2018 10:11:48 +0100")
Message-ID: <87efbc9lgf.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> writes:

> ARM systems with UEFI may have both devicetree (of) and DMI data in this
> case we end up setting brcmf_mp_device.board_type twice.
>
> In this case we should prefer the devicetree data, because:
> 1) The devicerree data is more reliable
> 2) Some ARM systems (e.g. the Raspberry Pi 3 models) support both UEFI and
>    classic uboot booting, the devicetree data is always there, so using it
>    makes sure we ask for the same nvram file independent of how we booted.
>
> This commit moves the brcmf_dmi_probe call to before the brcmf_of_probe
> call, so that the latter can override the value of the first if both are
> set.
>
> Fixes: bd1e82bb420a ("brcmfmac: Set board_type from DMI on x86 based ...")
> Cc: Peter Robinson <pbrobinson@gmail.com>
> Tested-and-reported-by: Peter Robinson <pbrobinson@gmail.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Note to myself: commit bd1e82bb420a is on wireless-drivers-next so need
to queue for 4.20.

-- 
Kalle Valo
