Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49590 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752468AbdLHM21 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:28:27 -0500
Message-ID: <1512736104.4827.283.camel@coelho.fi> (sfid-20171208_132831_520568_399BEF70)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date: Fri, 08 Dec 2017 14:28:24 +0200
In-Reply-To: <87efo5s93p.fsf@kamboji.qca.qualcomm.com>
References: <20171125153510.25359-1-luca@coelho.fi>
         <20171125153510.25359-7-luca@coelho.fi>
         <87mv351iys.fsf@kamboji.qca.qualcomm.com>
         <1511951353.4827.27.camel@coelho.fi>
         <87efo5s93p.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 6/6] iwlwifi: fix access to prph when transport is
 stopped
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-08 at 14:22 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > On Wed, 2017-11-29 at 12:23 +0200, Kalle Valo wrote:
> > 
> > > But no wonder I called gnus-article-fill-cited-article, the
> > > commit
> > > log is just weirdly wrapped. Are you using outlook or how do you
> > > get
> > > it so ugly? :)
> > 
> > Heh! I don't think it's wrapped weirdly, it's just that the
> > paragraphs
> > don't have spaces between them, right? ;)
> 
> Sorry, don't get what you mean with missing spaces. To me (and
> patchwork[1] and git[2] seem to agree) the word wrapping is just
> broken
> for this commit log, and I have seen it also with other iwlwifi
> commits.
> For example, there are just two words in the second line "two paths."

That depends on how many characters per line you want to include.  "two
paths." is the last part of the first paragraph, I guess Sari's editor
is wrapping somewhere at <70 chars per line.

Then that is accentuated a bit by the lack of an empty line between
paragraphs.  But with those lines added, besides being a bit narrow, it
would look quite clear:

-----8<-----
When getting HW rfkill we get stop_device being called from
two paths.

One path is the IRQ calling stop device, and updating op
mode and stack.

As a result, cfg80211 is running rfkill sync work that shuts
down all devices (second path).

In the second path, we eventually get to iwl_mvm_stop_device
which calls iwl_fw_dump_conf_clear->iwl_fw_dbg_stop_recording,
that access periphery registers.

The device may be stopped at this point from the first path,
which will result with a failure to access those registers.

Simply checking for the trans status is insufficient, since
the race will still exist, only minimized.

Instead, move the stop from iwl_fw_dump_conf_clear (which is
getting called only from stop path) to the transport stop
device function, where the access is always safe.

This has the added value, of actually stopping dbgc before
stopping device even when the stop is initiated from the
transport.
----->8-----

Does it make sense?

I've already told Sari about your preference and I'll make sure the
next patches will look cleaner.  I can fix this patch if you want, but
is it worth remaking my pull-request just for this?

--
Cheers,
Luca.
