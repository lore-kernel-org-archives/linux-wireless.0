Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43552 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab1AQRkM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 12:40:12 -0500
Message-ID: <4D347EF7.10004@openwrt.org>
Date: Mon, 17 Jan 2011 18:40:07 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: drop non-auth 3-addr data frames when running
 as a 4-addr station
References: <1295098708-99081-1-git-send-email-nbd@openwrt.org> <1295274050.3726.11.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295274050.3726.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-17 3:20 PM, Johannes Berg wrote:
> On Sat, 2011-01-15 at 14:38 +0100, Felix Fietkau wrote:
>>  When running as a 4-addr station against an AP that has the 4-addr VLAN
>>  interface and the main 3-addr AP interface bridged together, sometimes
>>  frames originating from the station were looping back from the 3-addr AP
>>  interface, causing the bridge code to emit warnings about receiving frames
>>  with its own source address.
>>  I'm not sure why this is happening yet, but I think it's a good idea to
>>  drop all frames (except 802.1x/EAP frames) that do not match the configured
>>  addressing mode, including 4-address frames sent to a 3-address station.
>>  User test reports indicate that the problem goes away with this patch.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  ---
>>   net/mac80211/rx.c |    8 ++++++--
>>   1 files changed, 6 insertions(+), 2 deletions(-)
>>
>>  diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
>>  index a6701ed..54e3108 100644
>>  --- a/net/mac80211/rx.c
>>  +++ b/net/mac80211/rx.c
>>  @@ -1561,9 +1561,13 @@ __ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
>>   	sdata->vif.type == NL80211_IFTYPE_AP_VLAN&&  !sdata->u.vlan.sta)
>>   		return -1;
>>
>>  +	if (!ieee80211_802_1x_port_control(rx)&&
>
> I think you need a different check there. This just checks the STA is
> authorized.
You're right. I'll fix and resend.

- Felix
