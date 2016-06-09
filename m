Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58622 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbcFIJr7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 05:47:59 -0400
Message-ID: <1465465675.3442.8.camel@sipsolutions.net> (sfid-20160609_114805_375574_E0073373)
Subject: Re: [PATCHv5 5/5] mac80211: add debug knobs for codel
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: dave.taht@gmail.com, make-wifi-fast@lists.bufferbloat.net,
	apenwarr@gmail.com
Date: Thu, 09 Jun 2016 11:47:55 +0200
In-Reply-To: <1463647072-16201-6-git-send-email-michal.kazior@tieto.com> (sfid-20160519_103608_366751_6B7E6130)
References: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
	 <1463647072-16201-1-git-send-email-michal.kazior@tieto.com>
	 <1463647072-16201-6-git-send-email-michal.kazior@tieto.com>
	 (sfid-20160519_103608_366751_6B7E6130)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +++ b/net/mac80211/debugfs.c
> @@ -126,13 +126,31 @@ static int aqm_open(struct inode *inode, struct
> file *file)
>  			 "R fq_overlimit %u\n"
>  			 "R fq_collisions %u\n"
>  			 "RW fq_limit %u\n"
> -			 "RW fq_quantum %u\n",
> +			 "RW fq_quantum %u\n"
> +			 "R codel_maxpacket %u\n"
> +			 "R codel_drop_count %u\n"
> 
It seems to me that this needs to adjust the length of the buffer
that's allocated.

johannes
