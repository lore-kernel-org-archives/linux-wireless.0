Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7B9C10F04
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 14:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09114222D4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 14:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390963AbfBNOCy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:02:54 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:39708 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388845AbfBNOCy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 09:02:54 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1guHbF-00035E-1R; Thu, 14 Feb 2019 22:02:49 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1guHb3-0000NE-37; Thu, 14 Feb 2019 22:02:37 +0800
Date:   Thu, 14 Feb 2019 22:02:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, johannes.berg@intel.com,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [v3 PATCH 0/4] mac80211: Fix incorrect usage of rhashtable walk API
Message-ID: <20190214140236.omt74prxhkfaasue@gondor.apana.org.au>
References: <20190213050551.x3jffq3ipghw6g2m@gondor.apana.org.au>
 <20190213143853.labj6zdcsoupkris@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213143853.labj6zdcsoupkris@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi:

v3 fixes a bug in patch two where we would return a NULL pointer
when we should return an existing path.

The first two patches in this series are bug fixes and should be
backported to stable.

They fixes a number of issues with the use of the rhashtable API
in mac80211.  First of all it converts the use of rashtable walks over
to a simple linked list.  This is because an rhashtable walk is
inherently unstable and not meant for uses that require stability,
e.g., when you're trying to lookup an object to delete.

It also fixes a potential memory leak when the rhashtable insertion
fails (which can occur due to OOM).

The third patch is a code-cleanup to mac80211 while the last patch
removes an obsolete rhashtable API.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
