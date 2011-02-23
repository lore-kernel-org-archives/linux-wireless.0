Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab1BWK5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 05:57:41 -0500
Date: Wed, 23 Feb 2011 11:57:21 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/4] iwlwifi: Limit number of firmware reload
Message-ID: <20110223105720.GA11916@redhat.com>
References: <1298317536-5071-1-git-send-email-wey-yi.w.guy@intel.com>
 <1298317536-5071-2-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1298317536-5071-2-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey

On Mon, Feb 21, 2011 at 11:45:33AM -0800, Wey-Yi Guy wrote:
> If device has serious problem and cause firmware can not recover itself.
> Keep reloading firmware will not help, it can only fill up the syslog and
> lock up the system because busy reloading.
Filling up logs could be simply avoided by limiting number of prints.

> Introduce the limit reload counter, if the reload reach the maximum within
> the pre-defined duration;stop the reload operation.
We have already one mechanism for limit too frequent firmware reload,
way not reuse it?

> +	reload_msec = jiffies_to_msecs((long) reload_jiffies -
> +				(long) priv->reload_jiffies);
What for are these (long) casts?

> +	/* firmware reload counter and timestamp */
> +	unsigned long reload_jiffies;
You do not initialize it, first reload_msec will have untrue value.

Beside, all these reload firmware mechanism are just crappy workarounds
for real firmware and/or driver bugs. Instead of creating such patches,
Intel should fix real problems in firmware and driver in first place,
such reloading will be not needed.

Stanislaw
