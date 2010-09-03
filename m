Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab0ICMPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 08:15:13 -0400
Subject: Re: [PATCH 10/13] iwlwifi: force scan complete after timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1283515056-11523-11-git-send-email-sgruszka@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
	 <1283515056-11523-11-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Sep 2010 14:15:06 +0200
Message-ID: <1283516106.4700.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-03 at 13:57 +0200, Stanislaw Gruszka wrote:
> If we do not get notification from hardware about scan complete after
> timeout do mac80211 scan completion anyway. This assure we end scan
> in case of firmware hung.


> -	return test_bit(STATUS_SCAN_HW, &priv->status);
> +	ret = test_bit(STATUS_SCAN_HW, &priv->status);
> +	if (ret)
> +		iwl_force_scan_end(priv);
> +	return ret;

After this, is there any point in the return value from
iwl_scan_cancel_timeout()?

johannes

