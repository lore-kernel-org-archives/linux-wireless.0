Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49602 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752209AbdLHMfX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:35:23 -0500
Message-ID: <1512736519.4827.287.camel@coelho.fi> (sfid-20171208_133527_530063_CFEB3254)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date: Fri, 08 Dec 2017 14:35:19 +0200
In-Reply-To: <87vahhflsf.fsf@purkki.adurom.net>
References: <20171125153510.25359-1-luca@coelho.fi>
         <20171125153510.25359-7-luca@coelho.fi>
         <87mv351iys.fsf@kamboji.qca.qualcomm.com>
         <1511951353.4827.27.camel@coelho.fi>
         <87efo5s93p.fsf@kamboji.qca.qualcomm.com>
         <87vahhflsf.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 6/6] iwlwifi: fix access to prph when transport is
 stopped
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-08 at 14:26 +0200, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
> > Luca Coelho <luca@coelho.fi> writes:
> > 
> > > On Wed, 2017-11-29 at 12:23 +0200, Kalle Valo wrote:
> > > 
> > > > But no wonder I called gnus-article-fill-cited-article, the
> > > > commit
> > > > log is just weirdly wrapped. Are you using outlook or how do
> > > > you get
> > > > it so ugly? :)
> > > 
> > > Heh! I don't think it's wrapped weirdly, it's just that the
> > > paragraphs
> > > don't have spaces between them, right? ;)
> > 
> > Sorry, don't get what you mean with missing spaces. To me (and
> > patchwork[1] and git[2] seem to agree) the word wrapping is just
> > broken
> > for this commit log, and I have seen it also with other iwlwifi
> > commits.
> > For example, there are just two words in the second line "two
> > paths."
> > 
> > The standard format for git commit logs is something like this:
> > 
> > -----------------------------------------------------------------
> > -----
> > When getting HW rfkill we get stop_device being called from two
> > paths.
> > One path is the IRQ calling stop device, and updating op mode and
> > stack.
> > As a result, cfg80211 is running rfkill sync work that shuts down
> > all
> > devices (second path). In the second path, we eventually get to
> > iwl_mvm_stop_device which calls iwl_fw_dump_conf_clear-
> > >iwl_fw_dbg_stop_recording,
> > that access periphery registers.
> > 
> > The device may be stopped at this point from the first path,
> > which will result with a failure to access those registers. Simply
> > checking for the trans status is insufficient, since the race will
> > still
> > exist, only minimized. Instead, move the stop from
> > iwl_fw_dump_conf_clear (which is getting called only from stop
> > path) to
> > the transport stop device function, where the access is always
> > safe.
> > This has the added value, of actually stopping dbgc before stopping
> > device even when the stop is initiated from the transport.
> > -----------------------------------------------------------------
> > -----
> > 
> > [1] https://patchwork.kernel.org/patch/10074849/
> 
> Instead of trying to get what I mean, check instead the patchwork
> page
> and compare there the original commit log with my reformatted
> version. I
> think that visualises pretty well what I'm trying to say :)

Okay, granted, but that's not really because of alignment or line-
wrapping.  It's because the paragraphs are broken too often.

In any case, I'll pay more attention to this.  So my questions remains,
do you want me to remake my pull-req to fix this?

--
Luca.
