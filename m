Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:45824 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdISQnV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Sep 2017 12:43:21 -0400
Received: by mail-pf0-f172.google.com with SMTP id z84so102379pfi.2
        for <linux-wireless@vger.kernel.org>; Tue, 19 Sep 2017 09:43:20 -0700 (PDT)
Date: Tue, 19 Sep 2017 09:43:17 -0700
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: use get_random_mask_addr() helper
Message-ID: <20170919164316.GA4617@google.com> (sfid-20170919_184325_103391_33A2BCBC)
References: <1505720537-13362-1-git-send-email-gbhat@marvell.com>
 <87o9q8kuy4.fsf@purkki.adurom.net>
 <3f3f5c9672a5421db05337a00d9578f2@SC-EXCH02.marvell.com>
 <87tvzyahht.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87tvzyahht.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Sep 19, 2017 at 05:30:06PM +0300, Kalle Valo wrote:
> Ganapathi Bhat <gbhat@marvell.com> writes:
> 
> > Hi Kalle,
> >> 
> >> > Avoid calculating random MAC address in driver. Instead make use of
> >> > 'get_random_mask_addr()' function.
> >> >
> >> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> >> 
> >> I don't see 1/2 anywhere. Did it get lost?
> >
> > Actually there is no 1/2. What I did is: 'git send-email'; CTRL + C

It's dependent on this patch though, which kinda should be '1/2':

[PATCH] mwifiex: avoid storing random_mac in private

> > (to correct a typo); and then tried sending it again. I think that
> > created some problem here. Kindly let me know how to proceed.
> 
> Ok. I'll wait for review comments and if all goes well I'll apply it in
> few days.

FWIW, this looks OK to me:

Reviewed-by: Brian Norris <briannorris@chromium.org>

It's just a bit strange that we have to keep our own on-stack temporary
buffer for this. Maybe this could use an in-place helper too? Or (if
it's really legal for us to modify the cfg80211_scan_request in-place)
why doesn't the upper-layer nl80211 code do the randomization for us?
Many (all?) drivers I see implementing randomization have to do this
anyway; they don't use request->mac_addr directly. (Or I suppose some
firmware could implement the randomization on its own someday...but
would we really trust it?)

Brian
