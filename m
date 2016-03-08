Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:35001 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbcCHNOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 08:14:22 -0500
Received: by mail-qg0-f44.google.com with SMTP id y89so11205106qge.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2016 05:14:21 -0800 (PST)
Date: Tue, 8 Mar 2016 08:14:09 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Dave Taht <dave.taht@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Tim Shepard <shep@alum.mit.edu>
Subject: Re: [RFC/RFT] mac80211: implement fq_codel for software queuing
Message-ID: <20160308131409.GD5026@localhost> (sfid-20160308_141540_069901_211D7726)
References: <1456492163-11437-1-git-send-email-michal.kazior@tieto.com>
 <CAA93jw4XsEnp3jTgPL7OKWTJP-83VwRaCdb+foc8nCuqxk3WZA@mail.gmail.com>
 <CA+BoTQk+3jhwK57_fDw0scNCGzu_Edqp9-Beeppz8xj9kSQcoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+BoTQk+3jhwK57_fDw0scNCGzu_Edqp9-Beeppz8xj9kSQcoQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 08, 2016 at 08:12:21AM +0100, Michal Kazior wrote:
> However other drivers (e.g. ath10k) have offloaded rate control on
> device. There's currently no way of doing this calculation. I was
> thinking of drivers exporting tx_rate to mac80211 in some way - either
> via a simple sta->tx_rate scalar that the driver is responsible for
> updating, or a EWMA that driver updates (hopefully) periodically and
> often enough. This should in theory at least allow an estimate how
> much data on average you can fit into given time frame (e.g. txop, or
> hardcoded 1ms).

What about implementing ops->get_expected_throughput?  This would be
useful for mesh (both 11s and batman) as well since they need to
estimate link quality to pick a path.

-- 
Bob Copeland %% http://bobcopeland.com/
