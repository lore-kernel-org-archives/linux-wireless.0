Return-Path: <SRS0=8PMz=6U=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D5EC4724C
	for <linux-wireless@archiver.kernel.org>; Wed,  6 May 2020 15:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4B322145D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 May 2020 15:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgEFPPO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 May 2020 11:15:14 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:60978 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728821AbgEFPPN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 May 2020 11:15:13 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id B51AB246E;
        Wed,  6 May 2020 15:15:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: bears23_ff76a315943a
X-Filterd-Recvd-Size: 2948
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Wed,  6 May 2020 15:15:09 +0000 (UTC)
Message-ID: <2208e464cd8bd399cfb9b49abb5aed211f27b3a8.camel@perches.com>
Subject: Re: [PATCH -next] iwlwifi: pcie: Use bitwise instead of arithmetic
 operator for flags
From:   Joe Perches <joe@perches.com>
To:     Luciano Coelho <luciano.coelho@intel.com>,
        Samuel Zou <zou_wei@huawei.com>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com,
        kvalo@codeaurora.org, davem@davemloft.net,
        Julia Lawall <julia.lawall@lip6.fr>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci <cocci@systeme.lip6.fr>
Date:   Wed, 06 May 2020 08:15:08 -0700
In-Reply-To: <bfd6b3a7db0c50cd3d084510bd43c9e540688edd.camel@intel.com>
References: <1588734423-33988-1-git-send-email-zou_wei@huawei.com>
         <f8b258e0c8bb073c445090e637195df2fc989543.camel@perches.com>
         <bfd6b3a7db0c50cd3d084510bd43c9e540688edd.camel@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-05-06 at 16:51 +0300, Luciano Coelho wrote:
> On Tue, 2020-05-05 at 20:19 -0700, Joe Perches wrote:
> > On Wed, 2020-05-06 at 11:07 +0800, Samuel Zou wrote:
> > > This silences the following coccinelle warning:
> > > 
> > > "WARNING: sum of probable bitmasks, consider |"
> > 
> > I suggest instead ignoring bad and irrelevant warnings.
> > 
> > PREFIX_LEN is 32 not 0x20 or BIT(5)
> > PCI_DUMP_SIZE is 352
> > 
> > > diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> > []
> > > @@ -109,9 +109,9 @@ void iwl_trans_pcie_dump_regs(struct iwl_trans *trans)
> > >  
> > >  	/* Alloc a max size buffer */
> > >  	alloc_size = PCI_ERR_ROOT_ERR_SRC +  4 + PREFIX_LEN;
> > > -	alloc_size = max_t(u32, alloc_size, PCI_DUMP_SIZE + PREFIX_LEN);
> > > -	alloc_size = max_t(u32, alloc_size, PCI_MEM_DUMP_SIZE + PREFIX_LEN);
> > > -	alloc_size = max_t(u32, alloc_size, PCI_PARENT_DUMP_SIZE + PREFIX_LEN);
> > > +	alloc_size = max_t(u32, alloc_size, PCI_DUMP_SIZE | PREFIX_LEN);
> > > +	alloc_size = max_t(u32, alloc_size, PCI_MEM_DUMP_SIZE | PREFIX_LEN);
> > > +	alloc_size = max_t(u32, alloc_size, PCI_PARENT_DUMP_SIZE | PREFIX_LEN);
> > >  
> > >  	buf = kmalloc(alloc_size, GFP_ATOMIC);
> > >  	if (!buf)
> 
> Yeah, those macros are clearly not bitmasks.  I'm dropping this patch.

Can the cocci script that generated this warning

scripts/coccinelle/misc/orplus.cocci

be dropped or improved to validate the likelihood that
the defines or constants used are more likely than
not are bit values?

Maybe these should be defined as hex or BIT or BIT_ULL
or GENMASK or the like?


Right now it seems it just tests for two constants.


