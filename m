Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:37198 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab1IDI2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Sep 2011 04:28:41 -0400
Subject: Re: [iwl4965] Microcode SW error detected
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Bernhard Schmidt <bschmidt@freebsd.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110607145435.GA5179@redhat.com>
References: <1306151106.2066.60.camel@x61.thuisdomein>
	 <201106070832.49048.bschmidt@freebsd.org>
	 <20110607145435.GA5179@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Sep 2011 10:28:35 +0200
Message-ID: <1315124915.5239.21.camel@x61.thuisdomein> (sfid-20110904_102845_905822_2FEA4EC7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-07 at 16:54 +0200, Stanislaw Gruszka wrote:
> That could be useful hint, we do not scan chan by chan, but we
> have thing called "plcp check health", which "restart radio"
> by requesting one channel scan. So perhaps disabling that could
> help.
> 
> [...]
>
> diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
> index 654cf23..6062da0 100644
> --- a/drivers/net/wireless/iwlegacy/iwl-rx.c
> +++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
> @@ -230,6 +230,8 @@ EXPORT_SYMBOL(iwl_legacy_rx_spectrum_measure_notif);
>  void iwl_legacy_recover_from_statistics(struct iwl_priv *priv,
>  				struct iwl_rx_packet *pkt)
>  {
> +	return;
> +
>  	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
>  		return;
>  	if (iwl_legacy_is_any_associated(priv)) {

0) I finally got around to applying this patch (to v3.0.4).

1) After a few days of normal usage (with quite a bit of suspend and
resume cycles) this error was again triggered. So avoiding
check_plcp_health() doesn't seem to help.

2) I never send you the debug output (ie, output after doing "modprobe
iwl4965 debug=0x47ffffff"), did I?


Paul Bolle

