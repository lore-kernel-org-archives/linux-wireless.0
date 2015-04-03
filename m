Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:44188 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752189AbbDCV3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2015 17:29:06 -0400
Message-ID: <1428096542.29510.11.camel@perches.com> (sfid-20150403_232910_633626_01694DF2)
Subject: Re: [PATCH 2/4] mac80211-hwsim: remove dmesg spam about get-survey.
From: Joe Perches <joe@perches.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 03 Apr 2015 14:29:02 -0700
In-Reply-To: <1428095590-600-2-git-send-email-greearb@candelatech.com>
References: <1428095590-600-1-git-send-email-greearb@candelatech.com>
	 <1428095590-600-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-04-03 at 14:13 -0700, greearb@candelatech.com wrote:
> This message just fills up dmesg and/or kernel logs and does
> not provide any useful information.
[]
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
[]
> @@ -1696,7 +1696,7 @@ static int mac80211_hwsim_get_survey(
>  {
>  	struct ieee80211_conf *conf = &hw->conf;
>  
> -	wiphy_debug(hw->wiphy, "%s (idx=%d)\n", __func__, idx);
> +	/* wiphy_debug(hw->wiphy, "%s (idx=%d)\n", __func__, idx); */

It's better, if it's really useless, to delete this
than comment it out.

But it's not on by default anyway, so why it an issue?

