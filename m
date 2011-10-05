Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:37756 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935524Ab1JEXTa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 19:19:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Yogesh Powar <yogeshp@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 5 Oct 2011 16:14:04 -0700
Subject: RE: mwifiex: add cfg80211 handlers add/del_virtual_intf
Message-ID: <477F20668A386D41ADCC57781B1F704308155974F7@SC-VEXCH1.marvell.com> (sfid-20111006_011933_253278_751D5792)
References: <20111005060744.GB32513@elgon.mountain>
 <477F20668A386D41ADCC57781B1F70430815597445@SC-VEXCH1.marvell.com>
 <20111005195228.GG30887@longonot.mountain>
In-Reply-To: <20111005195228.GG30887@longonot.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Wednesday, October 05, 2011 12:52 PM
> To: Bing Zhao
> Cc: Yogesh Powar; linux-wireless@vger.kernel.org
> Subject: Re: mwifiex: add cfg80211 handlers add/del_virtual_intf
> 
> On Wed, Oct 05, 2011 at 12:08:36PM -0700, Bing Zhao wrote:
> > Since the first element of priv[] cannot be NULL. How about this fix?
> >
> > +       priv = adapter->priv[0];
> > +       BUG_ON(!priv);
> > +
> >         wiphy_unregister(priv->wdev->wiphy);
> >
> 
> I don't know the code at all, so I'll trust you on that.  :)
> 
> But please don't add the BUG_ON().  Calls to BUG_ON() make the code
> messier, and they are more painful than needed for the user.  If we
> don't have the BUG_ON() then we get an Oops and the driver will die,
> but we can still can close our documents and reboot the system.
> 
> Debugging NULL dereference bugs is normally super easy.  Just compile
> with CONFIG_DEBUG_INFO=y, run gdb on the .ko file and type:
> "list *(function_name+0x63)" at the gdb prompt.  Done.

Thanks for the information.

Regards,
Bing

> 
> regards,
> dan carpenter

