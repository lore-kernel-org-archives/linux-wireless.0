Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39567 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1CKUSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:18:20 -0500
Message-ID: <4D7A8350.9000406@candelatech.com>
Date: Fri, 11 Mar 2011 12:17:20 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211: fix channel type recalculation with HT and
 non-HT interfaces
References: <1299873939-1171-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1299873939-1171-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2011 12:05 PM, Felix Fietkau wrote:
> When running an AP interface along with the cooked monitor interface created
> by hostapd, adding an interface and deleting it again triggers a channel type
> recalculation during which the (non-HT) monitor interface takes precedence
> over the HT AP interface, thus causing the channel type to be set to non-HT.
> Fix this by not overriding HT interfaces with a non-HT channel type.

After staring at that code a bit more, should that list-for-each-entry
loop be entirely different such that it better calculates a proper
super-channel for mixed interface types?

If seems like a bad case of last-one-wins as currently written.

The code probably (mostly?) works right because we limit the
bss_conf.channel_type based on existing super-chan when
adding new interfaces, but it still seems like brittle code to me.

Thanks,
Ben


>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> ---
>   net/mac80211/chan.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
> index 5b24740..8511e60 100644
> --- a/net/mac80211/chan.c
> +++ b/net/mac80211/chan.c
> @@ -76,6 +76,7 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
>
>   		switch (tmp->vif.bss_conf.channel_type) {
>   		case NL80211_CHAN_NO_HT:
> +			break;
>   		case NL80211_CHAN_HT20:
>   			superchan = tmp->vif.bss_conf.channel_type;
>   			break;


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

