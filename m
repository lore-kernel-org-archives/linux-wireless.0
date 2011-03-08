Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab1CHPKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 10:10:07 -0500
Subject: Re: [RFC] mac80211: New notification to discover mesh peer
 candidates.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1299550284-3167-2-git-send-email-javier@cozybit.com>
References: <1299354655.29845.8.camel@jlt3.sipsolutions.net>
	 <1299550284-3167-2-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 16:10:00 +0100
Message-ID: <1299597000.4676.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-07 at 18:11 -0800, Javier Cardona wrote:
> Notify userspace when a beacon/presp is received from a suitable mesh
> peer candidate for whom no sta information exists.  Userspace can then
> decide to create a sta info for the candidate.  If userspace is not
> ready to authenticate the peer right away, it can create the sta info
> with the authenticated flag unset and set it later.

I'm a little worried about this creating lots of bogus stations if
somebody is attacking the mesh. Will that be relevant? Would it be
better to just pass up any beacon that matches the mesh ID, trading CPU
resources for memory?

Also, this goes back to the "authenticate station" rather than full
station management in userspace, right?

johannes

