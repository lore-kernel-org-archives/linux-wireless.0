Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41068 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755178AbeDWN2Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 09:28:25 -0400
Message-ID: <d2b53308a01ed73d15a1c5e80c51c9257c35ef7c.camel@coelho.fi> (sfid-20180423_152846_012913_9E2CD4FE)
From: Luca Coelho <luca@coelho.fi>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ayala Beker <ayala.beker@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 23 Apr 2018 16:28:20 +0300
In-Reply-To: <2769dd4501a9132f638202fece264de32218860d.camel@intel.com>
References: <20180423120513.GS2173@lahna.fi.intel.com>
         <2769dd4501a9132f638202fece264de32218860d.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [BUG] iwlwifi: Microcode SW error detected.  Restarting
 0x2000000.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-04-23 at 15:39 +0300, Luciano Coelho wrote:
> On Mon, 2018-04-23 at 15:05 +0300, Mika Westerberg wrote:
> > Hi,
> 
> Hi Mika,
> 
> 
> > On my Lenovo X1 Carbon gen 5 system,after I upgraded to v4.17-rc1
> > iwlwifi started to fail with following splats on dmesg:
> > 
> >   iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting
> > 0x2000000.
> >   iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
> >   iwlwifi 0000:04:00.0: Status: 0x00000100, count: 6
> >   iwlwifi 0000:04:00.0: Loaded firmware version: 31.560484.0
> >   iwlwifi 0000:04:00.0: 0x00000038 | BAD_COMMAND                 
> 
> [...]
> 
> > The controller in question is:
> > 
> >   04:00.0 Network controller [0280]: Intel Corporation Wireless
> > 8265
> > / 8275 [8086:24fd] (rev 88)
> > 
> > Bisection pointed to the following commit and after I reverted it,
> > things seem to work fine again:
> >   
> >   66fa2424df16 ("iwlwifi: fw api: support the new scan request FW
> > API
> > version")
> > 
> > Any idea what might be wrong with that commit and how to fix it
> > properly?
> 
> We had a bug in the scan command size for older firmwares.  I have
> already made a fix for it, but I hadn't sent it out for upstream
> yet. 
> I'll send it out now and soon send you a link to it in patchwork.

Here's the patch that solves the problem with older FWs:

https://patchwork.kernel.org/patch/10356987/

--
Cheers,
Luca.
