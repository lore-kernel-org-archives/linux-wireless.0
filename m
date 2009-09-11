Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web28302.mail.ukl.yahoo.com ([87.248.110.121]:42619 "HELO
	web28302.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753424AbZIKHwJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 03:52:09 -0400
Message-ID: <354996.83066.qm@web28302.mail.ukl.yahoo.com>
Date: Fri, 11 Sep 2009 07:52:11 +0000 (GMT)
From: Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH] sdio: pass unknown cis tuples to sdio drivers
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090910203951.041d5c17.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- El vie, 11/9/09, Andrew Morton <akpm@linux-foundation.org> escribió:
> > Some manufacturers provide vendor information in
> non-vendor specific CIS
> > tuples. For example, Broadcom uses an Extended
> Function tuple to provide
> > the MAC address on some of their network cards, as in
> the case of the
> > Nintendo Wii WLAN daughter card.
> > 
> > This patch allows passing correct tuples unknown to
> the SDIO core to
> > a matching SDIO driver instead of rejecting them and
> failing.
> > 
> 
> This looks leaky to me.
> 

Hi Andrew, thanks for the review.
I hope I can clarify a bit what the patch does in the next comments.

> 
> :         if (i < ARRAY_SIZE(cis_tpl_list)) {
> :             const struct cis_tpl *tpl = cis_tpl_list + i;
> :             if (tpl_link < tpl->min_size) {
> :                 printk(KERN_ERR
> :                        "%s: bad CIS tuple 0x%02x"
> :                        " (length = %u, expected >= %u)\n",
> :                        mmc_hostname(card->host),
> :                        tpl_code, tpl_link, tpl->min_size);
> :                 ret = -EINVAL;
> 
> ret == -EINVAL
> 

At this point ret is not -EINVAL. If it was -EINVAL the code would have had exit at this snipped before:

                if (ret) {
                        kfree(this);
                        break;
                }


> :             } else if (tpl->parse) {
> :                 ret = tpl->parse(card, func,
> :                                  this->data, tpl_link);
> :             }
> :             /* already successfully parsed, not needed anymore */
> :             if (!ret)
> :                 kfree(this);
> 
> `this' doesn't get freed
> 

Yes, that's the whole point of the patch. It must be freed _only_ if the SDIO core parsed it. If the SDIO core cannot parse it then it gets passed to the SDIO driver via the SDIO func struct tuple list (later).

> :         } else {
> :            /* unknown tuple */
> :            ret = -EILSEQ;
> :         }
> :
> :         if (ret == -EILSEQ) {
> 
> `this' doesn't get remembered.
> 

When ret is -EILSEQ `this' is linked to the SDIO func tuple list (later).

> :            /* this tuple is unknown to the core */
> :            this->next = NULL;
> :            this->code = tpl_code;
> :            this->size = tpl_link;
> :            *prev = this;
> :            prev = &this->next;
> :            pr_debug("%s: queuing CIS tuple 0x%02x length %u\n",
> :                     mmc_hostname(card->host), tpl_code, tpl_link);
> :            /* keep on analyzing tuples */
> :            ret = 0;
> :         }
> : 
> :         ptr += tpl_link;
> 
> `this' leaks.
> 

`this' doesn't leak. `this' has been linked to the SDIO func tuple list in:

*prev = this;


> :     } while (!ret);
> 
> Please check?
> 

Thanks a lot for you comments,
Albert



      
