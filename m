Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49998 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751864AbdHGNFk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 09:05:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/10]  mac80211 patches from our internal tree 2017-08-05
References: <20170805084438.12550-1-luca@coelho.fi>
        <87d187vja4.fsf@purkki.adurom.net>
        <1502098298.15969.109.camel@coelho.fi>
Date: Mon, 07 Aug 2017 16:05:36 +0300
In-Reply-To: <1502098298.15969.109.camel@coelho.fi> (Luca Coelho's message of
        "Mon, 07 Aug 2017 12:31:38 +0300")
Message-ID: <874ltjle8v.fsf@kamboji.qca.qualcomm.com> (sfid-20170807_150544_203046_A3C273FD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Mon, 2017-08-07 at 12:06 +0300, Kalle Valo wrote:
>> Luca Coelho <luca@coelho.fi> writes:
>> 
>> > Here are some pending mac80211 patches from our internal tree.
>> > 
>> > The "mac80211: add api to start ba session timer expired flow" patch
>> > is needed by an iwlwifi patch that I want to send for -fixes, so it
>> > would have to be applied to -fixes as well.
>> 
>> We are getting to the later stages of the release cycle and I'm raising
>> the bar for wireless-drivers even higher. How serious iwlwifi bug is
>> that fixing?
>
> The problem is a bad degradation in throughput with our new 9000 family
> of devices because when aggregation times out we stop the aggregation
> internally in the firmware but don't send a delba.  Then on the AP side,
>  also with our driver, we don't handle the timeout as we should, so
> aggregations the devices get out of sync and BA sessions are not
> possible anymore, limiting our throughput to ~30Mbps, in some specific
> internal tests.

Ok.

>> > Should I send a separate patchset with these two so they can be both
>> > applied at the same time (either in the mac80211 or in
>> > wireless-drivers tree)?
>> 
>> Now that Johannes is away and I'm taking any urgent mac80211 patches, I
>> think the best approach is that you include mac80211 patch in the same
>> patchset as the iwlwifi patches destined for wireless-drivers.
>
> Okay, if you think the (one-liner) iwlwifi driver fix is -rc'able, I'll
> resend this in a patchset including both changes.

If the iwlwifi patch is a oneliner it doesn't sound too bad, but I
reserve the right to change my mind :)

But try to submit the pull request in the next few days so that I can
submit the patches forward by end of this week. And I think it's easiest
that you apply the mac80211 patch directly to your tree and I just pull
from you.

-- 
Kalle Valo
