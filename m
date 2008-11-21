Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55795 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbYKUTjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 14:39:12 -0500
Subject: Re: [PATCH] Re: Problem with Kernel Oops in ipw2200
From: reinette chatre <reinette.chatre@intel.com>
To: Frank Seidel <fseidel@suse.de>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"hschaa@suse.de" <hschaa@suse.de>
In-Reply-To: <49214BF3.8050306@suse.de>
References: <49130E75.1000903@suse.de> <49131173.3010409@suse.de>
	 <20081112213350.GJ2411@tuxdriver.com>  <491BF062.4050705@suse.de>
	 <1226631539.2604.411.camel@debian.sh.intel.com>  <49214BF3.8050306@suse.de>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 11:39:57 -0800
Message-Id: <1227296397.13619.33.camel@rc-desk> (sfid-20081121_203918_102238_B82E30BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-11-17 at 02:48 -0800, Frank Seidel wrote:
> From: Zhu Yi <yi.zhu@intel.com>
> 
> Fixes Oops in ipw2200:ipw_tx_skb when pinging through
> a WPA enterprise connection.
> 
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> Tested-by: Frank Seidel <fseidel@suse.de>
> Signed-off-by: Ffrank Seidel <fseidel@suse.de>
> 
> ---
>  drivers/net/wireless/ipw2200.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- a/drivers/net/wireless/ipw2200.c
> +++ b/drivers/net/wireless/ipw2200.c
> @@ -10190,6 +10190,11 @@ static int ipw_tx_skb(struct ipw_priv *p
>         u16 remaining_bytes;
>         int fc;
> 
> +       if (!(priv->status & STATUS_ASSOCIATED)) {
> +               IPW_DEBUG_TX("Tx attempt while not associated.\n");
> +               goto drop;
> +       }
> +
>         hdr_len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
>         switch (priv->ieee->iw_mode) {
>         case IW_MODE_ADHOC:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Frank,

The patch above was not accepted. Would it be possible for you to try
the patch below instead? Thank you very much.

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c
b/drivers/net/wireless/ipw2x00/ipw2200.c
index c73173a..768bbde 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -189,6 +189,7 @@ static int ipw_up(struct ipw_priv *);
 static void ipw_bg_up(struct work_struct *work);
 static void ipw_down(struct ipw_priv *);
 static void ipw_bg_down(struct work_struct *work);
+static void ipw_link_down(struct ipw_priv *priv);
 static int ipw_config(struct ipw_priv *);
 static int init_supported_rates(struct ipw_priv *priv,
 				struct ipw_supported_rates *prates);
@@ -3897,6 +3898,7 @@ static int ipw_disassociate(void *data)
 	if (!(priv->status & (STATUS_ASSOCIATED | STATUS_ASSOCIATING)))
 		return 0;
 	ipw_send_disassociate(data, 0);
+	ipw_link_down(data);
 	return 1;
 }
 




