Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61361 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXH1JMe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 05:12:34 -0400
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <1188291015.7837.67.camel@johannes.berg>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070827131026.GA21137@infradead.org>
	 <1188285945.13078.242.camel@debian.sh.intel.com>
	 <1188291015.7837.67.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 17:07:11 +0800
Message-Id: <1188292031.13078.262.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-08-28 at 10:50 +0200, Johannes Berg wrote:
> To be fair, that's not what you do, you're building two drivers from
> one source rather than have a single driver that supports both. I'm
> fairly certain Christoph wouldn't object to the latter. 

Because of the difference of the two hardwares (for example, in
iwl-command.h, iwl_rxon_assoc_cmd differs between 3945 and 4965),
runtime supporting is difficult if not possible (hw structures differs).
So we select to do it statically by generating two drivers from one
source code.

Do you think if it is a good idea to split them into two drivers and
make each of them "#include iwl-base.c"? Please don't hesitate to share
if you have better ideas.

Thanks,
-yi
