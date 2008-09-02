Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38392 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbYIBBlp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2008 21:41:45 -0400
Subject: Re: new: regression iwl3945/mac80211 endless after suspend
	associate/deassociate loop
From: Zhu Yi <yi.zhu@intel.com>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	Jan-Espen Pettersen <sigsegv@radiotube.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20080901160658.GA11063@google.com>
References: <20080901160658.GA11063@google.com>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 09:38:56 +0800
Message-Id: <1220319536.28282.128.camel@debian.sh.intel.com> (sfid-20080902_034159_012050_22EA3C20)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-01 at 19:07 +0300, Michael S. Tsirkin wrote:
> [16482.909453] eth1: associate with AP XX:XX:XX:XX:XX:XX
> [16482.918553] eth1: RX ReassocResp from XX:XX:XX:XX:XX:XX
> (capab=0x411 status=0 aid=1)
> [16482.918564] eth1: associated
> [16492.920224] eth1: disassociating by local choice (reason=3)
> [16492.920986] eth1: disassociating by local choice (reason=3)

It is exactly 10 seconds the local STA sends the deauth_leaving frame
before associated everytime. I wonder if it is the timeout for some
wireless config tools. NM?

What did you do to make it reassociate after resume? If you are using
some automatic config tools, can you try iwconfig manually instead?

Thanks,
-yi

