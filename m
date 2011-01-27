Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33841 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1A0VpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 16:45:14 -0500
Date: Thu, 27 Jan 2011 16:31:05 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: Re: [PATCH] ath9k: use split rx buffers to get rid of order-1 skb
 allocations
Message-ID: <20110127213105.GC2271@tuxdriver.com>
References: <1296062607-97934-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296062607-97934-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 06:23:27PM +0100, Felix Fietkau wrote:
> With this change, less CPU time is spent trying to look for consecutive
> pages for rx skbs. This also reduces the socket memory required for IP/UDP
> reassembly.
> Only two buffers per frame are supported. Frames spanning more buffers
> will be dropped, but the buffer size is enough to handle the required
> AMSDU size.
> 
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Will this address https://bugzilla.kernel.org/show_bug.cgi?id=26652 ?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
