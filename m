Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 007C2C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 18:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2BAB20652
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 18:35:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aV/ashdm";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iBP4HOow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfDLSfu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 14:35:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43318 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbfDLSft (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 14:35:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 008B161701; Fri, 12 Apr 2019 18:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555094149;
        bh=Wwb8It2HETJoSRV7+S4jXh8n2MZR+fTTdFX4loFlQfc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=aV/ashdmJXONYjvQ/XBMEQTtUmDdZ0Haz6/x7d7as9yw9d8i6HbG/ybtTjCKsYOM7
         dBKwcgnZGmij1IXh7tJ7BSamWzxhyvXG0Ff6I2IFh3QIva346rjMEL1UA5op0LmuRU
         PdrF/O/nscE1RDFBFSZ7ji/nN8kOuwIRI9oUT8F0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E4BA616B7;
        Fri, 12 Apr 2019 18:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555094147;
        bh=Wwb8It2HETJoSRV7+S4jXh8n2MZR+fTTdFX4loFlQfc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iBP4HOowKW8FLL/orklAPfNnMbz8tXuK14/IsV6R9BxJgvymQN2ytjWaZoEqIdr/C
         DsR6d9KEuDp+FN7DM3V3DTKN3J8xUDSZzD2Pcpau9rJg8Z+6fRI8lXigUwK+Js9cT6
         DSRspQwnn4In2S42jR/k3+m75SqKHdnDt+YjRF88=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5E4BA616B7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Subject: Re: pull-request: iwlwifi-fixes 2019-04-03
References: <6f02ef035f948c9d01d66f52f84403caf2384001.camel@coelho.fi>
Date:   Fri, 12 Apr 2019 21:35:44 +0300
In-Reply-To: <6f02ef035f948c9d01d66f52f84403caf2384001.camel@coelho.fi> (Luca
        Coelho's message of "Wed, 03 Apr 2019 11:18:34 +0300")
Message-ID: <87r2a7cbr3.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> Hi Kalle,
>
> This is the second batch of fixes for v5.1.  More details about the
> contents in the tag description.
>
> I have sent this out before and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 4837696f6b5451242b2095764287b6336e844683:
>
>   Merge tag 'iwlwifi-for-kalle-2019-03-22' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2019-03-30 08:33:40 +0200)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2019-04-03
>
> for you to fetch changes up to debec2f23910cb17f2c0f6d5e30a8da00bb5f515:
>
>   iwlwifi: add support for quz firmwares (2019-04-03 11:13:06 +0300)
>
> ----------------------------------------------------------------
> Second batch of iwlwifi fixes intended for v5.1
>
> * fix for a potential deadlock in the TX path;
> * a fix for offloaded rate-control;
> * support new PCI HW IDs which use a new FW;
>
> ----------------------------------------------------------------

Pulled, thanks Luca.

-- 
Kalle Valo
