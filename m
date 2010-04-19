Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39758 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab0DSJCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 05:02:12 -0400
Subject: Re: [RFC] mac80211: sample survey implementation for mac80211 &
 hwsim
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <201004191023.57987.holgerschurig@gmail.com>
References: <201004191023.57987.holgerschurig@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 11:02:10 +0200
Message-ID: <1271667730.3873.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

How does this work with multiple channels? And how about knowing how old
the info is?

> +static inline int drv_get_survey(struct ieee80211_local *local, int idx,
> +				struct survey_info *survey)
> +{
> +	int ret = -EOPNOTSUPP;
> +	if (local->ops->conf_tx)
> +		ret = local->ops->get_survey(&local->hw, idx, survey);
> +	/* trace_drv_get_survey(local, idx, survey, ret); */

Lazy huh? :)

johannes

