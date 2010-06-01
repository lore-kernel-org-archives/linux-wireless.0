Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab0FAVKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 17:10:07 -0400
Subject: Re: [PATCH] mac80211: process station blockack action frames from
 work
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1275052978.3909.105.camel@jlt3.sipsolutions.net>
References: <1275052978.3909.105.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 14:10:05 -0700
Message-ID: <1275426605.2091.27516.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Fri, 2010-05-28 at 06:22 -0700, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Processing an association response could take a bit
> of time while we set up the hardware etc. During that
> time, the AP might already send a blockack request.
> If this happens very quickly on a fairly slow machine,
> we can end up processing the blockack request before
> the association processing has finished. Since the
> blockack processing cannot sleep right now, we also
> cannot make it wait in the driver.
> 
> As a result, sometimes on slow machines the iwlagn
> driver gets totally confused, and no traffic can pass
> when the aggregation setup was done before the assoc
> setup completed.
> 
> I'm working on a proper fix for this, which involves
> queuing all blockack category action frames from a
> work struct, and also allowing the ampdu_action driver
> callback to sleep, which will generally clean up the
> code and make things easier.
> 
> However, this is a very involved and complex change.
> To fix the problem at hand in a way that can also be
> backported to stable, I've come up with this patch.
> Here, I simply process all aggregation action frames
> from the managed interface skb queue, which means
> their processing will be serialized with processing
> the association response, thereby fixing the problem.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Cc: stable@kernel.org
> ---

Could you please consider this patch for wireless-2.6/2.6.34 ? Without
this patch no data transfer is possible on some slow machines.

Thank you

Reinette



