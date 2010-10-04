Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:52217 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab0JDQlv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 12:41:51 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 09:41:42 -0700
Date: Mon, 4 Oct 2010 09:41:49 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>, Jouni Malinen <j@w1.fi>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: [PATCH v2 0/3] mac80211: fix rate_control_send_low warnings
 for delbas
Message-ID: <20101004164149.GE2105@tux>
References: <1285965233-11097-1-git-send-email-lrodriguez@atheros.com>
 <1286198845.3620.37.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1286198845.3620.37.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 06:27:25AM -0700, Johannes Berg wrote:
> How about this instead of your patches 2 and 3?
> 
> We're disassociating from the old AP since we associate with the new AP,
> so there's not a whole lot of sense in explicitly tearing down
> aggregation sessions either, right?

Good question, but why do we not get a warning when transmitting
the disassoc frame? The race is hit when we are on the wrong
channel, are you sure we are not sending a disassoc on a wrong
channel? I would expect a smoother transition if we actually
disassoc fromt the old AP in the ESS and I am not sure if we
do that right now.

  Luis
