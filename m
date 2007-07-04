Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:25890 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbXGDGvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2007 02:51:09 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Marcelo Tosatti <marcelo@kvack.org>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: Fwd: drivers/net/wireless/libertas/rx.c: use-after-free
Date: Wed, 4 Jul 2007 08:51:05 +0200
Cc: Adrian Bunk <bunk@stusta.de>
References: <200706302114.53985.hs4233@mail.mn-solutions.de> <20070703195633.GA6325@dmt>
In-Reply-To: <20070703195633.GA6325@dmt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707040851.06156.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi Holger,
>
> That line sneaked somehow with the patch - it was part of the
> original driver.

I think John W. Linville already committed my patch that removes 
the line completely. It's in 
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git, 
branch libertas-fixes


> process_rxed_802_11_packet is never called at the moment

I also noticed yesterday that process_rxed_802_11_packet() is 
never called, because no-one sets adapter->linkmode. So I posted 
a patch to libertas-dev and linux-wireless-dev to remove this 
variable as well as the code around it. I also found out lot's 
of other variables that weren't really used, and posted 
remove-XYZ patches. Please comment on which you want to stay 
because you/we plan to build an actual interface around them.


> but we might want to support monitor mode properly (there is a
> firmware comming out with it soon), and setting ETH_P_80211_RAW
> seems required for that. 

When is "is coming out soon" ???  If it's really soon, we 
shouldn't maybe commit my remove adapter->linkmode patch :-)
