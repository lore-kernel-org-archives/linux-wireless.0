Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26355 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab2C3HMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 03:12:46 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20341.23754.784161.403908@gargle.gargle.HOWL> (sfid-20120330_091249_873646_9E787448)
Date: Fri, 30 Mar 2012 12:42:10 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/4] mac80211: remove channel type argument from rate_update
In-Reply-To: <1333089999.3908.4.camel@jlt3.sipsolutions.net>
References: <20120328085835.902687300@sipsolutions.net>
	<20120328085901.175434140@sipsolutions.net>
	<20341.14488.303053.16407@gargle.gargle.HOWL>
	<1333089999.3908.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Yes, that's true. However, we use the sta.ht_cap field more of a current
> operating set database. For example, we also update it when the station
> changes SMPS configuration. Also, we never keep it at just the station's
> capabilities -- we always restrict it by our own TX capabilities (so if
> for example we aren't 40 MHz capable, we already don't leave 40 MHz in).

Ah, that's true.

> Overall, I don't really see a problem with this. I suppose we could
> rename the field to make that a bit clearer, but I see little value in
> using some other struct or so?

Yeah, the current approach seems reasonable enough. Thanks for clarifying.

Sujith
