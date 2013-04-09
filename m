Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56023 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937594Ab3DIKZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 06:25:19 -0400
Message-ID: <1365503108.8465.34.camel@jlt4.sipsolutions.net> (sfid-20130409_122524_772605_92D4425C)
Subject: Re: [PATCH 1/3] cfg80211: add get_max_tp() API
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 09 Apr 2013 12:25:08 +0200
In-Reply-To: <20130406073309.GB14463@open-mesh.com>
References: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
	 <CAGXE3d98a4pBG=gWKUm9A2RJRN+eic4Zi8dh4grTuqQmW3GOsg@mail.gmail.com>
	 <20130405083956.GA14463@open-mesh.com>
	 <1365168001.8515.28.camel@jlt4.sipsolutions.net>
	 <20130406073309.GB14463@open-mesh.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> But the reported_rate field would just contain the index of the selected rate,
> not the throughput. As far as I can tell the latter is an RC private information
> (it not exported anywhere outside of the RC algorithm) and that is why I made
> this API which would directly talk to minstrel and get this value.

Actually it would contain the entire rate configuration.

Anyway my concern is that you're adding something that's rather minstrel
specific. It's not really usable by any other algorithm, you're
reporting minstrel's estimation of the throughput. If you report the
current "best" rate, that'll probably get you pretty much the same
behaviour overall, but be more portable to other algorithms I think.

johannes

