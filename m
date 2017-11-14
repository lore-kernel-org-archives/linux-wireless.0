Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56467 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753507AbdKNLsT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 06:48:19 -0500
Date: Tue, 14 Nov 2017 12:48:24 +0100
From: Greg KH <greg@kroah.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: Thomas Backlund <tmb@mageia.org>, linux-wireless@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: fix firmware names for 9xxx and a0 series hw
Message-ID: <20171114114824.GA26814@kroah.com> (sfid-20171114_124828_372074_8C1544CD)
References: <20171114103751.7761-1-tmb@mageia.org>
 <1510656721.4011.87.camel@coelho.fi>
 <2131d658-8a6e-2f3b-4e44-a3206385af46@mageia.org>
 <1510659500.4011.90.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1510659500.4011.90.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 14, 2017 at 01:38:20PM +0200, Luciano Coelho wrote:
> On Tue, 2017-11-14 at 13:29 +0200, Thomas Backlund wrote:
> > Den 14-11-2017 kl. 12:52, skrev Luca Coelho:
> > > On Tue, 2017-11-14 at 12:37 +0200, Thomas Backlund wrote:
> > > > iwlwifi 9xxx and a0 series hw contains an extra dash in firmware
> > > > file
> > > > name
> > > > as seeen in modinfo output for kernel 4.14:
> > > > 
> > > > firmware:       iwlwifi-9260-th-b0-jf-b0--34.ucode
> > > > firmware:       iwlwifi-9260-th-a0-jf-a0--34.ucode
> > > > firmware:       iwlwifi-9000-pu-a0-jf-b0--34.ucode
> > > > firmware:       iwlwifi-9000-pu-a0-jf-a0--34.ucode
> > > > firmware:       iwlwifi-QuQnj-a0-hr-a0--34.ucode
> > > > firmware:       iwlwifi-QuQnj-a0-jf-b0--34.ucode
> > > > firmware:       iwlwifi-QuQnj-f0-hr-a0--34.ucode
> > > > firmware:       iwlwifi-Qu-a0-jf-b0--34.ucode
> > > > firmware:       iwlwifi-Qu-a0-hr-a0--34.ucode
> > > > 
> > > > Fix that by dropping the extra adding of '"-"'.
> > > > 
> > > > Signed-off-by: Thomas Backlund <tmb-odJJhXpcy38dnm+yROfE0A@public
> > > > .gmane.org>
> > > > cc: Luca Coelho <luciano.coelho-ral2JQCrhuEAvxtiuMwx3w@public.gma
> > > > ne.org>
> > > > cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > 
> > > > ---
> > > 
> > > Looks good, thanks!
> > > 
> > > Though I'm not sure this is worth sending to stable... Why do you
> > > think
> > > it's needed?
> > > 
> > 
> > As 4.14 is a -longterm kernel and afaik atleast 9xxx series hw is
> > out 
> > there I thought it would be good to have it fixed there...
> > 
> > but in the end it's your call for upstream stable or not
> > 
> > I'll add it to the Mageia distrib kernels anyway.
> 
> Okay, fair enough.  I'll add it to stable, it's a very simple and not
> risky fix anyway.  One can claim that userspace may get confused. 
> Actually I think some distros use those values to check which firmwares
> need to be installed, but I don't recall for sure now.

The install scripts use those values, so yes, it would be good to have
them be correct.

thanks,

greg k-h
