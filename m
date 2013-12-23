Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33950 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab3LWNrX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 08:47:23 -0500
Message-ID: <52B83EE1.4040705@openwrt.org> (sfid-20131223_144749_770890_1B23CA63)
Date: Mon, 23 Dec 2013 14:47:13 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ding Tianhong <dingtianhong@huawei.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/21] wireless: slight optimization of addr compare
References: <52B7C600.8030907@huawei.com>
In-Reply-To: <52B7C600.8030907@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-23 06:11, Ding Tianhong wrote:
> Use the recently added and possibly more efficient
> ether_addr_equal_unaligned to instead of memcmp.
It looks to me like all of these (including the ones in the other
similar patches) are in places, where the address data is aligned to at
least 16 bit. Because of this, using ether_addr_equal instead of
ether_addr_equal_unaligned would be much better for platforms without
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS.

- Felix
