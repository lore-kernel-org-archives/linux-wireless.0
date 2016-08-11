Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52567 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbcHKMW5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 08:22:57 -0400
Message-ID: <1470918167.12075.2.camel@sipsolutions.net> (sfid-20160811_142301_026660_E7A4C73D)
Subject: Re: [PATCH] mac80211: Keep CoDel stats per txq, export them in
 debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
	make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>
Date: Thu, 11 Aug 2016 14:22:47 +0200
In-Reply-To: <20160720145442.1098-1-toke@toke.dk> (sfid-20160720_165542_917420_468D4AF0)
References: <20160720145442.1098-1-toke@toke.dk>
	 (sfid-20160720_165542_917420_468D4AF0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> @@ -137,18 +137,20 @@ static int aqm_open(struct inode *inode, struct
> file *file)
>  	len += scnprintf(info->buf + len,
>  			 info->size - len,
>  			 "* vif\n"
> -			 "ifname addr ac backlog-bytes backlog-
> packets flows overlimit collisions tx-bytes tx-packets\n");
> +			 "ifname addr ac backlog-bytes backlog-
> packets flows drops marks overlimit collisions tx-bytes tx-
> packets\n");

It seems to me that you have to change the buffer length to take this
into account?
 
>  	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>  		txqi = to_txq_info(sdata->vif.txq);
>  		len += scnprintf(info->buf + len, info->size - len,
> -				 "%s %pM %u %u %u %u %u %u %u %u\n",
> +				 "%s %pM %u %u %u %u %u %u %u %u %u
> %u\n",
>  				 sdata->name,

Why is it this way anyway? It'd seem nicer to move the content of this
into the per-netdev subdirectories, and then it becomes a lot simpler
code too (yes, at the expense of some userspace, but still)

>  				 sdata->vif.addr,

This is also kinda pointless since it's easy to get elsewhere.

>  				 txqi->txq.ac,
>  				 txqi->tin.backlog_bytes,
>  				 txqi->tin.backlog_packets,
>  				 txqi->tin.flows,
> +				 txqi->cstats.drop_count,
> +				 txqi->cstats.ecn_mark,
>  				 txqi->tin.overlimit,
>  				 txqi->tin.collisions,
>  				 txqi->tin.tx_bytes,

Do you really want to add these in the middle? Seems that if you add
them at the end, you at least have *some* way of keeping this working
with older versions?

johannes
