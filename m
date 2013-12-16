Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LPO4C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 09:56:02 -0500
Message-ID: <1387205758.2057.17.camel@jlt4.sipsolutions.net> (sfid-20131216_155607_020988_F11AB5A9)
Subject: Re: [PATCH 2/2] cfg80211: make regulatory_hint() remove
 REGULATORY_CUSTOM_REG
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Date: Mon, 16 Dec 2013 15:55:58 +0100
In-Reply-To: <1387048146-16380-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20131214_200916_241465_7761FAAE)
References: <1387048146-16380-1-git-send-email-mcgrof@do-not-panic.com>
	 <1387048146-16380-2-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20131214_200916_241465_7761FAAE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-12-14 at 20:09 +0100, Luis R. Rodriguez wrote:
> The REGULATORY_CUSTOM_REG can be used during early init with
> the goal of overriding the wiphy's default regulatory settings
> in case the alpha2 of the device is not known. In the case that
> the alpha2 becomes known lets avoid having drivers having to
> clear the REGULATORY_CUSTOM_REG flag by doing it for them
> when regulatory_hint() is used.

This change brcmsmac behaviour afaict - are you sure that's correct?

johannes

