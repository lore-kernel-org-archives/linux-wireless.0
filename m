Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D746C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 23:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D271A21473
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 23:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbfA3XwC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 18:52:02 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53032 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727882AbfA3Xvx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 18:51:53 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gozdy-0004Ei-6E; Thu, 31 Jan 2019 01:51:46 +0200
Message-ID: <9455f1b9e746f2c28d1573ccdce3836ece42cd8a.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Date:   Thu, 31 Jan 2019 01:51:44 +0200
In-Reply-To: <20190131104626.62ff05ce@canb.auug.org.au>
References: <20190131104626.62ff05ce@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: linux-next: build warning after merge of the
 wireless-drivers-next tree
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-01-31 at 10:46 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the wireless-drivers-next tree, today's linux-next
> build
> (x86_64 allmodconfig) produced this warning:
> 
> drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:195:13: warning:
> 'iwl_mvm_add_rtap_sniffer_config' defined but not used [-Wunused-
> function]
>  static void iwl_mvm_add_rtap_sniffer_config(struct iwl_mvm *mvm,
>              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Introduced by commit
> 
>   9bf13bee2d74 ("iwlwifi: mvm: include configured sniffer AID in
> radiotap")

This was a conflict resolution damage in one of the patches I applied. 
We already have a fix for it[1] and Kalle will apply it to wireless-
drivers-next soon.

Sorry for the trouble, but somehow I didn't see this warning and
kbuildbot also reported successful compilation with it. :(

[1] https://patchwork.kernel.org/patch/10788503/

--
Cheers,
Luca.

