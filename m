Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45425 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbaFVMOj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2014 08:14:39 -0400
Message-ID: <53A6C8A2.4000202@openwrt.org> (sfid-20140622_141447_483832_98375D0A)
Date: Sun, 22 Jun 2014 14:14:26 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
CC: b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/2] b43: remove leftover code from old devices support
References: <1403277721-25302-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1403277721-25302-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-06-20 17:22, Rafał Miłecki wrote:
> Old devices (A-PHY or B-PHY) are supposed to be supported by b43legacy.
> We keep phy_a.c as it's needed for G-PHY which shares some design.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Wouldn't it make sense to move the relevant pieces of phy_a.c to phy_g.c
and then remove phy_a.c entirely?

There are pieces in phy_a.c which can be removed entirely, e.g.
b43_phyops_a and things only used by this struct.

- Felix
