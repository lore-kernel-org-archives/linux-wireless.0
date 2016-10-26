Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43060 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756564AbcJZG7s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 02:59:48 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/7] iwlwifi: mvm: fix d3_test with unified D0/D3 images
References: <20161019071122.18977-1-luca@coelho.fi>
        <20161019071122.18977-4-luca@coelho.fi>
        <87insf7htp.fsf@kamboji.qca.qualcomm.com>
        <1477464427.27792.5.camel@coelho.fi>
Date: Wed, 26 Oct 2016 09:59:43 +0300
In-Reply-To: <1477464427.27792.5.camel@coelho.fi> (Luca Coelho's message of
        "Wed, 26 Oct 2016 09:47:07 +0300")
Message-ID: <87vawf61eo.fsf@kamboji.qca.qualcomm.com> (sfid-20161026_090013_967010_4668A0E2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Wed, 2016-10-26 at 09:19 +0300, Kalle Valo wrote:
>> Luca Coelho <luca@coelho.fi> writes:
>> 
>> > From: Luca Coelho <luciano.coelho@intel.com>
>> > 
>> > When a unified D0/D3 image is used, we don't restart the FW in the
>> > D0->D3->D0 transitions.  Therefore, the d3_test functionality should
>> > not call ieee8021_restart_hw() when the resuming either.
>> > 
>> > Fixes: commit 23ae61282b88 ("iwlwifi: mvm: Do not switch to D3 image on suspend")
>> 
>> The word "commit" is not needed in the Fixes line, but no need to change
>> that now.
>
> Oh, I didn't know that.  Thanks for pointing out.  I'll keep it in mind
> for future patches.

Related to this Documentation/SubmittingPatches has a handy tip:

----------------------------------------------------------------------
The following ``git config`` settings can be used to add a pretty format for
outputting the above style in the ``git log`` or ``git show`` commands::

        [core]
                abbrev = 12
        [pretty]
                fixes = Fixes: %h (\"%s\")
----------------------------------------------------------------------

And then you can do just:

$ git show --format=fixes 23ae61282b88 | head -1
Fixes: 23ae61282b88 ("iwlwifi: mvm: Do not switch to D3 image on suspend")
$

Perfect for a lazy person like me :)

-- 
Kalle Valo
