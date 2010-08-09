Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab0HIRHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Aug 2010 13:07:12 -0400
Subject: Re: [RFC PATCH] iwlwifi: abort scan when restarting
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100809160203.GA22569@redhat.com>
References: <20100809160203.GA22569@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 19:06:53 +0200
Message-ID: <1281373613.20185.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-09 at 18:02 +0200, Stanislaw Gruszka wrote:

> iwl_scan_cancel_timeout() will not success if we are performing it
> from work handler, because workqueue can not fire new work when
> still other one is performed. To prevent such situation
> schedule priv->abort_scan to generic workqueue. Also increase
> sleep time to have better change abort_scan work complete.

I don't like this much, but you're right. However, I think we can get
around this by having iwl_scan_cancel_timeout() not call
iwl_scan_cancel() but rather do everything that iwl_bg_abort_scan()
would do directly, since _timeout() may sleep, while scan_cancel() may
not. What do you think?

johannes

