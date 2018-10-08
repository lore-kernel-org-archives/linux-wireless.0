Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F25C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4C6A20858
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:25:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="UjShXq3N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4C6A20858
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbeJHUhS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 16:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbeJHUhS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 16:37:18 -0400
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E900520882
        for <linux-wireless@vger.kernel.org>; Mon,  8 Oct 2018 13:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539005135;
        bh=smRGdgNaFRWEaAMCSFYKSlwpEkZRQP1VeWPiLsQvlIM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UjShXq3NsRh//5aUyNn/nQrjQp9Up+v8BMc32r2hKEs+y9hPmZ0cemoeZzsobBLbn
         U9hOZ9RHtIWE8+IbZeI8zyVt9snOnOjE5+GT60zlw4GvmNQ9qtD23gFPW6T7RBkQRm
         TozIKqUTvI5rWBkbKAG2OrSt8YKtNtMTNIVcGiRM=
Received: by mail-qk1-f170.google.com with SMTP id q5-v6so12020103qki.6
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 06:25:34 -0700 (PDT)
X-Gm-Message-State: ABuFfoij97hvWAWoHAypf3cqn2jnxhOGEITUqt28mLtx/t5+a3xZmvmv
        TK+XdxnYMiSrnZ+1unGRsuNZIkDKqc2MCEcVj+g=
X-Google-Smtp-Source: ACcGV63jJXSXf2PPAFKd1/5zN+W3n9egT3nAWxrMXGF2ovbSZHRVs+uHDOMEYX+SLTkprwIVnVU7k9BYnzjezfdOoIg=
X-Received: by 2002:a37:b6c5:: with SMTP id g188-v6mr18034731qkf.188.1539005134089;
 Mon, 08 Oct 2018 06:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <9ea7a802cbf547ca44b604e2b13bd6a1030bbb2b.camel@coelho.fi>
In-Reply-To: <9ea7a802cbf547ca44b604e2b13bd6a1030bbb2b.camel@coelho.fi>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Mon, 8 Oct 2018 09:25:23 -0400
X-Gmail-Original-Message-ID: <CA+5PVA53+ab0X5bX6-tCta1zfJsJKBxuZU1Gmu8FLR-4M4iyrw@mail.gmail.com>
Message-ID: <CA+5PVA53+ab0X5bX6-tCta1zfJsJKBxuZU1Gmu8FLR-4M4iyrw@mail.gmail.com>
Subject: Re: pull-request: iwlwifi firmwares update 2018-10-03
To:     Luca Coelho <luca@coelho.fi>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        Kyle McMartin <kyle@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        emmanuel.grumbach@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 3, 2018 at 3:54 AM Luca Coelho <luca@coelho.fi> wrote:
>
> Hi,
>
> We have updated all the firmwares we currently support.
>
> Please pull or let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 7c81f23ad903f72e87e2102d8f52408305c0f7a2:
>
>   ti-connectivity: add firmware for CC2560(A) Bluetooth (2018-10-01 10:08:30 -0400)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git tags/iwlwifi-fw-2018-10-03
>
> for you to fetch changes up to da110f2f392ab0f9a4e3cc35402b1f3e2c58127f:
>
>   iwlwifi: add -41.ucode firmwares for 9000 series (2018-10-03 10:08:09 +0300)
>
> ----------------------------------------------------------------
> iwlwifi: updata all currently supported FWs
>
> * Update FWs for 3160, 7260 and 7265;
> * Update FWs for 3168 and 7265D;
> * Update FWs for 8000C and 8265;
> * Update FWs for 9000 and 9260.
>
> ----------------------------------------------------------------
> Emmanuel Grumbach (2):
>       iwlwifi: update firmwares for 9000 series
>       iwlwifi: add -41.ucode firmwares for 9000 series
>
> Luca Coelho (1):
>       iwlwifi: update firmwares for 7000, 8000 and 9000 series
>
>  WHENCE                            |  20 +++++++++++++-------
>  iwlwifi-3160-17.ucode             | Bin 918268 -> 918268 bytes
>  iwlwifi-7260-17.ucode             | Bin 1049340 -> 1049340 bytes
>  iwlwifi-7265-17.ucode             | Bin 1180412 -> 1180412 bytes
>  iwlwifi-8000C-36.ucode            | Bin 2486572 -> 2486572 bytes
>  iwlwifi-8265-36.ucode             | Bin 2498044 -> 2498044 bytes
>  iwlwifi-9000-pu-b0-jf-b0-38.ucode | Bin 2520568 -> 2520568 bytes
>  iwlwifi-9000-pu-b0-jf-b0-41.ucode | Bin 0 -> 2961864 bytes
>  iwlwifi-9260-th-b0-jf-b0-38.ucode | Bin 2521412 -> 2521412 bytes
>  iwlwifi-9260-th-b0-jf-b0-41.ucode | Bin 0 -> 2620368 bytes
>  10 files changed, 13 insertions(+), 7 deletions(-)
>  create mode 100644 iwlwifi-9000-pu-b0-jf-b0-41.ucode
>  create mode 100644 iwlwifi-9260-th-b0-jf-b0-41.ucode

Pulled and pushed out.

josh
