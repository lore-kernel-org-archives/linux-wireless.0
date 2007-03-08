Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36108 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030268AbXCHIbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 03:31:46 -0500
Date: Thu, 8 Mar 2007 08:31:18 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Marcelo Tosatti <marcelo@kvack.org>,
	Jeff Garzik <jeff@garzik.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Please pull 'libertas' branch of wireless-2.6
Message-ID: <20070308083118.GA3532@infradead.org>
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org> <20070304153627.GA32380@dmt> <20070305140825.GA9982@infradead.org> <20070307181638.GA22305@dmt> <20070307222404.GA23393@infradead.org> <1173321651.12017.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1173321651.12017.6.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 07, 2007 at 09:40:51PM -0500, Dan Williams wrote:
> That means, for example, the prism2 WPA ioctls, because WE-19 has
> equivalent functionality.  Other examples include many of the madwifi
> ioctls like auth_mode for which there are WEXT calls.  Others include
> the ones for creating virtual STAs that are now subsumed by mac80211.
> 
> For stuff that's seriously not common among drivers, there's nothing
> else that drivers can do but provide private ioctls.

No, we're more than unhappy with private knobs in general.  Each and
every of them needs an good explanation on

 a) why it's needed
 b) why you can use an existing common interface
 c) why it doesn't make sense to add a new common interface

see all the discussion on this on say netdev or linux-scsi.

Realize it, private interfaces are really bad, it means you need
special userspace for a single driver, that's exactly the thing
we try to avoid at all cost.

