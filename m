Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33153
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbXBEQyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 11:54:16 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Jouni Malinen" <jkm@devicescape.com>
Subject: Re: [PATCH] d80211: Add API to generate RTS and CTS-to-self frames
Date: Mon, 5 Feb 2007 17:53:44 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702051412.50703.mb@bu3sch.de> <200702051628.46518.mb@bu3sch.de> <20070205164738.GA31058@instant802.com>
In-Reply-To: <20070205164738.GA31058@instant802.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702051753.45093.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 05 February 2007 17:47, Jouni Malinen wrote:
> On Mon, Feb 05, 2007 at 04:28:46PM +0100, Michael Buesch wrote:
> 
> > As I said in response to Johannes' comment, if a driver needs just
> > the duration, we should export the functions to calculate it
> > and remove the calculation from the tx_control and the tx_control
> > setup path.
> 
> In that case, I would like to see this change being included in the same
> patch/patchset.. Without this, I can only NAK this kind of change since
> it removes functionality needed for some designs and that is not
> something I would like to see happening with net/d80211 since the goal
> is to allow all reasonable hardware designs to work with it.

Ok, I already resent the patchset. ;)

> > Currently there is no driver using it, so I simply removed it.
> 
> There are, but maybe not in wireless-dev.git.
> 
> > BTW: Which cards need the duration, but not the whole frame?
> 
> Any card that supports different transmit rates for hw retries involving
> RTS/CTS/fragmentation (e.g., Atheros).

Ok, nice.
I just want to make sure that we don't have unused features (aka bloat)
in the stack.

-- 
Greetings Michael.
