Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23167 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab1GXXhq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jul 2011 19:37:46 -0400
Subject: Re: [PATCH] iwlagn: wrap suspend/resume definitions in CONFIG_PM
 block
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110724203956.GA29630@tuxdriver.com>
References: <20110724.030949.1727841105144911931.davem@davemloft.net>
	 <1311535150-28686-1-git-send-email-linville@tuxdriver.com>
	 <20110724.130840.1093555047179460794.davem@davemloft.net>
	 <20110724203956.GA29630@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Jul 2011 16:01:07 -0700
Message-ID: <1311548467.5579.119.camel@wwguy-huron> (sfid-20110725_013812_495807_70FDB0F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-07-24 at 13:39 -0700, John W. Linville wrote:
> On Sun, Jul 24, 2011 at 01:08:40PM -0700, David Miller wrote:
> > From: "John W. Linville" <linville@tuxdriver.com>
> > Date: Sun, 24 Jul 2011 15:19:10 -0400
> > 
> > > drivers/net/wireless/iwlwifi/iwl-agn.c:3464: error: unknown field 'suspend' specified in initializer
> > > drivers/net/wireless/iwlwifi/iwl-agn.c:3464: warning: initialization from incompatible pointer type
> > > drivers/net/wireless/iwlwifi/iwl-agn.c:3465: error: unknown field 'resume' specified in initializer
> > > drivers/net/wireless/iwlwifi/iwl-agn.c:3465: warning: initialization from incompatible pointer type
> > > 
> > > This was caused by commit c8ac61cf ("iwlagn: implement WoWLAN").
> > > 
> > > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > 
> > Since I already minimally fixed up my build locally last night I know
> > that your patch leads to a set of warnings because the methods whose
> > hookup are now commented out become completely unused and they are all
> > marked "static".  And recursively functions that those methods use
> > become unused too.
> > 
> > Did you turn off CONFIG_PM and test the build of this file to see
> > what the compiler actually does with it?
> > 
> > I'm checking in the following, but I expect much better from you John.
> 
> Sorry, Dave.  I confess that I was hoping for a quick fix on a Sunday afternoon. :-)
> 
> Thanks for making it better!
> 
> John
My mistake to not catch this to begin with, sorry for cause all the
trouble.

Wey

