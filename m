Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2EGJVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 05:21:07 -0400
Message-ID: <1336382462.4325.4.camel@jlt3.sipsolutions.net> (sfid-20120507_112120_926904_344811C4)
Subject: Re: [PATCH] fix the increment of unicast/multicast counters for
 forwarded PREQ
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Mon, 07 May 2012 11:21:02 +0200
In-Reply-To: <CAEFj9857DWGCcnF20nKYEDb0_p1K_iYLR1F=oLNAx6NjwPQE9w@mail.gmail.com> (sfid-20120507_105843_577233_4BE81F52)
References: <1336106215-7431-1-git-send-email-yeohchunyeow@gmail.com>
	 <1336376603.4325.3.camel@jlt3.sipsolutions.net>
	 <CAEFj9857DWGCcnF20nKYEDb0_p1K_iYLR1F=oLNAx6NjwPQE9w@mail.gmail.com>
	 (sfid-20120507_105843_577233_4BE81F52)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> If the destination address is not broadcast frame, the number of
> forwarded unicast frame is increased. And the other way round. Not
> correct?
> 
> +		if (!is_multicast_ether_addr(da))
> +			ifmsh->mshstats.fwded_unicast++;
> +		else
> +			ifmsh->mshstats.fwded_mcast++;

No, your new code is fine, but this

> >> +             if (da != broadcast_addr)

will never be false.

johannes

