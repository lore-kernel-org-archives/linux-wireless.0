Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55340 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489AbZA2VwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 16:52:07 -0500
Date: Thu, 29 Jan 2009 23:51:52 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, m.sujith@gmail.com,
	tomasw@gmail.com
Subject: Re: [RFC/RFT 06/11] mac80211: document TX aggregation (and small
	cleanup)
Message-ID: <20090129215152.GA27253@jm.kir.nu> (sfid-20090129_225212_551709_CCF39E0B)
References: <20090129005450.068797016@sipsolutions.net> <20090129005808.843799105@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090129005808.843799105@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 29, 2009 at 01:54:56AM +0100, Johannes Berg wrote:

> + * DOC: TX aggregation

> + * When TX aggregation is started by some subsystem (usually the rate control
> + * control algorithm would be appropriate) by calling the
> + * ieee80211_start_tx_ba_session() function, the driver will be notified via
> + * its @ampdu_action function, with the %IEEE80211_AMPDU_TX_START action.

Does rate control (btw, remove the duplicated "control" from the text)
algorithm have knowledge of whether PTK has already been configured?
There is going to be a somewhat unfortunate timing issue with trying to
set up aggregation before 4-way handshake has been completed if 802.11w
is used (Action frames are dropped before the keys are set). Something
in the system (either the request or mac80211's action on the request)
would need to be delayed until the keys are in place in such a case.

-- 
Jouni Malinen                                            PGP id EFC895FA
