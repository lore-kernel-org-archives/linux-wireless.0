Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE113C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 16:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 481E72133F
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 16:06:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R+YqVqvI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="K2B+G7s/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbeLRQG1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 11:06:27 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36764 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbeLRQG1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 11:06:27 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C5E3560159; Tue, 18 Dec 2018 16:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545149185;
        bh=6rzJSVKjvsRn3iAsce3KHioPcpH7V2AV1v9ocUYPvkE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=R+YqVqvIz6SrQmrLh4fCkJM7gMr02aFCaYStVDVzEPO2UeiYhuACcwnv5pXfXTlhg
         XZqyyF0UYvJFdKnynCub15PhT7eWQckXdfe6wQ4M69U63i2E0PVi9ydXxSn0waiJeU
         Xds9Wy0UGrSm0Q//813M+JpT8iX6dagcCYmSzGkM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F3FEF6014B;
        Tue, 18 Dec 2018 16:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545149185;
        bh=6rzJSVKjvsRn3iAsce3KHioPcpH7V2AV1v9ocUYPvkE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=K2B+G7s/iKgrJoXWZF0d8eoQd0tTH0RVZU18yDARigJjKfAmT3EDW0tEQwlUrGkib
         l+2LSWAyotvxpx2A3umyZM2ILp9FSN9zUMTW/1mMsbl4gdwucvmg9cvm70TeR5GLxN
         U1nxel8ijcnUxClH+iXrBJJkBgZG/Ljx0BEpxFdI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F3FEF6014B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: pull-request: iwlwifi-next 2018-12-17
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1308b769a03aab069c43161d66047274ef8b6fc7.camel@coelho.fi>
References: <1308b769a03aab069c43161d66047274ef8b6fc7.camel@coelho.fi>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181218160625.C5E3560159@smtp.codeaurora.org>
Date:   Tue, 18 Dec 2018 16:06:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> Hi Kalle,
> 
> This is the fourth batch of patches intended for v4.21.  This includes
> only the last patchset I sent.  Usual development work.  More details
> about the contents in the tag description.
> 
> I have sent this out before and kbuildbot reported success.
> 
> Please let me know if there are any issues.
> 
> Cheers,
> Luca.
> 
> 
> The following changes since commit 30ed3c6c0922a1f67c3409b9e81087442614db7b:
> 
>   Merge tag 'iwlwifi-next-for-kalle-2018-12-14' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2018-12-14 16:58:00 +0200)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2018-12-17
> 
> for you to fetch changes up to 04a70797e208337775c6a1905699e4970ed17f8b:
> 
>   iwlwifi: bump the API version to 43 for 9000 and 22000 (2018-12-17 23:07:30 -0200)
> 
> ----------------------------------------------------------------
> Fourth batch of iwlwifi patches intended for v4.21
> 
> * Support for FW version 43 for 9000 and 22000 series;
> * A couple of janitorial fixes from the community;
> * More fixes in the 802.11ax code;
> * Other cleanups and small fixes;
> 
> ----------------------------------------------------------------
> Colin Ian King (1):
>       iwlwifi: mvm: fix spelling mistake "Recieved" -> "Received"
> 
> Emmanuel Grumbach (1):
>       iwlwifi: mvm: set TWT responder capability bit in 11AX SoftAP mode
> 
> Gustavo A. R. Silva (1):
>       iwlwifi: mvm: d3: use struct_size() in kzalloc()
> 
> Luca Coelho (3):
>       [BUGFIXiwlwifi: make MVM and DVM depend on MAC80211
>       iwlwifi: remove unused and wrong PHY_CFG_* macros
>       iwlwifi: bump the API version to 43 for 9000 and 22000
> 
> Naftali Goldstein (1):
>       iwlwifi: mvm: fix setting HE ppe FW config
> 
> Sara Sharon (8):
>       iwlwifi: pcie: use iwl_tx_cmd_gen2 and not iwl_tx_cmd
>       iwlwifi: mvm: remove dead code
>       iwlwifi: mvm: remove pointless NULL assignment
>       iwlwifi: mvm: cleanup iwl_mvm_tx_skb_non_sta
>       iwlwifi: mvm: take station lock later in the code
>       iwlwifi: pcie: lock txq a bit later in reclaim code
>       iwlwifi: mvm: clean up SSN incrementation
>       iwlwifi: dbg: add debug data to warning
> 
> Shahar S Matityahu (1):
>       iwlwifi: wrt: add rt status and num of rx/tx fifos to dump
> 
> Shaul Triebitz (2):
>       iwlwifi: split HE capabilities between AP and STA
>       iwlwifi: mvm: handle RX no data notification
> 
>  drivers/net/wireless/intel/iwlwifi/Kconfig           |   4 ++-
>  drivers/net/wireless/intel/iwlwifi/cfg/22000.c       |   2 +-
>  drivers/net/wireless/intel/iwlwifi/cfg/9000.c        |   2 +-
>  drivers/net/wireless/intel/iwlwifi/fw/api/config.h   |  13 ++------
>  drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h |   5 +++
>  drivers/net/wireless/intel/iwlwifi/fw/api/mac.h      |   2 +-
>  drivers/net/wireless/intel/iwlwifi/fw/api/rx.h       |  49 ++++++++++++++++++++++++++++
>  drivers/net/wireless/intel/iwlwifi/fw/dbg.c          |   4 ++-
>  drivers/net/wireless/intel/iwlwifi/fw/dbg.h          |   1 +
>  drivers/net/wireless/intel/iwlwifi/fw/error-dump.h   |   3 ++
>  drivers/net/wireless/intel/iwlwifi/fw/runtime.h      |   1 +
>  drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c   | 290 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------
>  drivers/net/wireless/intel/iwlwifi/mvm/d3.c          |   6 ++--
>  drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c    |  10 ++++--
>  drivers/net/wireless/intel/iwlwifi/mvm/mvm.h         |   2 ++
>  drivers/net/wireless/intel/iwlwifi/mvm/ops.c         |   2 ++
>  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        | 126 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/net/wireless/intel/iwlwifi/mvm/sta.c         |  10 +++---
>  drivers/net/wireless/intel/iwlwifi/mvm/tx.c          |  56 +++++++++++---------------------
>  drivers/net/wireless/intel/iwlwifi/mvm/utils.c       |   3 ++
>  drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c    |   2 +-
>  drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |   3 +-
>  22 files changed, 427 insertions(+), 169 deletions(-)

For some reason I got two identical pull requests, I'll drop this one
(the latter).

Patch set to Superseded.

-- 
https://patchwork.kernel.org/patch/10735283/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

