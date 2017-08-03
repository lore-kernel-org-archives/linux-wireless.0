Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51369 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751940AbdHCLe2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 07:34:28 -0400
Date: Thu, 3 Aug 2017 13:34:25 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Weinehall, David" <david.weinehall@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Sharon, Sara" <sara.sharon@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [linuxwifi] x86/thermal: AB-BA dependency between mvm->mutex
 and tz->lock
In-Reply-To: <1501759724.15969.49.camel@intel.com>
Message-ID: <alpine.LSU.2.20.1708031330570.30597@cbobk.fhfr.pm> (sfid-20170803_133441_875744_6CD89E95)
References: <alpine.LSU.2.20.1707311300440.4705@cbobk.fhfr.pm>  <alpine.LSU.2.20.1708031107230.30597@cbobk.fhfr.pm>  <1501753405.15969.43.camel@intel.com>  <87vam5nf4w.fsf@kamboji.qca.qualcomm.com> <1501759724.15969.49.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 3 Aug 2017, Coelho, Luciano wrote:

> Okay, so as I understand it the problem has been there for a long time,
> but the splat is only coming up now because of Thomas' patch that adds
> the lockdep map[1], right?

Yeah, sorry, forgot to mention that pre-49dfe2a67797 kernels wouldn't 
produce this, as there would not be aware of the fact that 
cpus_read_lock() is actually semantically a lock.

> I see the workqueue allocation you mentioned.  I'll try to move this 
> allocation out of the mutex and see how it goes.

I have been briefly looking into this as well -- it'll basically have to 
be moved out of the trans_pcie->mutex context, but

(a) I'm not sure whether that's actually safe
(b) iwl_pcie_rx_reuse_rbd() (which is where corresponding work is being 
    queued) is not a proper context either (it's atomic context)

Thanks,

-- 
Jiri Kosina
SUSE Labs
