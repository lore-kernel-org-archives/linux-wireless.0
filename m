Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54003 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426Ab1A0V7E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 16:59:04 -0500
Message-ID: <4D41EA9E.6040907@openwrt.org>
Date: Thu, 27 Jan 2011 22:58:54 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: Re: [PATCH] ath9k: use split rx buffers to get rid of order-1 skb
 allocations
References: <1296062607-97934-1-git-send-email-nbd@openwrt.org> <20110127213105.GC2271@tuxdriver.com>
In-Reply-To: <20110127213105.GC2271@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-27 10:31 PM, John W. Linville wrote:
> On Wed, Jan 26, 2011 at 06:23:27PM +0100, Felix Fietkau wrote:
>> With this change, less CPU time is spent trying to look for consecutive
>> pages for rx skbs. This also reduces the socket memory required for IP/UDP
>> reassembly.
>> Only two buffers per frame are supported. Frames spanning more buffers
>> will be dropped, but the buffer size is enough to handle the required
>> AMSDU size.
>> 
>> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> Will this address https://bugzilla.kernel.org/show_bug.cgi?id=26652 ?
I think so. Memory allocation will fail less frequently and it reduces
RAM usage per device by 2 MB.

- Felix
