Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44743 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0I0Kwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 06:52:47 -0400
Subject: Re: [PATCH] mac80211: fix offchannel assumption upon association
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, Amod Bodas <amod.bodas@atheros.com>,
	Vasanth Thiagarajan <vasanth.thiagarajan@atheros.com>
In-Reply-To: <1285379997-1544-1-git-send-email-lrodriguez@atheros.com>
References: <1285379997-1544-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 12:52:43 +0200
Message-ID: <1285584763.4043.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-24 at 21:59 -0400, Luis R. Rodriguez wrote:
> Association is dealt with as an atomic offchannel operation,
> we do this because we don't know we are associated until we
> get the associatin response from the AP. When we do get the
> associatin response though we were never clearing the offchannel
> state. This has a few implications, we told drivers we were
> still offchannel, and the first configured TX power for the
> channel does not take into account any power constraints.
> 
> For ath9k this meant ANI calibration would not start upon
> association, and we'd have to wait until the first bgscan
> to be triggered. There may be other issues this resolves
> but I'm too lazy to colb the code to check.

colb?

But anyway, looks OK to me. Need to revisit some of the off-channel
stuff eventually, but for now this is fine I think.

johannes

