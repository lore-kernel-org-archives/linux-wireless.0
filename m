Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40764 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaL0KKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 05:10:20 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so18384626wid.5
        for <linux-wireless@vger.kernel.org>; Sat, 27 Dec 2014 02:10:19 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Christopher Chavez <chrischavez@gmx.us>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: p54usb kernel panic on recent mainline kernels
Date: Sat, 27 Dec 2014 11:10:16 +0100
Message-ID: <2296382.VCr2c4tJc9@debian64> (sfid-20141227_111441_142380_CBD142F8)
In-Reply-To: <loom.20141227T010207-869@post.gmane.org>
References: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com> <549DB187.3090003@lwfinger.net> <loom.20141227T010207-869@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Readded Larry to the CC]

On Saturday, December 27, 2014 12:15:58 AM Christopher Chavez wrote:
> > My bisection led to a branch commit d17ec4d as the "bad" commit. 
> > Rather than finding out where the bisection went bad, I added 
> > code to check skb->tail, skb->end, and the length to be added.
> > At the time of the call that panics, there are 6 bytes between
> > tail and end with 8 bytes needed.
> >
> > I will be looking for the place where the driver calculates how
> > large the skb should be.

I think this narrows it down. However, I'm not 100% sure yet if the
problem is just because of "mac80211: don't resize skbs needlessly".

>From looking at a other patch from that time and context. I think: "

commit ca34e3b5c808385b175650605faa29e71e91991b
Author: Ido Yariv <ido@wizery.com>
Date:   Tue Jul 29 15:38:53 2014 +0300

    mac80211: Fix accounting of the tailroom-needed counter [1]
    
    When hw acceleration is enabled, the GENERATE_IV or PUT_IV_SPACE flags
    will only require headroom space. Consequently, the tailroom-needed
    counter can safely be decremented."

changed/broke things for p54* (note: cw1200 could be affected as well?
This driver also modifies the tailroom for skbs in cw1200_tx_h_crypt).
Previously, the driver didn't need to manage the tailroom. If the 
IEEE80211_KEY_FLAG_GENERATE_IV flag was set, mac80211 would take care of
resizing the skb at the right time and just in one place [of course the
downside was that mac80211 did the resize needlessly].

I can think of several ways of dealing with this issue:

 1. move the expand and trim tailroom into the driver.
    AFAICT this would add an additional resize [at a bad time].

 2. add extra IEEE80211_KEY_FLAG_ or HW_FLAG to restore the old behavior.
    This should be possible and relatively simple. But we/I have to be
    especially careful to differentiate properly between the old and new.
    [i.e.: I need to know what the deal is behind: 
    IEEE80211_KEY_FLAG_GENERATE_IV_MGMT in this case? Looks like it can
    be ignored?]

 3. suggestions?
    [No, I'm not going to touch crypto_tx_tailroom_needed_cnt outside of
    mac80211 :D]

Regards,
Christian

[1] <http://www.spinics.net/lists/linux-wireless/msg125374.html>
