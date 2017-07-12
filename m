Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0093.hostedemail.com ([216.40.44.93]:53847 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933300AbdGLILb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2017 04:11:31 -0400
Message-ID: <1499847086.4457.27.camel@perches.com> (sfid-20170712_101153_922933_1AC18B9F)
Subject: Re: [PATCH] drivers/staging/wilc1000: fix sparse warning: right
 shift by bigger than source value
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Teng <rui.teng@linux.vnet.ibm.com>
Cc: devel@driverdev.osuosl.org,
        Aditya Shankar <aditya.shankar@microchip.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ganesh Krishna <ganesh.krishna@microchip.com>
Date: Wed, 12 Jul 2017 01:11:26 -0700
In-Reply-To: <20170712061220.GB11450@kroah.com>
References: <20170710085731.28397-1-rui.teng@linux.vnet.ibm.com>
         <20170711170449.GA30362@kroah.com>
         <f31c5818-7ba3-4708-3fda-5bfbe0c4c1da@linux.vnet.ibm.com>
         <20170712061220.GB11450@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-07-12 at 08:12 +0200, Greg Kroah-Hartman wrote:
> On Wed, Jul 12, 2017 at 10:23:02AM +0800, Rui Teng wrote:
> > On 12/07/2017 1:04 AM, Greg Kroah-Hartman wrote:
> > > On Mon, Jul 10, 2017 at 04:57:31PM +0800, Rui Teng wrote:
> > > > This patch sets memory to zero directly to avoid unnecessary shift and
> > > > bitwise operations on bool type, which can fix a sparse warning and also
> > > > improve performance.
> > > 
> > > It does?  How did you measure the performance impact?  What was now
> > > faster?
> > 
> > It can avoid 3 times right shift and 3 times bitwise operations.
> > And once memory set should also faster than 4 times copy operations.
> > And add number 4 once should also faster than 4 times plus plus.
> 
> And did you test this to prove that this does matter and is noticable?
> How do you know that gcc doesn't just optimize it all away?  Is this on
> a code path that actually matters?
> 
> Don't ever say "improve performance" without actually being able to
> prove it please.

Using __be32 would be more intelligible.

Maybe something like this: (in any number of patches)

o convert u8 *pu8CurrByte to be32 *buf
o convert strHostIfSetMulti to smulti
o remove useless initialization of result
o remove unnecessary parentheses
o return directly on kalloc failure
o remove label

Ending up with: (uncompiled/untested)
---
static void Handle_SetMulticastFilter(struct wilc_vif *vif,
				      struct set_multicast *smulti)
{
	s32 result;
	struct wid wid;
	__be32 *buf;

	wid.id = (u16)WID_SETUP_MULTICAST_FILTER;
	wid.type = WID_BIN;
	wid.size = sizeof(struct set_multicast) + smulti->cnt * ETH_ALEN;
	wid.val = kmalloc(wid.size, GFP_KERNEL);
	if (!wid.val)
		return;

	buf = (__force __be32 *)wid.val;
	*buf++ = cpu_to_be32(smulti->enabled);
	*buf++ = cpu_to_be32(smulti->cnt);

	memcpy(buf, wilc_multicast_mac_addr_list, smulti->cnt * ETH_ALEN);

	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
				      wilc_get_vif_idx(vif));
	if (result)
		netdev_err(vif->ndev, "Failed to send setup multicast\n");

	kfree(wid.val);
}
