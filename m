Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3DELXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 07:23:00 -0400
Message-ID: <1365160971.8515.23.camel@jlt4.sipsolutions.net> (sfid-20130405_132314_428349_D5917A02)
Subject: Re: [PATCH] mac80211: fix recalc_radar hwconf sync problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 05 Apr 2013 13:22:51 +0200
In-Reply-To: <20130404182219.GA24704@pandem0nium>
References: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1364993200.8351.35.camel@jlt4.sipsolutions.net>
	 <515D8259.1030208@neratec.com> <20130404182219.GA24704@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-04 at 20:22 +0200, Simon Wunderlich wrote:

> As far as I see, the problem happens when changing from a DFS to a non-DFS
> channel. local->hw.conf.radar_enabled is true from the last (DFS) channel,
> but the channel gets released when stopping the AP, and the channel context
> is freed. 

At this point, why doesn't it disable hw.conf.radar_enabled? I really
think it should?

johannes

