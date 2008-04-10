Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbYDJPks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 11:40:48 -0400
Date: Thu, 10 Apr 2008 12:43:41 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Marcelo Tosatti <marcelo@kvack.org>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 3] libertas: convert RSSI to a direct command
Message-ID: <20080410154341.GB6741@dmt> (sfid-20080410_164056_881366_0CEE42F7)
References: <200803261021.48470.hs4233@mail.mn-solutions.de> <1206653042.21106.10.camel@localhost.localdomain> <20080401031530.GA14633@dmt> <200804010848.48789.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200804010848.48789.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 01, 2008 at 08:48:48AM +0200, Holger Schurig wrote:
> > Won't this call block? You can't block in the get_wireless
> > handler (it holds the rtnl lock). See wext_handle_ioctl.
> 
> Yes, this blocks.
> 
> So you mean that when I cannot get a current RSSI value at this 
> time I have to re-use some old value?

All I mean is that get_wireless_stats should not schedule() because it
holds the rtnl_lock. You get ugly hangs doing that.

>   The older code used this 
> schema:
> 
> 
> when associated:
>    get rssi in-the-background and store it away
> 
> when AdHoc network created:
>    get rssi in-the-background and store it away
> 
> 
> in lbs_get_wireless_stats()
>    use stored away RSSI value
>    get rssi in-the-background and store it away
>    
> 
> The problem with this scheme is that the "stored away RSSI" might 
> be an hour ago. So the first call to to get the wireless stats 
> gives you back a blatant lie.
> 
> Do you see a way around this?

Either live with the fact that you need to query the driver a few times
for a reliable result or add a timer to periodically update RSSI.
