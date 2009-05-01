Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48368 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbZEAUlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 16:41:18 -0400
Received: by fxm2 with SMTP id 2so2494900fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 01 May 2009 13:41:17 -0700 (PDT)
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241193513.10498.97.camel@rc-desk>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk>
Content-Type: text/plain
Date: Fri, 01 May 2009 23:13:12 +0300
Message-Id: <1241208792.7082.47.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-05-01 at 08:58 -0700, reinette chatre wrote:
> Maxim,
> 
> On Fri, 2009-05-01 at 05:00 -0700, Maxim Levitsky wrote:
> > Don't know if this is new regression, or just exposed race condition,
> > but currently using rfkill, and/or s2disk sometimes leaves the card in
> > state in which it can't scan.
> 
> Could you please provide more details of this scenario? 

OK, lets focus on my current setup:

* iwlwifi.git - very close to current head, yesterday HEAD
* disable_hw_scan=1 - this bug is present regardless of this setting,
yet this rules out firmware interactions during rfkill.

* Network Manager - ubuntu 9.04 unmodified.
* wpa_supplicant - close to git HEAD, with one local change:
  It is known that on first attempt scans always fail, with same -EBUSY
  iwlst scan shows 'Device is busy', supplicant complains about scan
requested (ret=-1), ... When this happens supplicant waits for 10
seconds, and I reduced that wait to 1 second.


When this happens, I can't make the card scan, scans always fail, and I
can only reload the module.

Best regards,
	Maxim Levitsky

