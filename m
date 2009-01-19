Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:34707 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760089AbZASNMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 08:12:08 -0500
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCHv2 1/2] iwl3945: fix some warnings when compiled  without debug
MIME-Version: 1.0
Date: Mon, 19 Jan 2009 14:09:35 +0100
From: <samuel@sortiz.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200901191302.15719.Helmut.Schaa@gmx.de>
References: <200901191302.15719.Helmut.Schaa@gmx.de>
Message-ID: <2d7bdf406bc0a183459734d24c167492@localhost> (sfid-20090119_141217_059625_4C85F082)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 19 Jan 2009 13:02:15 +0100, Helmut Schaa=0D
<helmut.schaa@googlemail.com> wrote:=0D
> Fix the following warnings if compiled without CONFIG_IWLWIFI_DEBUG.=0D
> =0D
> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function=0D
> =E2=80=98iwl3945_rx_reply_add_sta=E2=80=99:=0D
> drivers/net/wireless/iwlwifi/iwl3945-base.c:2748: warning: unused=0D
variable=0D
> =E2=80=98pkt=E2=80=99=0D
> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function=0D
> =E2=80=98iwl3945_rx_scan_results_notif=E2=80=99:=0D
> drivers/net/wireless/iwlwifi/iwl3945-base.c:2903: warning: unused=0D
variable=0D
> =E2=80=98notif=E2=80=99=0D
> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function=0D
> =E2=80=98iwl3945_rx_scan_complete_notif=E2=80=99:=0D
> drivers/net/wireless/iwlwifi/iwl3945-base.c:2928: warning: unused=0D
variable=0D
> =E2=80=98scan_notif=E2=80=99=0D
> =0D
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>=0D
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>=0D
=0D
Thanks for this one as well.=0D
=0D
> ---=0D
> =0D
> V2 fixes the indention of preprocessor statements.=0D
> =0D
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c=0D
> b/drivers/net/wireless/iwlwifi/iwl3945-base.c=0D
> index b437cac..15d36d8 100644=0D
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c=0D
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c=0D
> @@ -2744,7 +2744,9 @@ static void iwl3945_rx_reply_alive(struct iwl_p=
riv=0D
> *priv,=0D
>  static void iwl3945_rx_reply_add_sta(struct iwl_priv *priv,=0D
>  				 struct iwl_rx_mem_buffer *rxb)=0D
>  {=0D
> +#ifdef CONFIG_IWLWIFI_DEBUG=0D
>  	struct iwl_rx_packet *pkt =3D (void *)rxb->skb->data;=0D
> +#endif =0D
>  =0D
>  	IWL_DEBUG_RX("Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);=0D
>  	return;=0D
> @@ -2898,9 +2900,11 @@ static void iwl3945_rx_scan_start_notif(struct=
=0D
> iwl_priv *priv,=0D
>  static void iwl3945_rx_scan_results_notif(struct iwl_priv *priv,=0D
>  				      struct iwl_rx_mem_buffer *rxb)=0D
>  {=0D
> +#ifdef CONFIG_IWLWIFI_DEBUG=0D
>  	struct iwl_rx_packet *pkt =3D (void *)rxb->skb->data;=0D
>  	struct iwl_scanresults_notification *notif =3D=0D
>  	    (struct iwl_scanresults_notification *)pkt->u.raw;=0D
> +#endif=0D
>  =0D
>  	IWL_DEBUG_SCAN("Scan ch.res: "=0D
>  		       "%d [802.11%s] "=0D
> @@ -2923,8 +2927,10 @@ static void iwl3945_rx_scan_results_notif(stru=
ct=0D
> iwl_priv *priv,=0D
>  static void iwl3945_rx_scan_complete_notif(struct iwl_priv *priv,=0D
>  				       struct iwl_rx_mem_buffer *rxb)=0D
>  {=0D
> +#ifdef CONFIG_IWLWIFI_DEBUG=0D
>  	struct iwl_rx_packet *pkt =3D (void *)rxb->skb->data;=0D
>  	struct iwl_scancomplete_notification *scan_notif =3D (void *)pkt->u=
=2Eraw;=0D
> +#endif=0D
>  =0D
>  	IWL_DEBUG_SCAN("Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n=
",=0D
>  		       scan_notif->scanned_channels,=0D
> --=0D
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess"=0D
> in=0D
> the body of a message to majordomo@vger.kernel.org=0D
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
