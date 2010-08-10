Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab0HJG5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 02:57:44 -0400
Date: Tue, 10 Aug 2010 08:57:16 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] iwlwifi: abort scan when restarting
Message-ID: <20100810065716.GA3217@redhat.com>
References: <20100809160203.GA22569@redhat.com>
 <1281373613.20185.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1281373613.20185.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 09, 2010 at 07:06:53PM +0200, Johannes Berg wrote:
> On Mon, 2010-08-09 at 18:02 +0200, Stanislaw Gruszka wrote:
> 
> > iwl_scan_cancel_timeout() will not success if we are performing it
> > from work handler, because workqueue can not fire new work when
> > still other one is performed. To prevent such situation
> > schedule priv->abort_scan to generic workqueue. Also increase
> > sleep time to have better change abort_scan work complete.
> 
> I don't like this much, but you're right. However, I think we can get
> around this by having iwl_scan_cancel_timeout() not call
> iwl_scan_cancel() but rather do everything that iwl_bg_abort_scan()
> would do directly, since _timeout() may sleep, while scan_cancel() may
> not. What do you think?

Make sense to me. I will do this as separate patch.

Stanislaw
