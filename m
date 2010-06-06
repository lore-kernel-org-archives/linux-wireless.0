Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab0FFJou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 05:44:50 -0400
Subject: Re: [PATCH] mac80211: Add interface for driver to temporarily
 disable dynamic ps
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1275561873-21500-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1275561873-21500-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Jun 2010 11:44:44 +0200
Message-ID: <1275817484.3615.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Apologies for the delay in reviewing this.

On Thu, 2010-06-03 at 13:44 +0300, Juuso Oikarinen wrote:

> @@ -699,6 +704,8 @@ enum ieee80211_smps_mode {
>  struct ieee80211_conf {
>  	u32 flags;
>  	int power_level, dynamic_ps_timeout, dynamic_ps_forced_timeout;
> +	int dynamic_ps_user_timeout;
> +	bool disable_dynamic_ps;
>  	int max_sleep_period;

Please don't keep these variables in driver-visible structures, they
don't belong there as they are implementation details, they should be in
the ieee80211_local structure somewhere and the driver should see _only_
dynamic_ps_timeout.

The same actually applies to dynamic_ps_forced_timeout as well, so
please also make a separate patch moving that.

johannes

