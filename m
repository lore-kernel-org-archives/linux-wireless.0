Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:29056 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYDRNNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 09:13:52 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] libertas: Fix ethtool statistics
Date: Fri, 18 Apr 2008 15:10:53 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
References: <1208448814.9212.270.camel@pmac.infradead.org> <200804181149.41838.hs4233@mail.mn-solutions.de> <1208517302.9212.324.camel@pmac.infradead.org>
In-Reply-To: <1208517302.9212.324.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804181510.53412.hs4233@mail.mn-solutions.de> (sfid-20080418_141356_873005_EF70785A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I wrote "if (ret) return ret", not "if (ret) return;".
>
> I know you did, but I don't know why. The
> lbs_ethtool_get_stats() function returns void. Sebastian's
> patch which memsets it to zero makes sense, but it can't
> return an error.

Ahh, I stand corrected.


> They're separate problems, really. With or without the patch I
> first posted, you're getting crap back when you ask for
> statistics on a non-mesh device. The second patch fixes that,
> and stands alone.

Yes, this is separate. That's why I wrote "The ultimate patch 
would be".

BTW, I like your two patches combined more than Sebastians memset 
approach. Because with Sebastians patch on on ethX we would get 
zeroed nonsense instead of uninitialized nonsense.

The memset should possible there anyway in the case of a firmware 
that can mshX, but not CMD_ACT_MESH_GET_STATS or which would 
return some error for another reason.
