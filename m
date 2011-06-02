Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49440 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab1FBT4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 15:56:49 -0400
Date: Thu, 2 Jun 2011 15:49:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH] iwlagn: fix interface combinations
Message-ID: <20110602194936.GB2511@tuxdriver.com> (sfid-20110602_215652_872864_AA83A650)
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
 <1306510833-32049-8-git-send-email-wey-yi.w.guy@intel.com>
 <20110602162241.GE4580@redhat.com>
 <1307033971.14344.4.camel@wwguy-ubuntu>
 <1307036323.3738.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1307036323.3738.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 02, 2011 at 07:38:43PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> My patch to advertise interface combinations
> worked by pure luck in the P2P case, but all
> other cases are broken. This is due to a dumb
> mistake in the code that checks what should
> be advertised, fix that.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

I swear, I thought I had taken it out of my queue.  I'm getting old... :-(

> ---
> Alternatively, this fixes it. Sorry.

I'd rather just apply this -- any objections?

> 
>  drivers/net/wireless/iwlwifi/iwl-agn.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-06-02 19:36:58.000000000 +0200
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-06-02 19:37:09.000000000 +0200
> @@ -2533,11 +2533,11 @@ static int iwl_mac_setup_register(struct
>  
>  	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
>  
> -	if (hw->wiphy->interface_modes & NL80211_IFTYPE_P2P_CLIENT) {
> +	if (hw->wiphy->interface_modes & BIT(NL80211_IFTYPE_P2P_CLIENT)) {
>  		hw->wiphy->iface_combinations = iwlagn_iface_combinations_p2p;
>  		hw->wiphy->n_iface_combinations =
>  			ARRAY_SIZE(iwlagn_iface_combinations_p2p);
> -	} else if (hw->wiphy->interface_modes & NL80211_IFTYPE_AP) {
> +	} else if (hw->wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
>  		hw->wiphy->iface_combinations = iwlagn_iface_combinations_dualmode;
>  		hw->wiphy->n_iface_combinations =
>  			ARRAY_SIZE(iwlagn_iface_combinations_dualmode);
> 
> 
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
