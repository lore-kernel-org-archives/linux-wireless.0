Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1836 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2GKThz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 15:37:55 -0400
Date: Wed, 11 Jul 2012 12:37:44 -0700
From: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: support TX error rate notification
Message-ID: <20120711193744.GA4334@pista> (sfid-20120711_213758_125531_DF848408)
References: <1342034589-3979-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <4FFDD42E.6010401@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FFDD42E.6010401@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 11, 2012 at 10:29:50PM +0300, Kalle Valo wrote:
> On 07/11/2012 10:23 PM, Thomas Pedersen wrote:
> > The ath6kl firmware can monitor a connection and report when a certain
> > TX failure threshold is crossed. Support this configuration and event
> > reporting on compatible firmwares.
> > 
> > Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
> 
> [...]
> 
> > +	ev = (struct wmi_txe_notify_event *) datap;
> > +	rate = le32_to_cpu(ev->rate);
> > +	pkts = le32_to_cpu(ev->pkts);
> > +	ath6kl_dbg(ATH6KL_DBG_WMI, "TXE notify event: peer %pM rate %d pkts %d\n",
> > +		   vif->bssid, rate, pkts);
> 
> Empty line before the ath6kl_dbg() call, please.

Merge damage. Will fix.

> > +int ath6kl_wmi_set_txe_notify(struct wmi *wmi, u8 idx,
> > +			      u32 rate, u32 pkts, u32 intvl)
> > +{
> > +	struct sk_buff *skb;
> > +	struct wmi_txe_notify_cmd *cmd;
> > +
> > +	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
> > +	if (!skb)
> > +		return -ENOMEM;
> > +
> > +	cmd = (struct wmi_txe_notify_cmd *) skb->data;
> > +	cmd->rate = rate;
> > +	cmd->pkts = pkts;
> > +	cmd->intvl = intvl;
> 
> cpu_to_le32()?

Of course.

> > +/* WMI_SET_TXE_NOTIFY_CMD */
> > +struct wmi_txe_notify_cmd {
> > +	u32 rate;
> > +	u32 pkts;
> > +	u32 intvl;
> > +} __packed;
> > +
> > +/* WMI_TXE_NOTIFY_EVENTID */
> > +struct wmi_txe_notify_event {
> > +	u32 rate;
> > +	u32 pkts;
> > +} __packed;
> 
> Endian annotation?

Ok. v2 coming.

Thanks!
Thomas
