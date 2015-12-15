Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45251 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbbLOFrs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 00:47:48 -0500
From: David Lin <dlin@marvell.com>
To: Kan Yan <kyan@chromium.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v7] Add new mac80211 driver mwlwifi.
Date: Tue, 15 Dec 2015 05:47:44 +0000
Message-ID: <a9df396f54ed4a879ff918baf4b47c63@SC-EXCH02.marvell.com> (sfid-20151215_064752_000865_AAB43AB5)
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
 <loom.20151214T222202-611@post.gmane.org>
In-Reply-To: <loom.20151214T222202-611@post.gmane.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Kan Yan writes:
> 
> David Lin <dlin@...> writes:
> 
> > +static inline struct sk_buff *mwl_tx_do_amsdu(struct mwl_priv *priv,
> > +					      int desc_num,
> > ...
> > +		amsdu_pkts = (struct sk_buff_head *)
> > +			kmalloc(sizeof(*amsdu_pkts), GFP_KERNEL);
> > +		if (!amsdu_pkts) {
> 
> Should GFP_ATOMIC be used here instead of GFP_KERNEL? This function could
> be called in interrupt context.
> 

Thanks. I will fix it.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
