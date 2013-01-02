Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3ABNxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 08:53:33 -0500
Message-ID: <1357134823.9839.41.camel@jlt4.sipsolutions.net> (sfid-20130102_145335_540837_95A8D1FF)
Subject: Re: [PATCHv5 0/8] Add DFS master ability
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 02 Jan 2013 14:53:43 +0100
In-Reply-To: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I'm sending this as patch to keep the versioning, although it can be
> considered as RFC, I would be suprised if all single channel/single
> interface aspects were considered correctly. :)

:)

I think we need a bit more "design review" first.

To me, the open questions are:
 * Should switching to a DFS channel be allowed at all? How so, if radar
   can't be tested before? You just stop the AP instead but userspace
   can do that just as well.
 * What happens with multiple virtual interfaces? You allow a single
   channel context only which makes sense, but that doesn't disallow
   things like having a client + AP, and then the client switching away
   because the P2P GO it was connected to randomly decided to switch.
   This would break radar detection. (1) What should happen in this
   case?
 * To avoid that problem, could restrict to a single virtual interface.
   However, that's unlikely to be sufficient -- you'd want to still be
   able to implement multi-BSSID APs which then switch together etc.
 * That raises another interesting question -- should multiple BSSIDs on
   the same channel really *all* call the driver's ap_channel_switch()
   callback? That seems ... strange!
 * Do we need any software channel switch handling?

Generally the biggest issue is around multi-channel channel switch
behaviour I think. Any good ideas?

johannes

(1) Actually today it would either break the AP (channel contexts NOT
supported by the driver) or disconnect the client (otherwise)

