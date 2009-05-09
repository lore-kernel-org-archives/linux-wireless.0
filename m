Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53415 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbZEIIIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2009 04:08:53 -0400
Date: Sat, 9 May 2009 11:08:38 +0300
From: Jouni Malinen <j@w1.fi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] mac80211: Add a timeout for frames in the RX
	reorder buffer
Message-ID: <20090509080838.GA1206@jm.kir.nu>
References: <20090505173512.349795688@atheros.com> <20090505173550.273830766@atheros.com> <1241709323.4903.25.camel@localhost.localdomain> <1241833703.4903.83.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1241833703.4903.83.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 08, 2009 at 06:48:23PM -0700, Marcel Holtmann wrote:

> > I can confirm that this used to be a regular situation between my X200
> > and a D-Link access point.

Which D-Link model is that AP? I think I should try to get one of those
added to me test bed.. ;-)

> so I finally got the debug output for you. Took only over a day :)

Thanks! Would you happen to have timing information available for these
(e.g., from klogd)? It looks like the AP is sending out an ADDBA Request
to update some parameters, but we currently ignore that request.
However, at least in this particular case, our RX reorder bug head_seq
matches with the ssn from the ADDBA Request, so I'm not sure whether
ignoring the ADDBA contents is really causing harm here (anyway, we
should really process these updates, too).

The timeouts on RX reorder frames look similar to what I have seen in my
tests and the workaround was indeed trying to address that type of
issue, so it is nice to hear that it helped in this case, too.

-- 
Jouni Malinen                                            PGP id EFC895FA
