Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53083 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760418AbYBEXxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 18:53:51 -0500
Date: Wed, 6 Feb 2008 00:53:44 +0100
From: Sebastian Siewior <ipw+2200@ml.breakpoint.cc>
To: Dan Williams <dcbw@redhat.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org, ipw2100-devel@lists.sourceforge.net
Subject: Re: ipw2200 stalls on high load
Message-ID: <20080205235344.GA2507@Chamillionaire.breakpoint.cc> (sfid-20080205_235355_055877_436DC104)
References: <20080126132939.GA22630@Chamillionaire.breakpoint.cc> <D936D925018D154694D8A362EEB0892003800B1B@orsmsx416.amr.corp.intel.com> <20080130225738.GB2648@Chamillionaire.breakpoint.cc> <D936D925018D154694D8A362EEB08920038F4382@orsmsx416.amr.corp.intel.com> <1202128649.10632.4.camel@localhost.localdomain> <D936D925018D154694D8A362EEB0892003947453@orsmsx416.amr.corp.intel.com> <20080204224502.GA22717@Chamillionaire.breakpoint.cc> <1202167450.5190.2.camel@localhost.localdomain> <20080205083511.GA28623@Chamillionaire.breakpoint.cc> <1202224154.1243.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <1202224154.1243.7.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Dan Williams | 2008-02-05 10:09:14 [-0500]:

>That would mean that count never gets above 8, and that the RX queue is
>never restocked.  The (count >= 8) part might be specific to the
>3945/4965 drivers, since they apparently restock the RX queue in blocks
>of 8.  Can you try to change the:
>
>if (count >= 8)
>
>to
>
>if (count)
>
>and see what that does for you?  Also, can you log the value of
>"ipw_rx_queue_space (priv->rxq)" on the same line as your "fill_rx
>block" printk?

This gives the following from time to time:
| [ 3327.863414] fill_rx block, count: 0x00000000 i: 0x0000000e, ipw_rx_queue_space: 0x00000011
| [ 3329.704780] fill_rx block, count: 0x00000000 i: 0x00000003, ipw_rx_queue_space: 0x00000011
| [ 3331.532242] fill_rx block, count: 0x00000000 i: 0x0000001a, ipw_rx_queue_space: 0x00000011
| [ 3333.306232] fill_rx block, count: 0x00000000 i: 0x00000009, ipw_rx_queue_space: 0x00000011
| [ 3335.062033] fill_rx block, count: 0x00000000 i: 0x00000018, ipw_rx_queue_space: 0x00000011
| [ 3336.983284] fill_rx block, count: 0x00000000 i: 0x0000000e, ipw_rx_queue_space: 0x00000011
| [ 3338.792414] fill_rx block, count: 0x00000000 i: 0x00000005, ipw_rx_queue_space: 0x00000011
| [ 3340.624946] fill_rx block, count: 0x00000000 i: 0x00000012, ipw_rx_queue_space: 0x00000011
| [ 3343.179358] fill_rx block, count: 0x00000000 i: 0x00000015, ipw_rx_queue_space: 0x00000011

and I had no firmware restart this time. It seems that it got fixed :)
thx.

Sebastian
