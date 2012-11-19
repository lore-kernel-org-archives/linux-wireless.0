Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36584 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2KSOO1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 09:14:27 -0500
Message-ID: <1353334496.18299.5.camel@jlt4.sipsolutions.net> (sfid-20121119_151430_497340_4E17C06C)
Subject: Re: [RFC] mac80211: Add debugfs callbacks for station
 addition/removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 15:14:56 +0100
In-Reply-To: <1353304116-7124-1-git-send-email-sujith@msujith.org>
References: <1353304116-7124-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 11:18 +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Provide drivers with hooks to create debugfs files when
> a new station is added. This would help drivers to take
> advantage of mac80211's station list infrastructure and not maintain
> tedious station management code internally.

I guess this works, and we don't really need tracing for it.

Can the files stay across a firmware restart or suspend/resume? I guess
with suspend/resume nothing can access them, but accessing them during
firmware restart might be ... strange? Not that I'm too worried about
that.

johannes

