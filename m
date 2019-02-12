Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAC5C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 12:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E3AE20823
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 12:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549975450;
	bh=rE+SJ0+cjY7knsiVE2R++ioAUtDa4S9P9LA6FhIAaeM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=rtre6petPhQ+3RVy8GuwPvzcxWGi2Rn4lhX4A2BdkrDM1cEX3DCeqk4Yfv1/dmSr+
	 dNn5dxPhDthe14/rCeYGtCpGgd+CN0YQMvhDK26cOG8bGEZNrf0/pJwmJBgzSuc4WT
	 WvX5DtdF+Pgd799giJtgYyyzI2SArRlfruimGPEE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbfBLMoJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 07:44:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbfBLMoJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 07:44:09 -0500
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EFA2217FA
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 12:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549975448;
        bh=rE+SJ0+cjY7knsiVE2R++ioAUtDa4S9P9LA6FhIAaeM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GdvlMh8YnYCj23/2gHOKKRzVeR8ogDeqDY4ADaj0go0d4KDN4lx9zejGjHjDupsTY
         h3hoTtF82fHuiR3l5nmhxOPapQCSLnfPetNKMdwaVO6KjIsTYtyXBFIqcZgVKfH2t5
         UfGYuz+bpLXiLhqEoPpTt7W476GNFnH/Wjj/WCYg=
Received: by mail-qt1-f182.google.com with SMTP id n32so2663760qte.11
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 04:44:08 -0800 (PST)
X-Gm-Message-State: AHQUAubGUQ5L2ZaUtw7iJbb5V8CGmiZRYYrfJyffIxAHxVpT7X4tZujC
        022f9v/mltQl5fsrAjdXhTkMNiemiC5FLDV2nvQ=
X-Google-Smtp-Source: AHgI3IYajeXMjQm3NKQTSpR/aB6x+SQCR1yPBSjRk5zRUfk14ylqkBKanc8giiJVE3PBQEfNP7vbOCPuAjCzdBt09x4=
X-Received: by 2002:ac8:23aa:: with SMTP id q39mr2554897qtq.82.1549975447180;
 Tue, 12 Feb 2019 04:44:07 -0800 (PST)
MIME-Version: 1.0
References: <1549035547599.95403@qca.qualcomm.com>
In-Reply-To: <1549035547599.95403@qca.qualcomm.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Tue, 12 Feb 2019 07:43:56 -0500
X-Gmail-Original-Message-ID: <CA+5PVA5cO9vpLjKezoTiBUOrZwL9tPnY9G66zC9gM9hb=CgTTQ@mail.gmail.com>
Message-ID: <CA+5PVA5cO9vpLjKezoTiBUOrZwL9tPnY9G66zC9gM9hb=CgTTQ@mail.gmail.com>
Subject: Re: [PULL] ath10k firmware 2019-02-01
To:     Kalle Valo <kvalo@qca.qualcomm.com>
Cc:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Feb 1, 2019 at 10:41 AM Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>
> Hi,
>
> here are few ath10k firmware updates, please pull.
>
> Kalle
>
> The following changes since commit a8b75cac06f80dc1500ba385680ac5b5c1d1c4f8:
>
>   Merge tag 'add-rpi-fw' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/matthias.bgg/linux-firmware (2019-01-18 07:04:02 -0500)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/linux-firmware.git ath10k-20190201
>
> for you to fetch changes up to 6b5e23a113704867df5205f31f02ffbc3ec4453e:
>
>   ath10k: QCA9984 hw1.0: update firmware-5.bin to 10.4-3.9.0.2-00021 (2019-02-01 17:22:55 +0200)
>
> ----------------------------------------------------------------
> Kalle Valo (4):
>       ath10k: QCA6174 hw3.0: update board-2.bin
>       ath10k: QCA9888 hw2.0: update firmware-5.bin to 10.4-3.9.0.2-00024
>       ath10k: QCA988X hw2.0: update firmware-5.bin to 10.2.4-1.0-00043
>       ath10k: QCA9984 hw1.0: update firmware-5.bin to 10.4-3.9.0.2-00021
>
>  WHENCE                              |   6 +++---
>  ath10k/QCA6174/hw3.0/board-2.bin    | Bin 551128 -> 567608 bytes
>  ath10k/QCA9888/hw2.0/firmware-5.bin | Bin 675492 -> 688536 bytes
>  ath10k/QCA988X/hw2.0/firmware-5.bin | Bin 248200 -> 248840 bytes
>  ath10k/QCA9984/hw1.0/firmware-5.bin | Bin 662084 -> 676316 bytes
>  5 files changed, 3 insertions(+), 3 deletions(-)

Pulled and pushed out.  Thanks.

josh
