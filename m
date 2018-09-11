Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua1-f66.google.com ([209.85.222.66]:39788 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbeIKSPV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 14:15:21 -0400
Received: by mail-ua1-f66.google.com with SMTP id g18-v6so20481927uam.6
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2018 06:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <1533180646-8028-1-git-send-email-sushant2k1513@gmail.com>
 <1534246392.3547.26.camel@sipsolutions.net> <5B83C2FE.90000@redpinesignals.com>
 <1535527450.5215.8.camel@sipsolutions.net> <CANGSkXTnEV7efC8nY9MRK1q2Ky-Ao_6rLoLp75oj4cvCkguZGw@mail.gmail.com>
 <1535970059.3437.39.camel@sipsolutions.net> <CANGSkXTPejV11TVpauXn+t6g+rUQ8cYik8KAz7W1P-2Y-8XebA@mail.gmail.com>
 <CANGSkXR11ZxFoiZ7sbKTu8BnXSpTsiAhH=DOD=e9Zh8bquDC0A@mail.gmail.com> <1536668735.3224.145.camel@sipsolutions.net>
In-Reply-To: <1536668735.3224.145.camel@sipsolutions.net>
From: Siva Rebbagondla <siva8118@gmail.com>
Date: Tue, 11 Sep 2018 18:50:06 +0530
Message-ID: <CANGSkXSD4dWKBLROMLT=oqCJLXV7R6HAWw9sfS=d1CBppAQhbw@mail.gmail.com> (sfid-20180911_151607_139114_5879F59C)
Subject: Re: [PATCH v3 1/2] mac80211: invoke sw_scan if hw_scan returns EPERM
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        sushant kumar mishra <sushant2k1513@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 11, 2018 at 5:55 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> [re-adding the previous thread]
>
> > As discussed earlier, please find attached tar ball for driver logs,
> > traces and debug patches.
> > I have added a README for reference in attached folder, go through the
> > steps and let me know your feedback.
>
> Thanks! The tracing doesn't seem to have worked, but the logging helps a
> lot.
>
> So what happens, to summarize, is that we have hardware that doesn't
> support scanning on both bands at the same time, i.e.
> SINGLE_SCAN_ON_ALL_BANDS isn't set.
>
> This is with the patch to make -EPERM into "please do software scan" (we
> can debate whether that should be -EPERM or 1 or something, doesn't
> matter for this discussion).
>
> This logic only happens here:
>
>         if (local->ops->hw_scan) {
>                 WARN_ON(!ieee80211_prep_hw_scan(local));
>                 rc = drv_hw_scan(local, sdata, local->hw_scan_req);
>                 if (rc == -EPERM) {
>                         set_bit(SCAN_HW_CANCELLED, &local->scanning);
>                         __set_bit(SCAN_SW_SCANNING, &local->scanning);
>                         rc = ieee80211_start_sw_scan(local, sdata);
>                 }
> (in __ieee80211_start_scan).
>
> Next thing is that the software scan completes. This calls
> __ieee80211_scan_completed(), which assumes hardware scan is running,
> since
>         bool hw_scan = local->ops->hw_scan;
>
> This now again runs drv_hw_scan():
>
>         if (hw_scan && !aborted &&
>             !ieee80211_hw_check(&local->hw, SINGLE_SCAN_ON_ALL_BANDS) &&
>             ieee80211_prep_hw_scan(local)) {
>                 int rc;
>
>                 rc = drv_hw_scan(local,
>                         rcu_dereference_protected(local->scan_sdata,
>                                                   lockdep_is_held(&local->mtx)),
>                         local->hw_scan_req);
>
> which presumably again returns -EPERM (conditions didn't change), and
> thus we end up with scan abort.
>
> To work around this, you were setting and testing HW_SCAN_CANCELLED in
> two new places (you can see the setting above).
>
> Looking at this in more detail, I think we have multiple issues with the
> way the fallback is implemented.
>
> First of all, this issue at hand. That's worked around, and could be -
> more properly IMHO - worked around by setting a new bit
> (HW_SCAN_SW_FALLBACK or so).
>
> However, note that due to the way you implemented this, the software
> scan requests that happens as a fallback behaves differently from a
> regular software scan. This doesn't matter to you (right now) because
> you only fall back to software if you're not connected, but in the case
> that you _are_ connected, it would behave differently due to all the
> code in __ieee80211_start_scan() that handles a single-channel software
> scan differently if that matches the currently used channel.
>
>
> So ultimately, I think the (combined) problem is that the fallback is
> implemented badly.
>
> My suggestion would be to separate the decision of whether to do
> software or hardware scan from the hw_scan callback. This could be done
> by flags, e.g. hw->scanflags & IEEE80211_SW_SCAN_WHILE_UNASSOC, which
> would be your case IIRC, though TBD what that means for AP mode.
>
> Obviously, you'll have to change all the (four) things that are checking
> for "local->ops->hw_scan" to check something else. The three in
> __ieee80211_start_scan() obviously just check the result of the
> condition, and the one in __ieee80211_scan_completed() can already check
> local->scanning today since that's set by then (and the scanning==0 case
> is only valid with aborted, so not relevant for the hw_scan condition).
>
> Perhaps we can actually do the return value from drv_hw_scan(), but in
> that case I'd say it should look something like this:
>
> https://p.sipsolutions.net/6ca3554b24e09ffb.txt
>
> Yes, that's less efficient (due to the whole idle recalculation), but
> it's much easier to understand what's going on, IMHO.
>
> There's also a question about whether or not capabilities match, e.g. if
> we do software scan we report 4 SSIDs, low prio scan, AP scan, random
> scan, minimal scan content ... these are OK, but if there are ever
> features that mac80211 *doesn't* support, we'll be in trouble if
> somebody tries to use them.
>
> Hope this helps. If my patch actually works (I obviously haven't tested)
> then I can send it to the list with signed-off-by and all.
>
> johannes

Hi Johannes,
Thanks for the brief explanation and As you mentioned above, we made
the changes w.r.t our module.
We will understand, what we missed here and will test with your patch
and update you.

Regards,
Siva Rebbagondla.
