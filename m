Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:48729 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab0CSQsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 12:48:17 -0400
Subject: Re: iwl3945 and power saving
From: reinette chatre <reinette.chatre@intel.com>
To: Stefan Monnier <monnier@iro.umontreal.ca>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <jwvr5niiw6r.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
References: <jwvwrxbimib.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
	 <1268804105.2446.620.camel@rchatre-DESK>
	 <jwvr5niiw6r.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 09:48:16 -0700
Message-ID: <1269017296.2446.1777.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-17 at 12:34 -0700, Stefan Monnier wrote:
> Hmm... it seems odd to completely kill the feature rather than to flag
> it as "beware, it's brittle" (e.g. only allow to turn it on with
> "iwconfig wlanX power on-and-I-promise-I-wont-report-a-bug-if-its-buggy").

I do not see a way to communicate this to users. 

> 
> Also, it puzzles me: my 3945 has been working fine with power-saving for
> more than 2 years (and earlier with ipw3945 as well) and I haven't
> noticed any unreliability.  Have I just been lucky or did the problem
> only start to manifest in more "recent" versions of the driver, for
> reasons we don't understand?

The previous power saving implementation was very simple. Nothing was
directed from upper layers and user had to manually choose a power
index, which is communicated to device once and device remained in that
power saving state from then on. Recent advances in power saving meant
that more was asked from devices as they were asked to enter and exit
power saving frequently. This new behavior is what is causing issues in
3945 and 4965.

Reinette


