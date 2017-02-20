Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753355AbdBTRcV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 12:32:21 -0500
Date: Mon, 20 Feb 2017 18:32:16 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "zajec5@gmail.com" <zajec5@gmail.com>,
        "jeyu@redhat.com" <jeyu@redhat.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/5] iwlwifi: fix drv cleanup on opmode registration failure
Message-ID: <20170220173216.GD31264@wotan.suse.de> (sfid-20170220_183247_105404_4CDCDEE9)
References: <20170217020903.6370-1-mcgrof@kernel.org>
 <20170217020903.6370-2-mcgrof@kernel.org>
 <0BA3FCBA62E2DC44AF3030971E174FB3A8F4AD47@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB3A8F4AD47@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 19, 2017 at 09:16:01AM +0000, Grumbach, Emmanuel wrote:
> > This should in theory fix a detangled drv from the drv list should either of the
> > opmode modules loaded and handled registration for the drv.
> > 
> > The path of having the opmode registration deal with the drv opmode start is
> > actually the more common path. The other path, from the async callback is
> > rathe rare (1/8 or so times for me) -- it happens when the the opmode
> > driver's init routine completed prior to the driver's async callback opmode
> > start call.
> 
> I'd claim it should never happen unless you have several devices on the system using the same
> opmode, or unless you do:
> modprobe iwlwifi  #which will load iwl{d,m}vm
> rmmod iwl{d,m}vm #and do _not_ remove iwlwifi
> modprobe iwlwifi

That is indeed one way one can easily reproduce this. There are however other
ways too. Try a loop of

modprobe -r iwlmvm (which removes iwlwifi) followed by modprobe iwlmvm;

while this check for which path is taken, or better yet check if the
list of drvs is empty on opmode registration. Every now and then I see
the list is empty.

I have a feeling this is then also a rare rarely observed by your QA team
as well, so this code then is also stitching together a set of sequence
calls for both paths.

> > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > ---
> 
> Luca is OOO,  but this looks fine to me.

Reviewed-by ?

  Luis
