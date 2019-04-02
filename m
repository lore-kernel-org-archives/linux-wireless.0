Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91CA9C4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 12:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F5D72148E
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 12:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554206552;
	bh=K4u2wAx/yqm81xx9gpWJfh2wXCLG1JLXqfFIYdKgTpI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=blqk59Ora6m4Doo26zAsYcxucFurgRbBXcPyloCdI9zLKL4PNHBdZYMdBMgBduGQz
	 wNvkhVE6DN7DbH9jQXt+yvF22GVQJzD6EiFm2ffe2JI1q8WvSlkgCoCI4GgePJkpY/
	 7VzhAww9EqMCA32bGxY9rv+DVlDusOeyEDyYmV3o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbfDBMCb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 08:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbfDBMCb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 08:02:31 -0400
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C7092148E
        for <linux-wireless@vger.kernel.org>; Tue,  2 Apr 2019 12:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554206550;
        bh=K4u2wAx/yqm81xx9gpWJfh2wXCLG1JLXqfFIYdKgTpI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YyWJlUMOMHDl+pbcmodlEwZHyuaiCZ5bLl4nxXlwuvBJiphRBsDAMWHv9VbodsNg4
         DoEgaTwqhLOBGpm8p9WBAjY/73YxlK95A3ZgaMsJdJ5FI3dh61sLULcLd7d7ejRwJv
         hNrd9WuFIB3d6WjNz5K4gf4nxcrOd5G86NTNpbu8=
Received: by mail-qt1-f172.google.com with SMTP id z17so14537376qts.13
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 05:02:30 -0700 (PDT)
X-Gm-Message-State: APjAAAXB17+Cx2mIH/iczBUolTUvic/+fSAVQjCItG+UKlAH7mHC0TbX
        h43jkndgUKtccj3WFW2mvvJftaObtFu/BOHxin8=
X-Google-Smtp-Source: APXvYqz9GaKEroFADdmc1peKnYQ3aLaO7bzdEeKQiwWygXDEKOBKeKGQVDum3FYsu/njBY17wNmaIHfQ1G5cMMG33Zw=
X-Received: by 2002:ac8:f86:: with SMTP id b6mr59118874qtk.330.1554206549803;
 Tue, 02 Apr 2019 05:02:29 -0700 (PDT)
MIME-Version: 1.0
References: <2c5c234766af299124ffb330198cf23b0a693cbf.1553591027.git.ryder.lee@mediatek.com>
In-Reply-To: <2c5c234766af299124ffb330198cf23b0a693cbf.1553591027.git.ryder.lee@mediatek.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Tue, 2 Apr 2019 08:02:17 -0400
X-Gmail-Original-Message-ID: <CA+5PVA4Vx1oqUQBguMa2Q4SJrj070KepfM=-9zu-dG_ipPkfSg@mail.gmail.com>
Message-ID: <CA+5PVA4Vx1oqUQBguMa2Q4SJrj070KepfM=-9zu-dG_ipPkfSg@mail.gmail.com>
Subject: Re: [PATCH] linux-firmware: add firmware for MT7615E
To:     Ryder Lee <ryder.lee@mediatek.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Roy Luo <royluo@google.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Linux Firmware <linux-firmware@kernel.org>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 26, 2019 at 10:30 AM Ryder Lee <ryder.lee@mediatek.com> wrote:
>
> Add binary firmware for MT7615E based devices
>
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> ---
>  WHENCE                        |  13 +++++++++++++
>  mediatek/mt7615_cr4.bin       | Bin 0 -> 122644 bytes
>  mediatek/mt7615_n9.bin        | Bin 0 -> 459000 bytes
>  mediatek/mt7615_rom_patch.bin | Bin 0 -> 11102 bytes
>  4 files changed, 13 insertions(+)
>  create mode 100644 mediatek/mt7615_cr4.bin
>  create mode 100644 mediatek/mt7615_n9.bin
>  create mode 100644 mediatek/mt7615_rom_patch.bin

Applied and pushed out.  Thanks.

josh
