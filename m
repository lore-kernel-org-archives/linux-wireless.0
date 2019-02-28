Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086B2C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB012184A
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:38:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EFaE7e5t";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Kg1IaLKm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbfB1IiA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:38:00 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57790 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730706AbfB1IiA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:38:00 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4D01D60909; Thu, 28 Feb 2019 08:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551343080;
        bh=m66Zxy/S/6LqNk6sM3gtygv7dwBHqJNSAPiOklnNLYQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EFaE7e5tD5SEJWP0pmDYL2gHr0apOA38LLFepS9thzcyVpcJrdiCnirTS++b70eQh
         bP/HZMc7j4n3FAsNGHMVA9rbhwG+r0FZTig623h/BachqydX2APPJRiGPKp8yFLLoI
         e02cLCHx3pxb2G607J7pMkRDXkK5yYiBe0oTlkss=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 68FC1608CE;
        Thu, 28 Feb 2019 08:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551343079;
        bh=m66Zxy/S/6LqNk6sM3gtygv7dwBHqJNSAPiOklnNLYQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Kg1IaLKmW99KLAKxsCMlffjAlWBmfsoPhGngNT8FEg/S4okW77w7Tbe+By4ChjbtY
         QrntYmtWL2fC5i+re4gUh/ohO00RN+7W/xq93c8+QprflN/Ya8fb6cqF4SRTTSjWNZ
         HAXVGnZcMcDP1E9nC3fHv5qXVCpGfEFhNk4hCZ0k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 68FC1608CE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Robert White <rwhite@pobox.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: long startup delay ath10k_pci known issue?
References: <53b7cbe9-f419-24c7-0f51-37f92e11df1d@pobox.com>
Date:   Thu, 28 Feb 2019 10:37:56 +0200
In-Reply-To: <53b7cbe9-f419-24c7-0f51-37f92e11df1d@pobox.com> (Robert White's
        message of "Thu, 28 Feb 2019 07:33:46 +0000")
Message-ID: <877edk1f6j.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Robert White <rwhite@pobox.com> writes:

> I recently switched from an ath9k to an ath10k on my (gentoo based)
> home-build router, and there is about a two minute delay between the
> time of the modprobe of ath10k_pci and the time "iw list" can see the
> wireless endpoint. Then there's maybe another delay before the wlan0
> device appears in the kernel.
>
> This extreme delay is preventing a normal startup because it causes an
> error return in the OpenRC dependency/startup logic.
>
> That dependency tree is it's own problem, of course, but I don't
> understand why the delay is taking place. There are no errors shown in
> the startup and the system runs fine once manually kicked around to
> get it running (e.g. manually modprobing the various devices and then
> waiting and then re-triggering various parts of the startup).
>
> I have to reiterate that the system starts and runs fine as-configured
> if I put the ath9k device back in, so it's not a system-level
> configuration problem.

ath9k PCI device does not retrieve firmware images from user space so I
would not yet rule out a system level problem.

> Is this long delay after module and firmware load some expected effect
> that I need to code around or what?

Usually these 60 second (or it's multiply) delays are caused by kernel
requesting a firmware image from user space but the corresponding user
space component is not replying and kernel waits for the reply until it
timeouts and continues. IIRC there's a kernel config option you can use
to disable this feature, or you could also try to fix the user space.

-- 
Kalle Valo
