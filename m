Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5343FC282CE
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 13:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 226C4222C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 13:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388430AbfBMNmE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 08:42:04 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:33186 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731945AbfBMNmE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 08:42:04 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gtunW-0005kw-C3; Wed, 13 Feb 2019 21:41:58 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gtunA-0004Jz-MS; Wed, 13 Feb 2019 21:41:36 +0800
Date:   Wed, 13 Feb 2019 21:41:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, David Miller <davem@davemloft.net>,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, j@w1.fi, tgraf@suug.ch,
        johannes.berg@intel.com
Subject: Re: [PATCH] rhashtable: Remove obsolete rhashtable_walk_init function
Message-ID: <20190213134136.34wk53cn75f73366@gondor.apana.org.au>
References: <20190213053441.aoldwjnqm6ynshsk@gondor.apana.org.au>
 <201902131934.29Pw8ywP%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201902131934.29Pw8ywP%fengguang.wu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 13, 2019 at 07:20:51PM +0800, kbuild test robot wrote:
> Hi Herbert,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v5.0-rc4 next-20190212]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Herbert-Xu/rhashtable-Remove-obsolete-rhashtable_walk_init-function/20190213-182336
> config: x86_64-lkp (attached as .config)
> compiler: gcc-8 (Debian 8.2.0-20) 8.2.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    net/mac80211/mesh_pathtbl.c: In function '__mesh_path_lookup_by_idx':
> >> net/mac80211/mesh_pathtbl.c:256:8: error: implicit declaration of function 'rhashtable_walk_init'; did you mean 'rhashtable_walk_exit'? [-Werror=implicit-function-declaration]
>      ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
>            ^~~~~~~~~~~~~~~~~~~~
>            rhashtable_walk_exit
>    cc1: some warnings being treated as errors

This patch depends on a prior patch to mac80211.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
