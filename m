Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab1BKOuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 09:50:15 -0500
Date: Fri, 11 Feb 2011 15:49:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/1] iwl3945: iwl3945_good_plcp_health might not used
Message-ID: <20110211144951.GA2278@redhat.com>
References: <1297354593-22897-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297354593-22897-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 10, 2011 at 08:16:33AM -0800, Wey-Yi Guy wrote:
> remove plcp check for 3945, mark the function __maybe_unused
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Cc: <stable@kernel.org> # .35+: c91d015: iwl3945: remove plcp check
> Cc: stable@kernel.org  # 2.6.35+
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index 3eb14fd..eb82341 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -408,7 +408,7 @@ static void iwl3945_accumulative_statistics(struct iwl_priv *priv,
>   * When the plcp error is exceeding the thresholds, reset the radio
>   * to improve the throughput.
>   */
> -static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
> +static bool __maybe_unused iwl3945_good_plcp_health(struct iwl_priv *priv,
>  				struct iwl_rx_packet *pkt)
>  {
>  	bool rc = true;

I was aware about that warning, but did not fix it, because when I compile
kernel, I can see lot's of other warnings and I have plan to clean
that iwl3945 code.

Does it something that really need to be fixed in -stable? I mean
should we bother stable maintainers about that?

Stanislaw
