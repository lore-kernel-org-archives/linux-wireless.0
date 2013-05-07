Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54367 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933468Ab3EGNml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 09:42:41 -0400
Message-ID: <1367934155.8328.21.camel@jlt4.sipsolutions.net> (sfid-20130507_154313_642769_CE86151A)
Subject: Re: [RFC 06/12] mac80211: notify bridge when leaving mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>
Date: Tue, 07 May 2013 15:42:35 +0200
In-Reply-To: <1367548442-8229-7-git-send-email-thomas@cozybit.com> (sfid-20130503_043625_267018_84D610F4)
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
	 <1367548442-8229-7-git-send-email-thomas@cozybit.com>
	 (sfid-20130503_043625_267018_84D610F4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-02 at 19:33 -0700, Thomas Pedersen wrote:
> After turning carrier off, any parent bridge interface
> needs to be notified. Otherwise we would see a panic when
> attempting to transmit frames on a mesh interface which
> hadn't yet been put down.
> 
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  net/mac80211/mesh.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index eac9988..271ddc9 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -993,6 +993,9 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>  	struct beacon_data *bcn;
>  
>  	netif_carrier_off(sdata->dev);
> +	if (sdata->dev->priv_flags & IFF_BRIDGE_PORT)
> +		/* stop bridge transmissions */
> +		call_netdevice_notifiers(NETDEV_CHANGE, sdata->dev);

Err, this seems like a really bad hack? I don't really think drivers
should call that?

johannes

