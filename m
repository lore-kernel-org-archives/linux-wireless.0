Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27838 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab3BEGlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 01:41:15 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Thomas Pedersen <thomas@cozybit.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: stop plink timer only on mesh interfaces
Date: Tue, 5 Feb 2013 06:41:10 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301929663@HASMSX103.ger.corp.intel.com> (sfid-20130205_074119_285216_9B940FFF)
References: <1360015961-5922-1-git-send-email-thomas@cozybit.com>
In-Reply-To: <1360015961-5922-1-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Since mesh_plink_quiesce() would unconditionally delete
> the plink timer, and the timer initialization was recently
> moved into the mesh code path, suspending with a non-mesh
> interface now causes a crash. Fix this by only deleting
> the plink timer for mesh interfaces.
> 
> Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
> 
> Hi Emmanuel,
> 
> Will you please test this patch?
> 
>  net/mac80211/mesh_plink.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index 81e6126..1f40c4a 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -528,6 +528,9 @@ static void mesh_plink_timer(unsigned long data)
>  #ifdef CONFIG_PM
>  void mesh_plink_quiesce(struct sta_info *sta)
>  {
> +	if (!ieee80211_vif_is_mesh(&sta->sdata->vif))
> +		return;
> +
>  	if (del_timer_sync(&sta->plink_timer))
>  		sta->plink_timer_was_running = true;
>  }
> --
> 1.7.10.4

Tested-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

