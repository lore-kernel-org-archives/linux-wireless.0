Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54267 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbbDNHyY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 03:54:24 -0400
Message-ID: <1428998059.3019.1.camel@sipsolutions.net> (sfid-20150414_095445_876259_BBCD1F7B)
Subject: Re: [RFC v3] mac80211: lock rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Sven Eckelmann <sven@narfation.org>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Sven Eckelmann <sven@open-mesh.com>,
	Arik Nemtsov <arik@wizery.com>, liad.kaufman@intel.com
Date: Tue, 14 Apr 2015 09:54:19 +0200
In-Reply-To: <20150413212628.GA7869@localhost> (sfid-20150413_232633_258914_B093F402)
References: <1426061656-17546-1-git-send-email-sven@narfation.org>
	 <1426185468.1885.17.camel@sipsolutions.net>
	 <20150413212628.GA7869@localhost> (sfid-20150413_232633_258914_B093F402)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-04-13 at 17:26 -0400, Bob Copeland wrote:

> mac80211: introduce plink lock for plink fields
> 
> The mesh plink code uses sta->lock to serialize access to the
> plink state fields between the peer link state machine and the
> peer link timer.  Some paths (e.g. those involving
> mps_qos_null_tx()) unfortunately hold this spinlock across
> frame tx, which is soon to be disallowed.  Add a new spinlock
> just for plink access.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Thank you!

I've applied both this and the rate control locking patch.

We may later want to pick that up for stable perhaps, but let's let it
bake a little longer, it's pretty big.

johannes

