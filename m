Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26010 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1KWKH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 05:07:28 -0500
Date: Wed, 23 Nov 2011 15:37:19 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>, <mcgrof@gmail.com>
CC: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <compat@orbit-lab.org>,
	Paul Stewart <pstew@google.com>,
	Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [PATCH 1/3] cfg80211: allow following country IE power for
 custom regdom cards
Message-ID: <20111123100717.GA1761@vmraj-lnx.users.atheros.com> (sfid-20111123_110732_260952_8A6AC942)
References: <1321985402-14257-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1321985402-14257-2-git-send-email-mcgrof@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1321985402-14257-2-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 22, 2011 at 10:10:00AM -0800, Luis R. Rodriguez wrote:
> By definition WIPHY_FLAG_STRICT_REGULATORY was intended to allow the
> wiphy to adjust itself to the country IE power information if the
> card had no regulatory data but we had no way to tell cfg80211 that if
> the card also had its own custom regulatory domain (these are typically
> custom world regulatory domains) that we want to follow the country IE's
> noted values for power for each channel. We add support for this and
> document it.
> 
> This is not a critical fix but a performance optimization for cards
> with custom regulatory domains that associate to an AP with sends
> out country IEs with a higher EIRP than the one on the custom
> regulatory domain. In practice the only driver affected right now
> are the Atheros drivers as they are the only drivers using both
> WIPHY_FLAG_STRICT_REGULATORY and WIPHY_FLAG_CUSTOM_REGULATORY --
> used on cards that have an Atheros world regulatory domain. Cards
> that have been programmed to follow a country specifically will not
> follow the country IE power. So although not a stable fix distributions
> should consider cherry picking this.
> 
Luis,

After some testing, I noticed that the incresed power value seems to be
remained after the disconnection. So while falling back to world
regulatory domain the band updations are ignored at ignore_reg_update.
If the driver follows STRICT_REGULATORY, the it should not be ignored.
isn't it?

--
Rajkumar

