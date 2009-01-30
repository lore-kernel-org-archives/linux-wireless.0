Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50634 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbZA3RHt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 12:07:49 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 09:07:49 -0800
Date: Fri, 30 Jan 2009 09:07:03 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v5] mac80211: do not TX injected frames when not allowed
Message-ID: <20090130170703.GF6534@tesla> (sfid-20090130_180754_227710_F37CEBE5)
References: <1233333636-26066-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1233333636-26066-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2009 at 08:40:36AM -0800, Luis Rodriguez wrote:
> Monitor mode is able to TX by using injected frames. We should
> not allow injected frames to be sent unless allowed by regulatory
> rules. Since AP mode uses a monitor interfaces to transmit
> management frames we have to take care to not break AP mode as
> well while resolving this. We can deal with this by allowing compliant
> APs solutions to inform mac80211 if their monitor interface is
> intended to be used for an AP by setting a cfg80211 flag for the
> monitor interface. hostapd, for example, currently does its own
> checks to ensure AP mode is not used on channels which require radar
> detection. Once such solutions are available it can can add this
> flag for monitor interfaces.
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> This v5 leaves the AP flag out, we can add it once we have radar support.
> 
>  net/mac80211/tx.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 7b013fb..aa5ba90 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1432,11 +1432,33 @@ int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  int ieee80211_monitor_start_xmit(struct sk_buff *skb,
>                                  struct net_device *dev)
>  {
> +       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);

unused variable now, bleh, sorry, will send v6.. hopefully the last heh.

  Luis
