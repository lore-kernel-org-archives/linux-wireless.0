Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39772 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231AbZCPSvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 14:51:09 -0400
Date: Mon, 16 Mar 2009 20:50:37 +0200
From: Jouni Malinen <j@w1.fi>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: don't drop null frames during software
	scan
Message-ID: <20090316185037.GA20327@jm.kir.nu> (sfid-20090316_195115_290775_5B87F6E3)
References: <20090315200738.17370.29374.stgit@tikku> <20090316085741.GA29986@jm.kir.nu> <871vsxve5p.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <871vsxve5p.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2009 at 02:35:30PM +0200, Kalle Valo wrote:

> > so this should not matter much, but the comment could be made more
> > clear about the different needs for nullfunc frames (please also
> > s/null frames/nullfunc frames/) and probe request frames. The former
> > are sent only on the operational channel in the beginning and end of
> > scan while the latter are sent on the channels to be scanned during
> > an active scan.
> 
> Should the description be in ieee80211_start_scan() in scan.c? I think
> it would make more sense to have it there instead of tx.c. I can then
> add a reference to the comment above.

Either way works for me as long as there is something giving me enough
information (or pointer to that) next to the place that allows nullfunc
frames go through. Anyway, Johannes is correct about the proper longer
term fix being better mechanism to stop the queue so that we don't get
into this code in the first place and in that sense, this patch is more
of a workaround for the time being.

-- 
Jouni Malinen                                            PGP id EFC895FA
