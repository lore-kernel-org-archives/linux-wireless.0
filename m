Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39473 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab2FAGoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 02:44:39 -0400
Message-ID: <1338533070.4884.4.camel@jlt3.sipsolutions.net> (sfid-20120601_084443_162860_857A14A0)
Subject: Re: [PATCH] ath9k: Fix a WARNING in suspend/resume with IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, stable@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Date: Fri, 01 Jun 2012 08:44:30 +0200
In-Reply-To: <1338532779-4621-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120601_083956_399882_A3D65832)
References: <1338532779-4621-1-git-send-email-mohammed@qca.qualcomm.com>
	 (sfid-20120601_083956_399882_A3D65832)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-01 at 12:09 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> In ath9k we make sure the following two things
> *if the first interface is ADHOC we cannot have any other interface.
> *we cannot add an ADHOC interface if there is already an interface
> is present.

> -	if ((ah->opmode == NL80211_IFTYPE_ADHOC) ||
> -	    ((vif->type == NL80211_IFTYPE_ADHOC) &&
> -	     sc->nvifs > 0)) {
> -		ath_err(common, "Cannot create ADHOC interface when other"
> -			" interfaces already exist.\n");
> +	if ((ah->opmode == NL80211_IFTYPE_ADHOC) && (sc->nvifs > 0)) {
> +		ath_err(common, "Cannot create any other interface when an ADHOC interface already exists.\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if ((vif->type == NL80211_IFTYPE_ADHOC) && (sc->nvifs > 0)) {
> +		ath_err(common, "Cannot create ADHOC interface when other interfaces already exist.\n");

You could just remove the entire check since the interface combinations
you advertise don't allow it, I think? Or just fix those
combinations :-)

johannes

