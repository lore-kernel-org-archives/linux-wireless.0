Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:57857 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756800Ab3GONb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 09:31:56 -0400
Message-ID: <1373895115.2062.12.camel@joe-AO722> (sfid-20130715_153159_707489_847A37C1)
Subject: Re: [PATCH 3.11] mac80211/minstrel: fix NULL pointer dereference
 issue
From: Joe Perches <joe@perches.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	krzysiek@podlesie.net
Date: Mon, 15 Jul 2013 06:31:55 -0700
In-Reply-To: <51E3F0EA.3060603@openwrt.org>
References: <1373891706-1071-1-git-send-email-nbd@openwrt.org>
	 <1373892651.2062.11.camel@joe-AO722> <51E3F0EA.3060603@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-15 at 14:54 +0200, Felix Fietkau wrote:
> On 2013-07-15 2:50 PM, Joe Perches wrote:
> > On Mon, 2013-07-15 at 14:35 +0200, Felix Fietkau wrote:
> >> When priv_sta == NULL, mi->prev_sample is dereferenced too early. Move
> >> the assignment further down, after the rate_control_send_low call.
[]
> mi is set to priv_sta. It can be NULL. The case of priv_sta==NULL is
> caught by rate_control_send_low and causes it to bail out.

OK, thanks.

