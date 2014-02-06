Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbaBFQMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 11:12:15 -0500
Message-ID: <1391703129.12789.17.camel@jlt4.sipsolutions.net> (sfid-20140206_171218_406541_B24A963A)
Subject: Re: [RFC] mac80211: add NAPI support back
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 06 Feb 2014 17:12:09 +0100
In-Reply-To: <52F3B3D1.8050807@openwrt.org> (sfid-20140206_171000_437555_4D94073B)
References: <1391637437-5381-1-git-send-email-johannes@sipsolutions.net>
	 <52F3B3D1.8050807@openwrt.org> (sfid-20140206_171000_437555_4D94073B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-06 at 17:09 +0100, Felix Fietkau wrote:

> Why do you call napi_gro_receive at all?
> Without device GRO support it seems to be just a fancy way of doing
> netif_receive_skb with a bit more unnecessary indirection.

Because I want GRO, of course :-)

GRO is also enabled by default in netif flags (since 2.6.39 or
something) so any mac80211 driver that ends up using NAPI will also take
advantage of GRO.

johannes

