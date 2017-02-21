Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:62673 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751214AbdBUHQW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 02:16:22 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
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
Subject: RE: [RFC 2/5] iwlwifi: fix request_module() use
Date: Tue, 21 Feb 2017 07:16:16 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3A8F4DEAB@hasmsx107.ger.corp.intel.com> (sfid-20170221_081701_268901_71DB0393)
References: <20170217020903.6370-1-mcgrof@kernel.org>
 <20170217020903.6370-3-mcgrof@kernel.org>
 <0BA3FCBA62E2DC44AF3030971E174FB3A8F4AE27@hasmsx107.ger.corp.intel.com>
 <20170221022337.GG31264@wotan.suse.de>
In-Reply-To: <20170221022337.GG31264@wotan.suse.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> On Sun, Feb 19, 2017 at 09:47:59AM +0000, Grumbach, Emmanuel wrote:
> > >
> > > The return value of request_module() being 0 does not mean that the
> > > driver which was requested has loaded. To properly check that the
> > > driver was loaded each driver can use internal mechanisms to vet the
> > > driver is now present. The helper try_then_request_module() was
> > > added to help with this, allowing drivers to specify their own validation as
> the first argument.
> > >
> > > On iwlwifi the use case is a bit more complicated given that the
> > > value we need to check for is protected with a mutex later used on
> > > the
> > > module_init() of the module we are asking for. If we were to lock
> > > and
> > > request_module() we'd deadlock. iwlwifi needs its own wrapper then
> > > so it can handle its special locking requirements.
> > >
> > > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> >
> > I don't see the problem with the current code. We don't assume that
> > everything has been loaded immediately after request_module returns.
> > We just free the intermediate firmware structures that won't be using
> > anymore. What happens here is that after request_module returns, we
> > patiently wait until it is loaded, and when that happens, iwl{d,m}vm's init
> function will be called.
> 
> Right I get that.
> 
> The code today complains if its respective opmode module was not loaded if
> request_module() did not return 0. As the commit log explains, relying on a
> return code of 0 to ensure a module loads is not sufficient. So the current
> print is almost pointless, so best we either:
> 
> a) just remove the print and use instead request_module_nowait() (this is
> more
>    in alignment of what your code actually does today; or
> 
> b) fix the request_module() use so that the error print matches the
> expected
>    and proper recommended use of request_module() (what this patch does)
> 
> I prefer a) actually but I had to show what b) looked like first :)
> 

Me too. Let's do the simple thing. After all, it's been working for 5 years now (maybe more?)
and I don't see a huge need to verify that the opmode module has been loaded.
It is very unlikely to fail anyway, and in the case it did fail, it's not that we can do much
from iwlwifi point of view. iwlwifi will stay loaded and sit idle since no opmode will
be there to start using the hardware. We will keep having the device claimed, and will
keep the interrupt registered and all that. No WiFi for you, but no harm caused either.
