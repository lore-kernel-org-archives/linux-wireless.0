Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761225AbYCDRQj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 12:16:39 -0500
Subject: Re: [PATCH] libertas: fix sanity check on sequence number in
	command response
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803031220.12420.hs4233@mail.mn-solutions.de>
References: <200803031220.12420.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 12:12:44 -0500
Message-Id: <1204650764.30024.8.camel@localhost.localdomain> (sfid-20080304_171701_160083_BCAF9234)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-03-03 at 12:20 +0100, Holger Schurig wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> 
> Slightly more useful if we compare it against the sequence number of the
> command we have outstanding, rather than comparing the reply with itself.
>     
> Doh. Pointed out by Sebastian Siewior
>     
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
> index e6b4b23..52d02f3 100644
> --- a/drivers/net/wireless/libertas/cmdresp.c
> +++ b/drivers/net/wireless/libertas/cmdresp.c
> @@ -509,9 +509,9 @@ int lbs_process_rx_command(struct lbs_private *priv)
>  		     respcmd, le16_to_cpu(resp->seqnum), priv->upld_len, jiffies);
>  	lbs_deb_hex(LBS_DEB_CMD, "CMD_RESP", (void *) resp, priv->upld_len);
>  
> -	if (resp->seqnum != resp->seqnum) {
> +	if (resp->seqnum != priv->cur_cmd->cmdbuf->seqnum) {
>  		lbs_pr_info("Received CMD_RESP with invalid sequence %d (expected %d)\n",
> -			    le16_to_cpu(resp->seqnum), le16_to_cpu(resp->seqnum));
> +			    le16_to_cpu(resp->seqnum), le16_to_cpu(priv->cur_cmd->cmdbuf->seqnum));
>  		spin_unlock_irqrestore(&priv->driver_lock, flags);
>  		ret = -1;
>  		goto done;

