Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1AIJdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 04:33:16 -0500
Subject: Re: [ath9k-devel] [PATCH v2 3/3] ath9k: Keep track of stations for
 debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "greearb@candelatech.com" <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
In-Reply-To: <20110107201204.GG21588@tux>
References: <1294375752-3946-1-git-send-email-greearb@candelatech.com>
	 <20110107201204.GG21588@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Jan 2011 10:33:13 +0100
Message-ID: <1294565593.3469.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-07 at 12:12 -0800, Luis R. Rodriguez wrote:
> On Thu, Jan 06, 2011 at 08:49:12PM -0800, greearb@candelatech.com wrote:
> > From: Ben Greear <greearb@candelatech.com>
> > 
> > The stations hold the ath_node, which holds the tid
> > and other xmit logic structures.  In order to debug
> > stuck xmit logic, we need a way to print out the tid
> > state for the stations.
> > 
> > Signed-off-by: Ben Greear <greearb@candelatech.com>
> > ---
> > 
> > v1 -> v2:  Use linked list instead of array.  Protect with spinlock.
> 
> Again, see my comments about the # STAs limit. I think this can go in
> as a cfg80211 driver limitation which can be exposed.

There's a todo list item that is more generic -- exposing the possible
interface combinations including their counts. So if anything, we should
start working on that, although I agree that if the limit is just due to
bugs, it shouldn't be advertised.

johannes

