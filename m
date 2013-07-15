Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60326 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab3GOMyF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 08:54:05 -0400
Message-ID: <51E3F0EA.3060603@openwrt.org> (sfid-20130715_145407_868273_999C152B)
Date: Mon, 15 Jul 2013 14:54:02 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	krzysiek@podlesie.net
Subject: Re: [PATCH 3.11] mac80211/minstrel: fix NULL pointer dereference
 issue
References: <1373891706-1071-1-git-send-email-nbd@openwrt.org> <1373892651.2062.11.camel@joe-AO722>
In-Reply-To: <1373892651.2062.11.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-07-15 2:50 PM, Joe Perches wrote:
> On Mon, 2013-07-15 at 14:35 +0200, Felix Fietkau wrote:
>> When priv_sta == NULL, mi->prev_sample is dereferenced too early. Move
>> the assignment further down, after the rate_control_send_low call.
>> 
>> Reported-by: Krzysztof Mazur <krzysiek@podlesie.net>
>> Cc: stable@vger.kernel.org # 3.10
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> Why should this be marked for stable?
> 
> It's a local reference only, it's not used.
> 
> It's like suggesting that all the initialized
> automatics should not be set until after
> rate_control_set_low is called.
mi is set to priv_sta. It can be NULL. The case of priv_sta==NULL is
caught by rate_control_send_low and causes it to bail out.

- Felix

