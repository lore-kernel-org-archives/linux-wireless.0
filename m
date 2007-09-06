Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2274 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755488AbXIFMij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 08:38:39 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: johannes@sipsolutions.net (Johannes Berg)
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
Cc: herbert@gondor.apana.org.au, satyam@infradead.org, flo@rfc822.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
	ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com,
	flamingice@sourmilk.net
In-Reply-To: <1189080575.28781.65.camel@johannes.berg>
Message-Id: <E1ITGb2-0006Be-00@gondolin.me.apana.org.au>
Date: Thu, 06 Sep 2007 20:36:32 +0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hah, I suspected as much but didn't have a chance to look yet. I had
> plans to replace that sub_if_list with an RCU list and not require the
> lock there, but that's far off. Any ideas how to fix this? We can't
> reject the master stop so we have to walk the list, I guess we'll have
> to audit the other list manipulation places, I think they're all under
> RTNL.

Yeah I think they're all under RTNL too.  So you don't need to
take the lock here at all since you should already have the RTNL.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
