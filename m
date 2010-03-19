Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25225 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab0CSWJZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 18:09:25 -0400
Subject: Re: iwl3945 and power saving
From: reinette chatre <reinette.chatre@intel.com>
To: Stefan Monnier <monnier@IRO.UMontreal.CA>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <jwvd3z010ar.fsf-monnier+inbox@gnu.org>
References: <jwvwrxbimib.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
	 <1268804105.2446.620.camel@rchatre-DESK>
	 <jwvr5niiw6r.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
	 <1269017296.2446.1777.camel@rchatre-DESK>
	 <jwvd3z010ar.fsf-monnier+inbox@gnu.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 15:09:24 -0700
Message-ID: <1269036564.2446.1887.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-19 at 14:41 -0700, Stefan Monnier wrote:
> Aha!  That's very interesting, then.  So, given that the previous naive
> power-saving implementation worked well for me (and I presume other
> users as well), would it be possible to use/provide that old naive
> technique for 3945 and 4965?

We could look into this. Could you please submit a request for this
change to http://bugzilla.intellinuxwireless.org/ ?


> Or does the new technique change too much of the structure of the code
> that the naive technique can't be used any more?
> Could someone kindly point me to the most relevant commits that changed
> the power management technique, if it all possible?

A lot has changed in this area in the last few kernel versions. 

> Would reverting "iwlwifi: unify iwlagn and 3945 power save management"
> be a possible starting point (probably not for a patch that I intend to
> submit back for inclusion, but I'm thinking more for a patch for my own
> personal use, or more likely just to start trying to understand what's
> going on)?

If I remember correctly the patch you refer to only removed duplicated
code.

If there is a need for this then I think what can be done here is either
use the current debugfs "sleep_level_override" or maybe some new one to
get to the old behavior. Currently modifying this value will be ignored
if power saving is marked as broken, as is done for 3945. I wonder if we
can modify it such that user can change this setting even if power
saving is marked as broken. This is maybe something you can try out.

Reinette



