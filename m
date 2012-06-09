Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2FIIuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:50:18 -0400
Message-ID: <1339231815.4539.33.camel@jlt3.sipsolutions.net> (sfid-20120609_105023_962792_8AECA536)
Subject: Re: [PATCH 3/3] [nl,cfg,mac]80211: Allow user to configure basic
 rates when joining
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Date: Sat, 09 Jun 2012 10:50:15 +0200
In-Reply-To: <1339122086-23190-3-git-send-email-ashok@cozybit.com> (sfid-20120608_042139_111267_2A728C7B)
References: <1339122086-23190-1-git-send-email-ashok@cozybit.com>
	 <1339122086-23190-3-git-send-email-ashok@cozybit.com>
	 (sfid-20120608_042139_111267_2A728C7B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 19:21 -0700, Ashok Nagarajan wrote:
> Currently mesh uses mandatory rates as default basic rates. This patch
> introduces basic rates to be configured at the time of joining mesh.

> +	if (!sdata->vif.bss_conf.basic_rates)
> +		sdata->vif.bss_conf.basic_rates =
> +			ieee80211_mandatory_rates(sdata, band);

I think this default should come from cfg80211 instead, there's little
point in imposing this calculation on all drivers that want to use mesh.

johannes

