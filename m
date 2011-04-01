Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1DAIPz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 04:15:55 -0400
Subject: Re: [PATCH v2] cfg80211: add work for processing invalid user reg
 hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, gregoryx.alagnou@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1301614180-5401-1-git-send-email-lrodriguez@atheros.com>
References: <1301614180-5401-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 10:17:43 +0200
Message-ID: <1301645863.3832.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-31 at 16:29 -0700, Luis R. Rodriguez wrote:
>  
> +static void reg_timeout_work(struct work_struct *work)
> +{
> +	REG_DBG_PRINT("Timeout while waiting for CRDA to reply,"
> +		      "restoring regulatory settings");
> +	restore_regulatory_settings(true);
> +}

We have a queue of requests but you're timing out only the last one.
Wouldn't that still get another one stuck on the queue? TBH, I don't
quite understand why we have last _and_ a queue to start with.

johannes

