Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEBAC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 00:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB54A208A3
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 00:28:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Lp/3LFSk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB54A208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbeKOKeN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 05:34:13 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44382 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbeKOKeN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 05:34:13 -0500
Received: by mail-pg1-f195.google.com with SMTP id w3-v6so8123589pgs.11
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2018 16:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xDcXJoOQ5F7y6Q/prQq4ktSfFrEJQmkFtAaWAQBYbEw=;
        b=Lp/3LFSk4n5gt7rwUZJh1zfKrBhUPr5eRFWEE+yenCjcGQ8Op23XdVnOiNlsn3GPMa
         L5lXBcMuqEHjiNNspxTkDFVmcB0HaiY5n+qr7Vu8QFKw4wPZqK+/yiDB4PkDYb1MtHbc
         OTumq0N1tdYwjzUU/UZIpdhnqOxM1+3lOwJfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xDcXJoOQ5F7y6Q/prQq4ktSfFrEJQmkFtAaWAQBYbEw=;
        b=PQT8+ZIQVxNTCHzSSSazti6KUy7R914YPk7Ru2PumRxVPATpj4gQ3zrs76PVyzDlDH
         kT5eaPRasiuFmD3ERpe5Ul8Mql69RK4WqD/445+gIv47jK4r63Q+DOrKYOtuz8FfrOWw
         55MwkI8+XdHoP/d571CRldho260Y0tsr1rC5WMgLNmG/fknuPiCzxNKNxYmc4054+nBV
         jzHJ/bzzqpoLhZU0zH2bMWPESh2wHAW39LqTfeVtyOmpJZy8IVFG7TCKU+KNjlWHOy8j
         n3IrLSuVwPdhoes/r6pBfOkpy/PbM24crgHWrbfovnwzPrW0CQ8MzQwYUkeEAz3evmF4
         Mo8w==
X-Gm-Message-State: AGRZ1gJ+EYaOlSWqmp+nkVfysG4PXyqVo/iQEyGxrJ/QH2XpKOZAOtSn
        aTPFyY/2dTiJ9HfobqU0ZuVD7CCF4Gw=
X-Google-Smtp-Source: AJdET5d/eFLJRsUtjbnLXKXjwmR53g9qq5Wp3ugB0Jy8gFxzFRkUfY7frWSDAxJG5Js029WwqzcjPw==
X-Received: by 2002:a63:c0f:: with SMTP id b15mr3812135pgl.314.1542241719797;
        Wed, 14 Nov 2018 16:28:39 -0800 (PST)
Received: from google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id n65-v6sm29148512pfi.185.2018.11.14.16.28.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 14 Nov 2018 16:28:38 -0800 (PST)
Date:   Wed, 14 Nov 2018 16:28:36 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: support PCIe enter L1 state
Message-ID: <20181115002836.GA71934@google.com>
References: <1542163848-837-1-git-send-email-wgong@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542163848-837-1-git-send-email-wgong@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Wen,

On Wed, Nov 14, 2018 at 10:50:48AM +0800, Wen Gong wrote:
> QCA6174A/QCA9377 PCIe chips support PCIe L1 and L1SS, and indicate the
> L1/L1SS capabilities in PCI configuration space. Currently ath10k driver
> write target PCIe config flags to disallow HW enter into L1, this leads
> some HW modules are still powered up even when both system PCIe RC and
> QCA6174A/QCA9377 endpoint decides to enter into L1 or L1SS.
> 
> This cause ~12 mA power drain of bottom power consumption for all scenarios.
> Fix this issue by removing the drive code to write PCIe config flags.
> 
> Tested with QCA6174 PCI with firmware
> WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
> It's not a regression with new firmware releases.
> 
> Signed-off-by: Wen Gong <wgong@codeaurora.org>

Is there some reason L1 was disabled in the first place? Was it known to
be unreliable?

Brian
