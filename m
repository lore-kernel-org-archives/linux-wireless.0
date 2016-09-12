Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57267 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756507AbcILJ1x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:27:53 -0400
Message-ID: <1473672467.4201.16.camel@sipsolutions.net> (sfid-20160912_112756_472339_00A99246)
Subject: Re: [PATCH v2] mac80211: Re-structure aqm debugfs output and
 include CoDel drops
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Mon, 12 Sep 2016 11:27:47 +0200
In-Reply-To: <20160811151156.6485-1-toke@toke.dk> (sfid-20160811_171216_207117_5110F87B)
References: <20160720145442.1098-1-toke@toke.dk>
         <20160811151156.6485-1-toke@toke.dk> (sfid-20160811_171216_207117_5110F87B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -109,6 +109,48 @@ static ssize_t sta_last_seq_ctrl_read(struct
> file *file, char __user *userbuf,
>  }
>  STA_OPS(last_seq_ctrl);
>  
> +#define AQM_TXQ_ENTRY_LEN 130
> +
> +static ssize_t sta_aqm_read(struct file *file, char __user *userbuf,
> +			size_t count, loff_t *ppos)
> +{
> +	struct sta_info *sta = file->private_data;
> +	struct ieee80211_local *local = sta->local;
> +	char buf[AQM_TXQ_ENTRY_LEN*(IEEE80211_NUM_TIDS+1)], *p =
> buf;
> 
This is very large, I think you should dynamically allocate it.

johannes
