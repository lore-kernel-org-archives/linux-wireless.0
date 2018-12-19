Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDF9C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 10:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B422E21873
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 10:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbeLSK1n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 05:27:43 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42964 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726812AbeLSK1m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 05:27:42 -0500
Received: from 201-0-74-183.dsl.telesp.net.br ([201.0.74.183] helo=dubbel)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gZZ4c-00057o-2P; Wed, 19 Dec 2018 12:27:31 +0200
Message-ID: <1ce59aaf30aaa9f59fc84c68a9e83299df0d4af8.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Sharon, Sara" <sara.sharon@intel.com>,
        Kees Cook <keescook@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Date:   Wed, 19 Dec 2018 08:27:22 -0200
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB3013375F96C@HASMSX112.ger.corp.intel.com>
References: <20181130120555.1d35eb6b@canb.auug.org.au>
         <20181219134738.4efed34f@canb.auug.org.au>
         <871s6evtra.fsf@kamboji.qca.qualcomm.com>
         <0BA3FCBA62E2DC44AF3030971E174FB3013375F96C@HASMSX112.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: linux-next: build warnings after merge of the
 wireless-drivers-next tree
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-12-19 at 08:31 +0000, Grumbach, Emmanuel wrote:
> > Stephen Rothwell <sfr@canb.auug.org.au> writes:
> > 
> > > On Fri, 30 Nov 2018 12:05:55 +1100 Stephen Rothwell
> > <sfr@canb.auug.org.au> wrote:
> > > > After merging the wireless-drivers-next tree, today's linux-next
> > > > build
> > > > (x86_64 allmodconfig) produced these warnings:
> > > > 
> > > > drivers/net/wireless/intel/iwlwifi/iwl-drv.c: In function
> > 'iwl_parse_tlv_firmware':
> > > > drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1098:7: warning: this
> > statement may fall through [-Wimplicit-fallthrough=]
> > > >     if (iwlwifi_mod_params.enable_ini)
> > > >        ^
> > > > drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1100:3: note: here
> > > >    default:
> > > >    ^~~~~~~
> > > > drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c: In function
> > 'iwl_parse_fw_dbg_tlv':
> > > > drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:203:4: warning: this
> > statement may fall through [-Wimplicit-fallthrough=]
> > > >     iwl_fw_dbg_copy_tlv(trans, tlv, true);
> > > >     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:204:3: note: here
> > > >    default:
> > > >    ^~~~~~~
> > > > 
> > > > Introduced by commit
> > > > 
> > > >   f14cda6f3b31 ("iwlwifi: trans: parse and store debug ini TLVs")
> > > > 
> > > > These are noted because I use -Wimplict-fallthrough
> > > > 
> > > > The warnings can be suppressed by adding a comment like
> > > > 	/* fall through */
> > > > at the appropriate place to indicate that the fallthough is intended.
> > > 
> > > I am still seeing these warnings (but in the net-next tree now) and I
> > > do not see a fix patch in the wireless-drivers-next tree.
> > 
> > Luca did submit a patch[1] for cfg80211 to fix those but I don't see any
> > patches for iwlwifi (even in the one pending pull request he sent), not sure
> > what happened. I know that Luca is already on holidays but adding
> > Emmanuel, maybe he can help here?
> > 
> 
> Just sent a patch.

Those patches were still queued for upstreaming and I didn't think they
were that urgent, so I didn't pick them.

--
Luca.

