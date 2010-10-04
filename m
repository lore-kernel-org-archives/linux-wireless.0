Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35241 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756727Ab0JDUjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 16:39:17 -0400
Date: Mon, 4 Oct 2010 23:39:00 +0300
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [PATCH v2 0/3] mac80211: fix rate_control_send_low warnings
 for delbas
Message-ID: <20101004203900.GA14524@jm.kir.nu>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
 <1286198845.3620.37.camel@jlt3.sipsolutions.net>
 <20101004164149.GE2105@tux>
 <1286210566.3620.42.camel@jlt3.sipsolutions.net>
 <20101004172504.GL2105@tux>
 <1286213426.3620.43.camel@jlt3.sipsolutions.net>
 <20101004173507.GN2105@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101004173507.GN2105@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 10:35:07AM -0700, Luis R. Rodriguez wrote:
> I was wondering if actively disassociating might help with a smoother
> transition. I was under this why we were doing this in the first place.
> I frankly do not know, but if it does not help then I do agree with
> your patch replacement.

In many cases, it may end up harming more than helping.. At minimum, it
takes some time to transmit the frame (and do the channel changes, if
needed). Furthermore, this makes it more difficult for centrally managed
networks to optimize roaming since we would be disassociating and
associating as a new association instead of doing proper re-association.
In such networks, the APs (or well, likely some sort of central manager)
takes care of clearing the old association when the reassociation is
being processed. In addition, this could potentially tunnel some frames
through the new AP or at least make sure that bridge tables gets
updated.

-- 
Jouni Malinen                                            PGP id EFC895FA
