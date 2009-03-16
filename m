Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53576 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbZCPKjE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 06:39:04 -0400
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 03:39:03 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18878.11082.119745.2048@gargle.gargle.HOWL> (sfid-20090316_113907_510181_67EEBB9E)
Date: Mon, 16 Mar 2009 16:04:50 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"me@bobcopeland.com" <me@bobcopeland.com>
Subject: Re: [PATCH v2] mac80211: Tear down aggregation sessions for suspend/resume
In-Reply-To: <1237198307.27769.8.camel@johannes.local>
References: <18878.8417.960342.116534@gargle.gargle.HOWL>
	<1237198307.27769.8.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2009-03-16 at 15:20 +0530, Sujith wrote:
> > When the driver has been notified with a STA_REMOVE, it tears down
> > the internal ADDBA state. On resume, trying to initiate aggregation would
> > fail because mac80211 has not cleared the operational state for that <TID,STA>.
> > This can be fixed by tearing down the existing sessions on a suspend.
> > 
> > Also, the driver can initiate a new BA session when suspend is in progress.
> > This is fixed by marking the station as being in suspend state and
> > denying ADDBA requests for such STAs.
> > 
> > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> 
> Looks good to me, thanks. Should we really set a per-station flag
> though? It seems a "local->suspended" would be sufficient and much
> cheaper?

I did consider it, but then was unsure of the locking required.
If that can be clarified, I will change this to be a ieee80211_local variable.

Sujith
