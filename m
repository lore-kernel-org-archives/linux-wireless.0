Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab1BIGpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 01:45:19 -0500
Date: Wed, 9 Feb 2011 07:45:18 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] iwl3945: use software scanning by default
Message-ID: <20110209064517.GE2184@redhat.com>
References: <1297172211-17448-1-git-send-email-sgruszka@redhat.com>
 <1297180207.20613.41.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297180207.20613.41.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 08, 2011 at 07:50:07AM -0800, wwguy wrote:
> On Tue, 2011-02-08 at 05:36 -0800, Stanislaw Gruszka wrote:
> > Looking for some more testing and opinions.
> > 
> > Patch fixes:
> > https://bugzilla.redhat.com/show_bug.cgi?id=671366
> > and probably some other "very poor performance" bugs reported
> > elsewhere.
> > 
> > Sometimes after hardware scanning device is unable to receive frames
> > at higher rate, what cause that very slow speed is observed by the users.
> > 
> > To workaround problem we can use software scanning. Patch remove
> > "deprecated" warning and make sw scan be used by default on 3945.
> > 
> > On older kernels, in particular 2.6.35, software scanning does not
> > fix problem. On my setup, not affected by bug, I can see slow speed
> > with software scans on 2.6.35 as well. I'm not quite sure why. Anyway
> > on upstream patch works good for me and bug reporter.

[snip]

> > -MODULE_PARM_DESC(disable_hw_scan,
> > -		 "disable hardware scanning (default 0) (deprecated)");
> > +MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 1)");
> >  module_param_named(fw_restart3945, iwl3945_mod_params.restart_fw, int, S_IRUGO);
> >  MODULE_PARM_DESC(fw_restart3945, "restart firmware in case of error");
> >  
> 
> don't have much experience with 3945, but not sure setting sw scan by
> default is the right choice?

Definitely hw scan is bad choice for some users.

I'll will provide patch for some more users to test, to see if
it not causing regression. On my laptop with iwl3945 it works
well with upstream kernel and bad with 2.6.35.

I'm not quite sure, why sw scaning improved currently.
I thought commit df13cce53a7b28a81460e6bfc4857e9df4956141
"mac80211: Improve software scan timing" fix things, but that
commit is also on 2.6.35 .

Stanislaw

