Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:42432 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765157Ab3DDWio convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 18:38:44 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Thu, 4 Apr 2013 15:38:36 -0700
Subject: RE: [PATCH 4/4] mwifiex: bug: hold proper locks when accessing
 ra_list / bss_prio lists.
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DDAB6D3@SC-VEXCH1.marvell.com> (sfid-20130405_003848_162586_360A02A1)
References: <20130404205706.GA29851@blumentopf>
 <1365109286-5075-1-git-send-email-andreas.fenkart@streamunlimited.com>
 <1365109286-5075-4-git-send-email-andreas.fenkart@streamunlimited.com>
In-Reply-To: <1365109286-5075-4-git-send-email-andreas.fenkart@streamunlimited.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andi,

> @@ -981,6 +973,12 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
>  						    struct mwifiex_ra_list_tbl,
>  						    list);
>  				} while (ptr != head);
> +
> +skip_wmm_queue:
> +				spin_unlock_irqrestore(&priv_tmp->wmm.
> +						       ra_list_spinlock,
> +						       flags_ra);
> +

Please remove this blank line.

>  			}
> 
>  skip_bss:
> @@ -998,14 +996,21 @@ skip_bss:
>  						struct mwifiex_bss_prio_node,
>  						list);
>  		} while (bssprio_node != bssprio_head);
> +
> +skip_prio_tbl:
> +		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
> +				       flags_bss);
> +

Please remove this blank line.

>  	}
>  	return NULL;
> 
>  found:
> -	spin_lock_irqsave(&priv_tmp->wmm.ra_list_spinlock, flags);
> +	/* holds bss_prio_lock / ra_list_spinlock */

Thanks,
Bing

