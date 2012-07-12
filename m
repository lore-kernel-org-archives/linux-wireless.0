Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679Ab2GLPOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 11:14:46 -0400
Message-ID: <1342106081.4531.29.camel@jlt3.sipsolutions.net> (sfid-20120712_171452_126198_0FD779FA)
Subject: Re: [PATCH v4 0/5] cfg80211: onus and cell base station hint
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Date: Thu, 12 Jul 2012 17:14:41 +0200
In-Reply-To: <1341940991-11234-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1341940991-11234-1-git-send-email-rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-10 at 10:23 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
> 
> These address the latest feedback on the v3 series. I've added
> two more patches to address removing of a superflous call
> given the introduction of wiphy_regulatory_register().
> 
> Luis R. Rodriguez (5):
>   cfg80211: add CONFIG_CFG80211_CERTIFICATION_ONUS
>   cfg80211: add cellular base station regulatory hint support
>   cfg80211: rename reg_device_remove() to wiphy_regulatory_deregister()
>   cfg80211: make regulatory_update() static
>   cfg80211: remove regulatory_update()

Could you rebase on mac80211-next? These don't seem to apply, due to
some overlapping changes in nl80211.h.

Also, generally I would prefer to have the cleanups first. You could
have changed regulatory_update -> wiphy_regulatory_register first and
then not have the intermediate step with two functions called from the
core? But if you don't want to change it now that's fine too.

johannes

