Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab2CWIx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 04:53:26 -0400
Message-ID: <1332492804.3506.7.camel@jlt3.sipsolutions.net> (sfid-20120323_095543_159268_5014701F)
Subject: Re: [RFC 11/12] mac80211: split offchannel functions to per-vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Mar 2012 09:53:24 +0100
In-Reply-To: <ccb26d54-38f2-478e-95d9-85fa1aea62c2@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_154026_591857_E0DB8EEA)
References: <ccb26d54-38f2-478e-95d9-85fa1aea62c2@FIVLA-EXHUB02.eu.tieto.com>
	 (sfid-20120320_154026_591857_E0DB8EEA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This seems very odd. Why would one vif be off-channel, and the other be
on-channel? That makes no sense, off-channel is a global state.

My thinking here right now is that mac80211-based off-channel and
scanning will only be supported for devices that don't implement
multi-channel, since all others really need to do the channel scheduling
themselves.

johannes

