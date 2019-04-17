Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C66C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 10:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94C3B2064A
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 10:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555498793;
	bh=EgoRb32YpxABqEBjzBuywiaipOwaXhMT4rxnt/jBOLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CZef542V3X4v8P9A4VTP/kVMswLM7DguN2pwAOxdAuVH2keGY62ZudcUEWqMfT4se
	 VALfcImruPpEGR/z2+Lg3ioKYEWsgbqO7snqkTz1M9d7wHK4dDSybkn6ya9X66yqwv
	 7MC1CcJ3Q7KojLHU8aBXCnx+RfQq6gWeJMYa54us=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731717AbfDQK7t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 06:59:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:35312 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726695AbfDQK7t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 06:59:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 986BEAE60;
        Wed, 17 Apr 2019 10:59:47 +0000 (UTC)
Date:   Wed, 17 Apr 2019 12:59:47 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>
Subject: Re: [PATCH] iwlwifi: don't panic in error path on non-msix systems
Message-ID: <20190417105947.GB5878@dhcp22.suse.cz>
References: <748205b02961167b0926d4afe8d9ad9cb37bf6ef.camel@coelho.fi>
 <20190417073516.24250-1-luca@coelho.fi>
 <20190417101102.GA5878@dhcp22.suse.cz>
 <3c1cb224613ac2cc3b20bfcf0c47e0df584c4e31.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c1cb224613ac2cc3b20bfcf0c47e0df584c4e31.camel@coelho.fi>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed 17-04-19 13:17:10, Luca Coelho wrote:
> On Wed, 2019-04-17 at 12:11 +0200, Michal Hocko wrote:
> > Hi,
> > which tree is this supposed to be applied on? It doesn't do apply on
> > top
> > of v5.1-rc4-3-gfd008d1a7a20. iwl_trans_pcie_sync_nmi doesn't exist in
> > drivers/net/wireless/intel/iwlwifi/pcie/trans.c. iwl_trans_sync_nmi
> > looks pretty similar. My patch massaging ended up with this. Please
> > double check. It compiles and even boots.
> 
> Ah, sorry, I didn't mention that that patch was supposed to apply on
> top of wireless-drivers-next, which is on its way to v5.2.  We have
> other patches touching this function there, thus the conflict.

This is hard to tell. I haven't seen any "Error sending SCAN_CFG_CMD:"
message in the kernel log yet and I believe this is related to the
crash. But I might be easily wrong here.

In any case, I suspect that those events usually happen in a different
wireless environment than I am running right now. So give me some more
time before I can be more confident with an answer.
-- 
Michal Hocko
SUSE Labs
