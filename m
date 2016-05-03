Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34795 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903AbcECNOH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 09:14:07 -0400
Message-ID: <1462281243.2251.2.camel@sipsolutions.net> (sfid-20160503_151411_912191_4AA8C343)
Subject: Re: dynamic ps + offchannel mgmt_tx + HW RoC
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 03 May 2016 15:14:03 +0200
In-Reply-To: <CABPxzYLtu53V79O--eDJEdRfn-zw3Wq9Po04F=uFp_FrfJjuiA@mail.gmail.com> (sfid-20160503_145337_966449_6F26A629)
References: <CABPxzYLtu53V79O--eDJEdRfn-zw3Wq9Po04F=uFp_FrfJjuiA@mail.gmail.com>
	 (sfid-20160503_145337_966449_6F26A629)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-05-03 at 18:23 +0530, Krishna Chaitanya wrote:
> Hi,
> 
> When the HW is in PS and Dynamic PS is enabled we are dropping
> all the offchannel frames. Sequence is as below
> 
> if hw is in PS: stop_queues reason=PS, queue dynamic_ps_disable_work
> send Offchannel mgmt_tx
> drop the packet because offchanel + stop_reasons[q] !=0
> 
> How should we handle this? SW RoC is handling this
> by checking for offchannel and bringing the HW out of PS before
> handing the packet to TX path, so it works fine.

You should handle this by not doing such a non-sensical thing and
finally implementing powersave properly in the driver :)

johannes
