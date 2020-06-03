Return-Path: <SRS0=zppH=7Q=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76138C433E0
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jun 2020 17:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5727E2053B
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jun 2020 17:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgFCRrz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Jun 2020 13:47:55 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:35918 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgFCRry (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jun 2020 13:47:54 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id D637ACED2E;
        Wed,  3 Jun 2020 19:57:39 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 0/4] marvell: Fix firmware filenames for sd8977/sd8997
 chipsets
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200603082229.15043-1-pali@kernel.org>
Date:   Wed, 3 Jun 2020 19:47:51 +0200
Cc:     Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?Q?Marek_Beh=C3=BAn?= <marek.behun@nic.cz>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Hemantkumar Suthar <shemant@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>, Cathy Luo <cluo@marvell.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <3159E2B0-8B61-42AC-8DBC-BC036B809A85@holtmann.org>
References: <20200603082229.15043-1-pali@kernel.org>
To:     =?utf-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Pali,

> This patch series fixes mwifiex and btmrvl drivers to load firmware for sd8977
> and sd8997 chipsets from correct filename.
> 
> Both Marvell distribution package and linux-firmware repository [1] contain
> firmware for these chipsets in files sdsd8977_combo_v2.bin/sdsd8997_combo_v4.bin.
> 
> Linux drivers mwifiex and btmrvl try to load firmware for these chipsets from
> sd8977_uapsta.bin/sd8997_uapsta.bin files which obviously fails as these files
> do not exist neither in linux-firmware [1] nor in Marvell distribution packages.
> 
> So the result is that Marvell sd8977 and sd8997 chipsets via mainline kernel
> drivers (mwifiex and btmrvl) do not work out of box.
> 
> Each patch in this series fixes particular git commit which introduced usage
> of incorrect firmware filename. Also each patch contains Fixes: line for easier
> backporting to stable kernels.
> 
> mwifiex (1/4, 2/4) and btmrvl (3/4, 4/4) parts of this patch series can be
> applied separately via wireless and bluetooth trees. I'm sending all four
> patches in one patch series for easier review.
> 
> [1] - https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/mrvl
> 
> Pali Rohár (4):
>  mwifiex: Fix firmware filename for sd8977 chipset
>  mwifiex: Fix firmware filename for sd8997 chipset
>  btmrvl: Fix firmware filename for sd8977 chipset
>  btmrvl: Fix firmware filename for sd8997 chipset
> 
> drivers/bluetooth/btmrvl_sdio.c             | 8 ++++----
> drivers/net/wireless/marvell/mwifiex/sdio.h | 4 ++--
> 2 files changed, 6 insertions(+), 6 deletions(-)

all 4 patches have been applied to bluetooth-next tree.

Regards

Marcel

