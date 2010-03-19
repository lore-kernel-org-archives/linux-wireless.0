Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from harpie.cc.umontreal.ca ([132.204.2.134]:39784 "EHLO
	harpie.CC.UMontreal.CA" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0CTBrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 21:47:51 -0400
From: Stefan Monnier <monnier@IRO.UMontreal.CA>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwl3945 and power saving
Message-ID: <jwvd3z010ar.fsf-monnier+inbox@gnu.org>
References: <jwvwrxbimib.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
	<1268804105.2446.620.camel@rchatre-DESK>
	<jwvr5niiw6r.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
	<1269017296.2446.1777.camel@rchatre-DESK>
Date: Fri, 19 Mar 2010 17:41:17 -0400
In-Reply-To: <1269017296.2446.1777.camel@rchatre-DESK> (reinette chatre's
	message of "Fri, 19 Mar 2010 09:48:16 -0700")
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Hmm... it seems odd to completely kill the feature rather than to flag
>> it as "beware, it's brittle" (e.g. only allow to turn it on with
>> "iwconfig wlanX power on-and-I-promise-I-wont-report-a-bug-if-its-buggy").
> I do not see a way to communicate this to users. 

No, indeed ;-)

> The previous power saving implementation was very simple.  Nothing was
> directed from upper layers and user had to manually choose a power
> index, which is communicated to device once and device remained in
> that power saving state from then on.  Recent advances in power saving
> meant that more was asked from devices as they were asked to enter and
> exit power saving frequently.  This new behavior is what is causing
> issues in 3945 and 4965.

Aha!  That's very interesting, then.  So, given that the previous naive
power-saving implementation worked well for me (and I presume other
users as well), would it be possible to use/provide that old naive
technique for 3945 and 4965?

Or does the new technique change too much of the structure of the code
that the naive technique can't be used any more?
Could someone kindly point me to the most relevant commits that changed
the power management technique, if it all possible?

Would reverting "iwlwifi: unify iwlagn and 3945 power save management"
be a possible starting point (probably not for a patch that I intend to
submit back for inclusion, but I'm thinking more for a patch for my own
personal use, or more likely just to start trying to understand what's
going on)?


        Stefan
