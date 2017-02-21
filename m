Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38323 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751161AbdBUURT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 15:17:19 -0500
Date: Tue, 21 Feb 2017 21:17:15 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
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
Subject: Re: [RFC 2/5] iwlwifi: fix request_module() use
Message-ID: <20170221201715.GZ31264@wotan.suse.de> (sfid-20170221_211728_915941_54B7FF00)
References: <20170217020903.6370-1-mcgrof@kernel.org>
 <20170217020903.6370-3-mcgrof@kernel.org>
 <0BA3FCBA62E2DC44AF3030971E174FB3A8F4AE27@hasmsx107.ger.corp.intel.com>
 <20170221022337.GG31264@wotan.suse.de>
 <0BA3FCBA62E2DC44AF3030971E174FB3A8F4DEAB@hasmsx107.ger.corp.intel.com>
 <20170221181541.GN31264@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170221181541.GN31264@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 21, 2017 at 07:15:41PM +0100, Luis R. Rodriguez wrote:
> On Tue, Feb 21, 2017 at 07:16:16AM +0000, Grumbach, Emmanuel wrote:
> > > 
> > > a) just remove the print and use instead request_module_nowait() (this is
> > > more in alignment of what your code actually does today; or
> > > 
> > > b) fix the request_module() use so that the error print matches the
> > > expected and proper recommended use of request_module() (what this patch
> > > does)
> > > 
> > > I prefer a) actually but I had to show what b) looked like first :)
> >
> > Me too. Let's do the simple thing. After all, it's been working for 5 years
> > now (maybe more?) and I don't see a huge need to verify that the opmode
> > module has been loaded.  It is very unlikely to fail anyway, and in the case
> > it did fail, it's not that we can do much from iwlwifi point of view. 
> 
> I tend to agree with you on this, retries would be the only sensible thing to
> do, but why do that -- the error should be logged right and addressed by any
> upper layers. Its one reason to consider in the future adding verifiers
> as built-in optional part of module loading.

It would seem we still need to offload the opmode start as it is the one that
really should be issuing the completion, otherwise we would end up sending a
completion while the opmode module is being loaded asynchronously. The changes
are for that are still very likely desirable as it should help with speeding
boot up.

So the sharing of the opcode start will go first.

Will send v2.

  Luis
