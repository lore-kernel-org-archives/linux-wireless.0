Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51828 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYDTK4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 06:56:37 -0400
Subject: Re: [PATCH] libertas: Fix ethtool statistics
From: David Woodhouse <dwmw2@infradead.org>
To: Sebastian Siewior <liber+tas@ml.breakpoint.cc>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org
In-Reply-To: <20080420084101.GB7685@Chamillionaire.breakpoint.cc>
References: <1208448814.9212.270.camel@pmac.infradead.org>
	 <200804181149.41838.hs4233@mail.mn-solutions.de>
	 <1208517302.9212.324.camel@pmac.infradead.org>
	 <200804181510.53412.hs4233@mail.mn-solutions.de>
	 <20080420084101.GB7685@Chamillionaire.breakpoint.cc>
Content-Type: text/plain
Date: Sun, 20 Apr 2008 11:56:32 +0100
Message-Id: <1208688992.9212.412.camel@pmac.infradead.org> (sfid-20080420_115642_326883_14C7B6A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-04-20 at 10:41 +0200, Sebastian Siewior wrote:
> The function before lbs_ethtool_get_stats() (in net code that
> determinate the number of elements, dunno the name right now) is able to
> return an error. This one could check if the firmware has mesh support.

That's what my second patch does.

> Do I understand this correct: If the firmware has support for mesh
> devices than we have ethX and mshX and only mshX should return the
> statistics?

Well, they are _mesh_ statistics :)

> returning uninitialized nonsense is leaking kernel memory.

Indeed. We need that memset there to handle errors, definitely.

> What about changing lbs_ethtool_get_stats() from void to int? All
> other drivers are reading memory to get this data, we have to go
> through usb/cs/sdio layer and all of them may fail.

Yeah, that might be worthwhile.

> I will try to form a patch around Monday that fixes Dan's comments (if
> nobody else is going to).

Which comments? If we apply your original patch, followed by my patch in
<1208509888.9212.291.camel@pmac.infradead.org> (which for some reason
only went to wireless-dev, not libertas-dev), then I think it's fine.


-- 
dwmw2

