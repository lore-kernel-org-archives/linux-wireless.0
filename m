Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59348 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3DJI4A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 04:56:00 -0400
Message-ID: <1365584151.8388.0.camel@jlt4.sipsolutions.net> (sfid-20130410_105607_589466_0149C2C9)
Subject: Re: [Patch] mac80211: SMPS for AP Mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivekananda Holla <vivekanandah@posedge.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 10 Apr 2013 10:55:51 +0200
In-Reply-To: <516528C8.90509@posedge.com> (sfid-20130410_105443_117821_9F07C071)
References: <516528C8.90509@posedge.com>
	 (sfid-20130410_105443_117821_9F07C071)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-10 at 14:24 +0530, Vivekananda Holla wrote:
> Patch for SMPS mode for AP. This is to define a new ieee80211_tx_info flag to allow a lower AP driver to set RTS/CTS protection for a dynamic SMPS station
> 
> Signed-off-by: Vivekananda Holla <vivekanandah@posedge.com>
> ---
>  include/net/mac80211.h             |    4 ++++
>  net/mac80211/rc80211_minstrel_ht.c |    3 +++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 64faf01..48a950c 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -458,6 +458,9 @@ struct ieee80211_bss_conf {
>   * @IEEE80211_TX_CTL_DONTFRAG: Don't fragment this packet even if it
>   *    would be fragmented by size (this is optional, only used for
>   *    monitor injection).
> + * @IEEE80211_TX_CTL_SMPS_SET_RTS: set the RTS/CTS protection mechanism
> + *    for the packet at AP when SMPS mode at the station is 
> + *    dynamic SMPS.

Huh? No ... There are perfectly usable flags already inside each rate.

johannes

