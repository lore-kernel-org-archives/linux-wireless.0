Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaDHJoH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 05:44:07 -0400
Message-ID: <1396950245.5936.9.camel@jlt4.sipsolutions.net> (sfid-20140408_114411_739605_7384F588)
Subject: Re: [PATCH] mac80211: fix radar_enabled propagation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 08 Apr 2014 11:44:05 +0200
In-Reply-To: <1396609363-24539-1-git-send-email-michal.kazior@tieto.com> (sfid-20140404_130852_698229_A2912E57)
References: <1396609363-24539-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140404_130852_698229_A2912E57)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-04-04 at 13:02 +0200, Michal Kazior wrote:
> If chandef had non-HT width it was possible for
> radar_enabled update to not be propagated properly
> through drv_config(). This happened because
> ieee80211_hw_conf_chan() would never see different
> local->hw.conf.chandef and local->_oper_chandef.
> 
> This wasn't a problem with HT chandefs because
> _oper_chandef width is reset to non-HT in
> ieee80211_free_chanctx() making
> ieee80211_hw_conf_chan() to kick in.
> 
> This problem led (at least) ath10k to not start
> CAC if prior CAC was cancelled and both CACs were
> requested for identical non-HT chandefs.

Applied.

johannes

