Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D5FC282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 10:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD00620821
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 10:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731613AbfDQKxU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 06:53:20 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53620 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730926AbfDQKxU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 06:53:20 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hGiBo-0006mf-0t; Wed, 17 Apr 2019 13:53:16 +0300
Message-ID: <35ea453e008e57436bd9965a2ceed70114ec7644.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>
Date:   Wed, 17 Apr 2019 13:53:14 +0300
In-Reply-To: <3c1cb224613ac2cc3b20bfcf0c47e0df584c4e31.camel@coelho.fi>
References: <748205b02961167b0926d4afe8d9ad9cb37bf6ef.camel@coelho.fi>
         <20190417073516.24250-1-luca@coelho.fi>
         <20190417101102.GA5878@dhcp22.suse.cz>
         <3c1cb224613ac2cc3b20bfcf0c47e0df584c4e31.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: don't panic in error path on non-msix systems
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-17 at 13:17 +0300, Luca Coelho wrote:
> On Wed, 2019-04-17 at 12:11 +0200, Michal Hocko wrote:
> > Hi,
> > which tree is this supposed to be applied on? It doesn't do apply
> > on
> > top
> > of v5.1-rc4-3-gfd008d1a7a20. iwl_trans_pcie_sync_nmi doesn't exist
> > in
> > drivers/net/wireless/intel/iwlwifi/pcie/trans.c. iwl_trans_sync_nmi
> > looks pretty similar. My patch massaging ended up with this. Please
> > double check. It compiles and even boots.
> 
> Ah, sorry, I didn't mention that that patch was supposed to apply on
> top of wireless-drivers-next, which is on its way to v5.2.  We have
> other patches touching this function there, thus the conflict.

Huh, I was confused.  My patch actually applies on top of wireless-
drivers, which has other patches that touch the same function on their
way to v5.1 (but not there yet).

--
Luca.

