Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43076 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbaAFPVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 10:21:25 -0500
Message-ID: <1389021677.5891.28.camel@jlt4.sipsolutions.net> (sfid-20140106_162150_693932_0C03C66E)
Subject: Re: [PATCH 13/21] mac8011: slight optimization of addr compare
From: Johannes Berg <johannes@sipsolutions.net>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 06 Jan 2014 16:21:17 +0100
In-Reply-To: <52B7C5DA.9090307@huawei.com>
References: <52B7C5DA.9090307@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-23 at 13:10 +0800, Ding Tianhong wrote:
> Use the recently added and possibly more efficient
> ether_addr_equal_unaligned to instead of memcmp.

> -				if (memcmp(local->hw.wiphy->addresses[i].addr,
> -					   sdata->vif.addr, ETH_ALEN) == 0) {
> +				if (ether_addr_equal_unaligned(local->hw.wiphy->addresses[i].addr, sdata->vif.addr)) {

This clearly should have some linebreaks.

This code also doesn't care all that much about efficiency, so not sure
it's worth it at all.

johannes

