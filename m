Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50023 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0LASyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 13:54:07 -0500
Subject: Re: [PATCH] mac80211: Support beacon configuration via nl80211 for
 mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTikMex0A91Qy=5EwPAEfVWKDVz4_mneWnCvy3soR@mail.gmail.com>
References: <1291168735-3423-1-git-send-email-javier@cozybit.com>
	 <1291184383.4199.4.camel@jlt3.sipsolutions.net>
	 <AANLkTikMex0A91Qy=5EwPAEfVWKDVz4_mneWnCvy3soR@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 19:54:02 +0100
Message-ID: <1291229642.4199.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-01 at 10:45 -0800, Javier Cardona wrote:

> > I'm not convinced that letting userspace set the *entire* beacon is the
> > right way to do it? Wouldn't it make more sense to allow it to specify
> > vendor-specific IEs (like IBSS), and the fact that vendor selection
> > protocol is used? It seems to me that somebody may want to have vendor
> > IEs while using the default protocols?
> 
> Yes, agreed.  We'll investigate a way to provide a protocol switch
> (maybe a new NL80211_CMD_SET_MESH_PARAMS) + a vendor specific IE
> (NL80211_CMD_SET_MGMT_EXTRA_IE would have been ideal, but I see it's
> gone).

If we had a 'start mesh' command, like 'join IBSS', then it'd be natural
to have just more attributes in it. Maybe it's time to start thinking
about that again, although backward compatibility could be interesting.

johannes

