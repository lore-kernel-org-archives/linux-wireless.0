Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47350 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725981AbeIFNS4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:18:56 -0400
Message-ID: <aa36d7cb91ef0aea757b46623c8d5bef8d61bc40.camel@coelho.fi> (sfid-20180906_104436_949074_E49308E0)
From: Luca Coelho <luca@coelho.fi>
To: Hao Wei Tee <angelsl@in04.sg>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>
Date: Thu, 06 Sep 2018 11:44:30 +0300
In-Reply-To: <2ee6e4d9-d555-c29b-815d-3e66890189bc@in04.sg>
References: <20180821063657.30071-1-luca@coelho.fi>
         <20180821063657.30071-15-luca@coelho.fi>
         <2ee6e4d9-d555-c29b-815d-3e66890189bc@in04.sg>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 14/15] iwlwifi: mvm: Send LQ command as async when
 necessary
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-09-06 at 16:22 +0800, Hao Wei Tee wrote:
> Hi,

Hi Hao Wei,


> On 21/8/18 2:36 PM, Luca Coelho wrote:
> > From: Avraham Stern <avraham.stern@intel.com>
> > 
> > The parameter that indicated whether the LQ command should be sent
> > as sync or async was removed, causing the LQ command to be sent as
> > sync from interrupt context (e.g. from the RX path). This resulted
> > in a kernel warning: "scheduling while atomic" and failing to send
> > the LQ command, which ultimately leads to a queue hang.
> > 
> > Fix it by adding back the required parameter to send the command as
> > sync only when it is allowed.
> > 
> > Fixes: d94c5a820d10 ("iwlwifi: mvm: open BA session only when sta is authorized")
> > Signed-off-by: Avraham Stern <avraham.stern@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> I'm not sure whether you guys normally send fixes to stable, but this
> really should go to stable. I run into this bug as often as a few times
> an hour and sometimes it leads to IRQs from other devices being dropped
> (e.g. touchpad, in turn causing the driver to timeout and quit, and the
> touchpad dies).

We do send things for stable and the "Fixes" tag included in this patch
will cause it to be automatically considered for the stable releases
that contain the commit it points to.  So we should be fine here.

If you notice that, for some reason, this doesn't end up applied in the
specific stable kernel you need it on, please let us know and we'll
check it out.  Also note that anyone can suggest any patch to stable
releases, there's a process[1] in place for that.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/stable-kernel-rules.rst

Thanks for your contribution!

--
Cheers,
Luca.
