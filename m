Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:8421 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752455Ab0GWIoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 04:44:16 -0400
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0299214653
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jul 2010 17:44:14 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch -next] ath5k: snprintf() returns largish values
Date: Fri, 23 Jul 2010 17:44:14 +0900
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	kernel-janitors@vger.kernel.org
References: <20100722085202.GV17585@bicker>
In-Reply-To: <20100722085202.GV17585@bicker>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007231744.14922.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu July 22 2010 17:52:02 Dan Carpenter wrote:
> snprintf() returns the number of characters that would have been written
> (not counting the NUL character).  So we can't use it as the limiter to
> simple_read_from_buffer() without capping it first at sizeof(buf).
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/net/wireless/ath/ath5k/debug.c
> b/drivers/net/wireless/ath/ath5k/debug.c index ebb9c23..4cccc29 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.c
> +++ b/drivers/net/wireless/ath/ath5k/debug.c
> @@ -239,6 +239,9 @@ static ssize_t read_file_beacon(struct file *file, char
> __user *user_buf, "TSF\t\t0x%016llx\tTU: %08x\n",
>  		(unsigned long long)tsf, TSF_TO_TU(tsf));
> 
> +	if (len > sizeof(buf))
> +		len = sizeof(buf);
> +
>  	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
>  }
> 
> @@ -334,6 +337,9 @@ static ssize_t read_file_debug(struct file *file, char
> __user *user_buf, sc->debug.level == dbg_info[i].level ? '+' : ' ',
>  		dbg_info[i].level, dbg_info[i].desc);
> 
> +	if (len > sizeof(buf))
> +		len = sizeof(buf);
> +
>  	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
>  }
> 
> @@ -433,6 +439,9 @@ static ssize_t read_file_antenna(struct file *file,
> char __user *user_buf, len += snprintf(buf+len, sizeof(buf)-len,
>  			"AR5K_PHY_ANT_SWITCH_TABLE_1\t0x%08x\n", v);
> 
> +	if (len > sizeof(buf))
> +		len = sizeof(buf);
> +
>  	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
>  }
> 
> @@ -542,6 +551,9 @@ static ssize_t read_file_frameerrors(struct file *file,
> char __user *user_buf, len += snprintf(buf+len, sizeof(buf)-len, "[TX
> all\t%d]\n",
>  			st->tx_all_count);
> 
> +	if (len > sizeof(buf))
> +		len = sizeof(buf);
> +
>  	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
>  }
> 
> @@ -681,6 +693,9 @@ static ssize_t read_file_ani(struct file *file, char
> __user *user_buf, ATH5K_ANI_CCK_TRIG_HIGH - (ATH5K_PHYERR_CNT_MAX -
>  			ath5k_hw_reg_read(sc->ah, AR5K_PHYERR_CNT2)));
> 
> +	if (len > sizeof(buf))
> +		len = sizeof(buf);
> +
>  	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
>  }
> 
> @@ -766,6 +781,9 @@ static ssize_t read_file_queue(struct file *file, char
> __user *user_buf, len += snprintf(buf+len, sizeof(buf)-len, "  len: %d\n",
> n);
>  	}
> 
> +	if (len > sizeof(buf))
> +		len = sizeof(buf);
> +
>  	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
>  }

i think it would be better to make sure the buffer is always big enough to 
hold all the output (it's not very variable in length), but as a safety net 
this can't hurt.

Acked-by: Bruno Randolf <br1@einfach.org>
