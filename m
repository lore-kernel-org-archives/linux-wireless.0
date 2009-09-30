Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52827 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbZI3TAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 15:00:54 -0400
Date: Wed, 30 Sep 2009 14:45:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	stable@kernel.org
Subject: Re: iwl-1000 firmware versions 1 and 2 are nowhere to be found
Message-ID: <20090930184550.GC6364@tuxdriver.com>
References: <4AC39D6F.5070308@canonical.com> <1254334586.26521.1617.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1254334586.26521.1617.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Perhaps these should go in the stable series?

John

On Wed, Sep 30, 2009 at 11:16:26AM -0700, reinette chatre wrote:
> Hi Tim,
> 
> On Wed, 2009-09-30 at 11:03 -0700, Tim Gardner wrote:
> > I've got a user complaining that the iwl-1000 firmware version required
> > by 2.6.31 doesn't exist. Indeed, IWL1000_UCODE_API_MAX is 2, yet the
> > only firmware available from http://intellinuxwireless.org/?n=Downloads
> > is iwlwifi-1000-3.ucode. Shall I just tell him to install compat-wireless ?
> > 
> > BugLink: http://bugs.launchpad.net/bugs/439285
> > 
> 
> 2.6.31 needs a few more patches to fully support 1000 series, among
> these is the patch that can parse a new ucode header format and another
> patch to update the ucode API. 
> 
> Depending on the requirements it may be easier to backport those patches
> or to just use compat-wireless. That will be the user's decision.
> 
> Here is the list of patches:
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
> commit 415e49936b4b29b34c2fb561eeab867d41fc43a6
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Thu Aug 13 13:30:54 2009 -0700
> 
>     iwlwifi: traverse linklist to find the valid OTP block
> 
> commit f7ea097d9b4e61a816c041c92548aad7c7ed7915
> Author: Reinette Chatre <reinette.chatre@intel.com>
> Date:   Fri Jul 24 11:13:12 2009 -0700
> 
>     iwlagn: fix null pointer access during ucode load on 1000
> 
> Reinette
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
