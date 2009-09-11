Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbZIKDjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 23:39:54 -0400
Date: Thu, 10 Sep 2009 20:39:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Albert Herranz <albert_herranz@yahoo.es>
Cc: linux-mmc@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] sdio: pass unknown cis tuples to sdio drivers
Message-Id: <20090910203951.041d5c17.akpm@linux-foundation.org>
In-Reply-To: <1252587402-7382-2-git-send-email-albert_herranz@yahoo.es>
References: <1252587402-7382-1-git-send-email-albert_herranz@yahoo.es>
	<1252587402-7382-2-git-send-email-albert_herranz@yahoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 10 Sep 2009 14:56:42 +0200 Albert Herranz <albert_herranz@yahoo.es> wrote:

> Some manufacturers provide vendor information in non-vendor specific CIS
> tuples. For example, Broadcom uses an Extended Function tuple to provide
> the MAC address on some of their network cards, as in the case of the
> Nintendo Wii WLAN daughter card.
> 
> This patch allows passing correct tuples unknown to the SDIO core to
> a matching SDIO driver instead of rejecting them and failing.
> 

This looks leaky to me.


: 		if (i < ARRAY_SIZE(cis_tpl_list)) {
: 			const struct cis_tpl *tpl = cis_tpl_list + i;
: 			if (tpl_link < tpl->min_size) {
: 				printk(KERN_ERR
: 				       "%s: bad CIS tuple 0x%02x"
: 				       " (length = %u, expected >= %u)\n",
: 				       mmc_hostname(card->host),
: 				       tpl_code, tpl_link, tpl->min_size);
: 				ret = -EINVAL;

ret == -EINVAL

: 			} else if (tpl->parse) {
: 				ret = tpl->parse(card, func,
: 						 this->data, tpl_link);
: 			}
: 			/* already successfully parsed, not needed anymore */
: 			if (!ret)
: 				kfree(this);

`this' doesn't get freed

: 		} else {
: 			/* unknown tuple */
: 			ret = -EILSEQ;
: 		}
: 
: 		if (ret == -EILSEQ) {

`this' doesn't get remembered.

: 			/* this tuple is unknown to the core */
: 			this->next = NULL;
: 			this->code = tpl_code;
: 			this->size = tpl_link;
: 			*prev = this;
: 			prev = &this->next;
: 			pr_debug("%s: queuing CIS tuple 0x%02x length %u\n",
: 				 mmc_hostname(card->host), tpl_code, tpl_link);
: 			/* keep on analyzing tuples */
: 			ret = 0;
: 		}
: 
: 		ptr += tpl_link;

`this' leaks.

: 	} while (!ret);

Please check?
