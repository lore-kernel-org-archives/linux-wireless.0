Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48024 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754389AbdK2K3Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Nov 2017 05:29:16 -0500
Message-ID: <1511951353.4827.27.camel@coelho.fi> (sfid-20171129_112923_155203_408E2350)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date: Wed, 29 Nov 2017 12:29:13 +0200
In-Reply-To: <87mv351iys.fsf@kamboji.qca.qualcomm.com>
References: <20171125153510.25359-1-luca@coelho.fi>
         <20171125153510.25359-7-luca@coelho.fi>
         <87mv351iys.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 6/6] iwlwifi: fix access to prph when transport is
 stopped
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-11-29 at 12:23 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Sara Sharon <sara.sharon@intel.com>
> > 
> > When getting HW rfkill we get stop_device being called from
> > two paths.
> > One path is the IRQ calling stop device, and updating op
> > mode and stack.
> > As a result, cfg80211 is running rfkill sync work that shuts
> > down all devices (second path).
> > In the second path, we eventually get to iwl_mvm_stop_device
> > which calls iwl_fw_dump_conf_clear->iwl_fw_dbg_stop_recording,
> > that access periphery registers.
> > The device may be stopped at this point from the first path,
> > which will result with a failure to access those registers.
> > Simply checking for the trans status is insufficient, since
> > the race will still exist, only minimized.
> > Instead, move the stop from iwl_fw_dump_conf_clear (which is
> > getting called only from stop path) to the transport stop
> > device function, where the access is always safe.
> > This has the added value, of actually stopping dbgc before
> > stopping device even when the stop is initiated from the
> > transport.
> > 
> > Fixes: 1efc3843a4ee ("iwlwifi: stop dbgc recording before stopping
> > DMA")
> > Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> But no wonder I called gnus-article-fill-cited-article, the commit
> log
> is just weirdly wrapped. Are you using outlook or how do you get it
> so
> ugly? :)

Heh! I don't think it's wrapped weirdly, it's just that the paragraphs
don't have spaces between them, right? ;)

I noticed this but was probably too tired to nitpick back when I merged
this in our internal tree.  I'll make sure people space the commit
messages better from now on.

Sorry for the trouble.

--
Cheers,
Luca.
