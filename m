Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbYBFE5G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 23:57:06 -0500
Subject: Re: ipw2200 stalls on high load
From: Dan Williams <dcbw@redhat.com>
To: Sebastian Siewior <ipw+2200@ml.breakpoint.cc>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org, ipw2100-devel@lists.sourceforge.net
In-Reply-To: <20080205235344.GA2507@Chamillionaire.breakpoint.cc>
References: <20080126132939.GA22630@Chamillionaire.breakpoint.cc>
	 <D936D925018D154694D8A362EEB0892003800B1B@orsmsx416.amr.corp.intel.com>
	 <20080130225738.GB2648@Chamillionaire.breakpoint.cc>
	 <D936D925018D154694D8A362EEB08920038F4382@orsmsx416.amr.corp.intel.com>
	 <1202128649.10632.4.camel@localhost.localdomain>
	 <D936D925018D154694D8A362EEB0892003947453@orsmsx416.amr.corp.intel.com>
	 <20080204224502.GA22717@Chamillionaire.breakpoint.cc>
	 <1202167450.5190.2.camel@localhost.localdomain>
	 <20080205083511.GA28623@Chamillionaire.breakpoint.cc>
	 <1202224154.1243.7.camel@localhost.localdomain>
	 <20080205235344.GA2507@Chamillionaire.breakpoint.cc>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 23:56:47 -0500
Message-Id: <1202273807.9259.0.camel@localhost.localdomain> (sfid-20080206_045721_632070_8046967A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-02-06 at 00:53 +0100, Sebastian Siewior wrote:
> * Dan Williams | 2008-02-05 10:09:14 [-0500]:
> 
> >That would mean that count never gets above 8, and that the RX queue is
> >never restocked.  The (count >= 8) part might be specific to the
> >3945/4965 drivers, since they apparently restock the RX queue in blocks
> >of 8.  Can you try to change the:
> >
> >if (count >= 8)
> >
> >to
> >
> >if (count)
> >
> >and see what that does for you?  Also, can you log the value of
> >"ipw_rx_queue_space (priv->rxq)" on the same line as your "fill_rx
> >block" printk?
> 
> This gives the following from time to time:
> | [ 3327.863414] fill_rx block, count: 0x00000000 i: 0x0000000e, ipw_rx_queue_space: 0x00000011
> | [ 3329.704780] fill_rx block, count: 0x00000000 i: 0x00000003, ipw_rx_queue_space: 0x00000011
> | [ 3331.532242] fill_rx block, count: 0x00000000 i: 0x0000001a, ipw_rx_queue_space: 0x00000011
> | [ 3333.306232] fill_rx block, count: 0x00000000 i: 0x00000009, ipw_rx_queue_space: 0x00000011
> | [ 3335.062033] fill_rx block, count: 0x00000000 i: 0x00000018, ipw_rx_queue_space: 0x00000011
> | [ 3336.983284] fill_rx block, count: 0x00000000 i: 0x0000000e, ipw_rx_queue_space: 0x00000011
> | [ 3338.792414] fill_rx block, count: 0x00000000 i: 0x00000005, ipw_rx_queue_space: 0x00000011
> | [ 3340.624946] fill_rx block, count: 0x00000000 i: 0x00000012, ipw_rx_queue_space: 0x00000011
> | [ 3343.179358] fill_rx block, count: 0x00000000 i: 0x00000015, ipw_rx_queue_space: 0x00000011
> 
> and I had no firmware restart this time. It seems that it got fixed :)
> thx.

Ok, I'll prepare a final patch then.

Thanks,
Dan


