Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:32878 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYAKCig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 21:38:36 -0500
Received: by rv-out-0910.google.com with SMTP id k20so779003rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 18:38:36 -0800 (PST)
Message-ID: <b25c3fa70801101838o7a71cc60h1c8b8a71624aeff9@mail.gmail.com> (sfid-20080111_023841_812038_56B6DFFC)
Date: Fri, 11 Jan 2008 11:38:36 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [ipw3945-devel] [PATCH 2/5] iwlwifi: iwl3945 synchronize interruptand tasklet for down iwlwifi
Cc: "Zhu, Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <D936D925018D154694D8A362EEB0892003602E2D@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11998765481610-git-send-email-joonwpark81@gmail.com>
	 <D936D925018D154694D8A362EEB08920035CCD70@orsmsx416.amr.corp.intel.com>
	 <b25c3fa70801101724he91d934y9db6636c68a32486@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892003602E2D@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/11, Chatre, Reinette <reinette.chatre@intel.com>:
>
> On Thursday, January 10, 2008 5:25 PM, Joonwoo Park  wrote:
>
> > 2008/1/11, Chatre, Reinette <reinette.chatre@intel.com>:
> >>
> >> Could synchronize_irq() be moved into iwl_disable_interrupts() ? I am
> >
> > At this time, iwl_disable_interrupts() can be called with irq
> > disabled, so for do that I think additional modification would be
> > needed.
>
> If this is the case where iwl_disable_interrupts() is called while in
> the ISR (where interrupts are disabled), then this behavior may be what
> we want as synchronize_irq() (as I understand) waits for the handler to
> complete irrespective of irq enable/disable.

I agree with you and it's what I want. the meaning 'irq disabled' was local irq.
I'm sorry for confusing.

>
> What modification are you considering?

Roughly, I'm considering make synchronize_irq() be moved into
iwl_disable_interrupts() and fix iwl_irq_tasket not to call
iwl_disable_interrupts with irq disabled.
For now iwl_irq_tasklet calls iwl_disable_interrupts() with local irq disabled.
like this:

static void iwl_irq_tasklet(struct iwl_priv *priv)
{
        ...
        spin_lock_irqsave(&priv->lock, flags);

        ...
        /* Now service all interrupt bits discovered above. */
        if (inta & CSR_INT_BIT_HW_ERR) {
                IWL_ERROR("Microcode HW error detected.  Restarting.\n");

                /* Tell the device to stop sending interrupts */
                iwl_disable_interrupts(priv);
                ...
                spin_unlock_irqrestore(&priv->lock, flags);
                return;
        }


>
> >> also wondering if we cannot call tasklet_kill() before
> >> iwl_disable_interrupts() ... thus preventing it from being scheduled
> >> when we are going down.
> >
> > Thanks for your catch, it seems tasklet can re-enable interrupts.
> > I'll handle and make an another patch for them at this weekend :)
>
> Please think it through also as I am exploring with you ...

Thanks again your comments.

Thanks,
Joonwoo
