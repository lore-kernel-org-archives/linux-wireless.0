Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49615 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab0IGUws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 16:52:48 -0400
Received: by qyk36 with SMTP id 36so3847872qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Sep 2010 13:52:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5144f966da86d4ab0984bc15bdd5fcab@localhost>
References: <1282764076.3667.12.camel@jlt3.sipsolutions.net>
	<AANLkTikc0-FbeRHm-0rxrWCGgaxa7svCsQmqpAD-87cq@mail.gmail.com>
	<5144f966da86d4ab0984bc15bdd5fcab@localhost>
Date: Tue, 7 Sep 2010 13:52:47 -0700
Message-ID: <AANLkTimgvEShOKnA3TTf0_3p2ghP2OL8ngKPBgpkf+zf@mail.gmail.com>
Subject: Re: libertas_tf
From: Steve deRosier <steve@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> Is anyone using libertas_tf? I believe it has been broken since
>>> 2.6.34-rc1. Anyone want to fix it?
>
>
> Is it working though on kernels newer than that? or do you have to set the
> MAC addr manually?
>

I've got it working on 2.6.34-rc5-wl, branched off commit
~8425ee8329f33 sometimes near the end of April 2010.  I've
significantly reworked some MAC addr stuff, including forcing the
module to request the MAC addr from the hardware and using that to set
the addr before the calls to setup mac80211.

I'm now working on getting it all up to head, so patches should be
coming soon.  Actually, on that note, how would you prefer I get them
to you?  We're talking about an entire new module, libertas_tf_sdio,
and lots of patches to the existing libertas_tf modules.  Something
like 40+ patches.  Would you prefer a patchset posted, or me to squash
a bunch into fewer but larger patches, or would you prefer to pull
from my git tree?

- Steve
