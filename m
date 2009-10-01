Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60007 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbZJAWtW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 18:49:22 -0400
Date: Thu, 1 Oct 2009 15:44:30 -0700
From: Greg KH <greg@kroah.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "stable@kernel.org" <stable@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [stable] Making Intel WiFi Link 1000 usable in 2.6.31
Message-ID: <20091001224430.GH28208@kroah.com>
References: <1254339259.26521.1645.camel@rc-desk>
 <20090930212447.GB30093@kroah.com>
 <1254350175.26521.1662.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1254350175.26521.1662.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2009 at 03:36:15PM -0700, reinette chatre wrote:
> On Wed, 2009-09-30 at 14:24 -0700, Greg KH wrote:
> > On Wed, Sep 30, 2009 at 12:34:19PM -0700, reinette chatre wrote:
> > > commit cc0f555d511a5fe9d4519334c8f674a1dbab9e3a
> > > Author: Jay Sternberg <jay.e.sternberg@intel.com>
> > > Date:   Fri Jul 17 09:30:16 2009 -0700
> > > 
> > >     iwlwifi: Handle new firmware file with ucode build number in header
> > > 
> > > commit cce53aa347c1e023d967b1cb1aa393c725aedba5
> > > Author: Jay Sternberg <jay.e.sternberg@intel.com>
> > > Date:   Fri Jul 17 09:30:22 2009 -0700
> > > 
> > >     iwlwifi: update 1000 series API version to match firmware
> > > 
> > > commit 02c06e4abc0680afd31bf481a803541556757fb6
> > > Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > > Date:   Fri Jul 17 09:30:14 2009 -0700
> > > 
> > >     iwlagn: modify digital SVR for 1000
> > > 
> > > commit 415e49936b4b29b34c2fb561eeab867d41fc43a6
> > > Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > > Date:   Thu Aug 13 13:30:54 2009 -0700
> > > 
> > >     iwlwifi: traverse linklist to find the valid OTP block
> > > 
> > > commit f7ea097d9b4e61a816c041c92548aad7c7ed7915
> > > Author: Reinette Chatre <reinette.chatre@intel.com>
> > > Date:   Fri Jul 24 11:13:12 2009 -0700
> > > 
> > >     iwlagn: fix null pointer access during ucode load on 1000
> > > 
> > > Thank you very much
> > 
> > Is this the order in which they should be applied?
> 
> The first three patches from this list can be applied directly from
> linux-2.6 in the order they appear here. That is:
> 
> commit cc0f555d511a5fe9d4519334c8f674a1dbab9e3a
> Author: Jay Sternberg <jay.e.sternberg@intel.com>
> Date:   Fri Jul 17 09:30:16 2009 -0700
> 
>     iwlwifi: Handle new firmware file with ucode build number in header
> 
> commit cce53aa347c1e023d967b1cb1aa393c725aedba5
> Author: Jay Sternberg <jay.e.sternberg@intel.com>
> Date:   Fri Jul 17 09:30:22 2009 -0700
> 
>     iwlwifi: update 1000 series API version to match firmware
> 
> commit 02c06e4abc0680afd31bf481a803541556757fb6
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Fri Jul 17 09:30:14 2009 -0700
> 
>     iwlagn: modify digital SVR for 1000
> 
> 
> The fourth patch needed backporting and is attached. 
> 
> After doing the backporting I determined that the fifth patch is not
> needed.
> 
> Thank you very much for taking these patches

Ok, I've taken all of these, but wow, those are big patches, much larger
than we normally take for the -stable tree.

I don't want to have to do this again please.

thanks,

greg k-h
