Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36418 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab3CRTLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 15:11:12 -0400
Message-ID: <1363633866.8260.5.camel@jlt4.sipsolutions.net> (sfid-20130318_201116_370351_DB1C9CFF)
Subject: Re: [PATCH 1/2] mac80211: move sdata debugfs dir to vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Alexander Bondar <alexander.bondar@intel.com>
Date: Mon, 18 Mar 2013 20:11:06 +0100
In-Reply-To: <1362750375-3759-1-git-send-email-sgruszka@redhat.com>
References: <1362750375-3759-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-08 at 14:46 +0100, Stanislaw Gruszka wrote:
> There is need create driver own per interface debugfs files. This is
> currently done by drv_{add,remove}_interface_debugfs() callbacks. But it
> is possible that after we remove interface from the driver (i.e.
> on suspend) we call drv_remove_interface_debugfs() function. Fixing this
> problem will require to add call drv_{add,remove}_interface_debugfs()
> anytime we create and remove interface in mac80211. So it's better to
> add debugfs dir dentry to vif structure to allow to create/remove
> custom debugfs driver files on drv_{add,remove}_interface().

Both applied, thanks.

johannes

