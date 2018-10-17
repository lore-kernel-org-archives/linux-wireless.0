Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A005FECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 13:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6480F204EC
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 13:29:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="et2LJDwi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6480F204EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbeJQVY5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 17:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbeJQVY5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 17:24:57 -0400
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00969204EC
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2018 13:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539782954;
        bh=LzCje4B8QiI0CujTBfqBPLOlkCod6ajEX+QHvxxMj7o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=et2LJDwiOCVmd+keM0ivtIQtdbZnHwXMHSGlUg2Sc5fKeL4dajfcWPFLlXBMga5Gb
         qW7WHkJh1uT5+8RGNCgmOTy4EHViKhIovWqpdR3yuuLVZ63BBvdlc8dbrQ0hq03gry
         ABcykBBfrd/wF1lLrXtBWPYKImzY69brVcFdXtwo=
Received: by mail-qk1-f169.google.com with SMTP id q5-v6so16429668qki.6
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2018 06:29:13 -0700 (PDT)
X-Gm-Message-State: ABuFfohTrs/rijcp9xEQrDPdDYFnAoiINCHgNJ1rVRo89k2qGJCD/dq+
        LLt/kXcHLpN8JTYKSCKpEs0XWlfDDiwy3SuL+aY=
X-Google-Smtp-Source: ACcGV62udXn7ctoWt/z/P1BxDqAcEtRjCFReneMlhrNj8hL6HmLzdkle1k6sSws6dCvfTZj0RLoMG9BRjiA6MZFHyi0=
X-Received: by 2002:a37:542:: with SMTP id 63-v6mr24281662qkf.281.1539782953175;
 Wed, 17 Oct 2018 06:29:13 -0700 (PDT)
MIME-Version: 1.0
References: <87ftxevtek.fsf@codeaurora.org>
In-Reply-To: <87ftxevtek.fsf@codeaurora.org>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Wed, 17 Oct 2018 09:29:01 -0400
X-Gmail-Original-Message-ID: <CA+5PVA48AzPShnZYcbw-j-DaydOt6U+eDU0o+tN=gf_4vBojdQ@mail.gmail.com>
Message-ID: <CA+5PVA48AzPShnZYcbw-j-DaydOt6U+eDU0o+tN=gf_4vBojdQ@mail.gmail.com>
Subject: Re: [PULL] ath10k firmware 2018-10-10
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 10, 2018 at 9:11 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Hi linux-firmware maintainers,
>
> here are ath10k firmware updates which have been accumulating the last 6
> months or so. Please let me know if there are any problems.
>
> Kalle
>
> The following changes since commit c6b6265d718d118e28e1ce8f91769aa886b54c94:
>
>   Merge tag 'iwlwifi-fw-2018-10-03' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware (2018-10-08 09:23:53 -0400)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/linux-firmware.git ath10k-20181010
>
> for you to fetch changes up to eaceb79a5a27ef37f85d1a5585b209361330b4bb:
>
>   ath10k: QCA9984 hw1.0: update board-2.bin (2018-10-10 15:14:05 +0300)
>
> ----------------------------------------------------------------
> Kalle Valo (10):
>       ath10k: QCA4019 hw1.0: update firmware-5.bin to 10.4-3.6-00140
>       ath10k: QCA4019 hw1.0: update board-2.bin
>       ath10k: QCA6174 hw3.0: update firmware-6.bin to RM.4.4.1.c2-00057-QCARMSWP-1
>       ath10k: QCA9377 hw1.0: add firmware-6.bin to WLAN.TF.2.1-00021-QCARMSWP-1
>       ath10k: QCA9887 hw1.0: update firmware-5.bin to 10.2.4-1.0-00041
>       ath10k: QCA9888 hw2.0: update firmware-5.bin to 10.4-3.6-00140
>       ath10k: QCA9888 hw2.0: update board-2.bin
>       ath10k: QCA988X hw2.0: update firmware-5.bin to 10.2.4-1.0-00041
>       ath10k: QCA9984 hw1.0: update firmware-5.bin to 10.4-3.6.0.1-00003
>       ath10k: QCA9984 hw1.0: update board-2.bin
>
>  WHENCE                                            |   15 +-
>  ath10k/QCA4019/hw1.0/board-2.bin                  |  Bin 133452 -> 449316 bytes
>  ath10k/QCA4019/hw1.0/firmware-5.bin               |  Bin 568636 -> 583344 bytes
>  ath10k/QCA6174/hw3.0/firmware-6.bin               |  Bin 730788 -> 731276 bytes
>  ath10k/QCA6174/hw3.0/notice_ath10k_firmware-6.txt |  502 +-------
>  ath10k/QCA9377/hw1.0/firmware-6.bin               |  Bin 0 -> 751436 bytes
>  ath10k/QCA9377/hw1.0/notice_ath10k_firmware-6.txt | 1352 +++++++++++++++++++++
>  ath10k/QCA9887/hw1.0/firmware-5.bin               |  Bin 237584 -> 237660 bytes
>  ath10k/QCA9888/hw2.0/board-2.bin                  |  Bin 72788 -> 84928 bytes
>  ath10k/QCA9888/hw2.0/firmware-5.bin               |  Bin 659708 -> 675492 bytes
>  ath10k/QCA988X/hw2.0/firmware-5.bin               |  Bin 248108 -> 248200 bytes
>  ath10k/QCA9984/hw1.0/board-2.bin                  |  Bin 121264 -> 171916 bytes
>  ath10k/QCA9984/hw1.0/firmware-5.bin               |  Bin 647380 -> 662084 bytes
>  13 files changed, 1423 insertions(+), 446 deletions(-)
>  create mode 100644 ath10k/QCA9377/hw1.0/firmware-6.bin
>  create mode 100644 ath10k/QCA9377/hw1.0/notice_ath10k_firmware-6.txt

Pulled and pushed out.  Thanks.

josh
