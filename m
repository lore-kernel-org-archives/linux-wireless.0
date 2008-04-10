Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbYDJTLX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 15:11:23 -0400
Date: Thu, 10 Apr 2008 16:08:58 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	Marcelo Tosatti <marcelo@kvack.org>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 3] libertas: convert RSSI to a direct command
Message-ID: <20080410190858.GA8969@dmt> (sfid-20080410_201129_747022_AA22B0F5)
References: <200803261021.48470.hs4233@mail.mn-solutions.de> <1206653042.21106.10.camel@localhost.localdomain> <20080401031530.GA14633@dmt> <200804010848.48789.hs4233@mail.mn-solutions.de> <20080410154341.GB6741@dmt> <1207842441.13354.9.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1207842441.13354.9.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 10, 2008 at 05:47:21PM +0200, Johannes Berg wrote:
> On Thu, 2008-04-10 at 12:43 -0300, Marcelo Tosatti wrote:
> > On Tue, Apr 01, 2008 at 08:48:48AM +0200, Holger Schurig wrote:
> > > > Won't this call block? You can't block in the get_wireless
> > > > handler (it holds the rtnl lock). See wext_handle_ioctl.
> > > 
> > > Yes, this blocks.
> > > 
> > > So you mean that when I cannot get a current RSSI value at this 
> > > time I have to re-use some old value?
> > 
> > All I mean is that get_wireless_stats should not schedule() because it
> > holds the rtnl_lock. You get ugly hangs doing that.
> 
> Of course you can schedule with the rtnl held. It's a mutex, after all.

True, my bad. The problem is:

    dev_seq_start
    read_lock(&dev_base_lock)
    wireless_seq_show
    wireless_seq_printf_stats
    get_wireless_stats
    dev->wireless_handlers->get_wireless_stats


