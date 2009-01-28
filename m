Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:17992 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbZA1O7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 09:59:23 -0500
Received: by wf-out-1314.google.com with SMTP id 27so8117086wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 06:59:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090122114539.31443.45201.stgit@tikku>
References: <20090122114240.31443.18218.stgit@tikku>
	 <20090122114539.31443.45201.stgit@tikku>
Date: Wed, 28 Jan 2009 20:29:20 +0530
Message-ID: <8e92b4100901280659t444486b2v27efffe7224d17b@mail.gmail.com> (sfid-20090128_155941_461718_00EC3368)
Subject: Re: [RFC PATCH v2 1/2] mac80211: remove multicast check from
	check_tim()
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 22, 2009 at 5:15 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Currently mac80211 checks for the multicast tim bit from beacons,
> disables power save and sends a null frame if the bit is set. This was
> added to support ath9k. But this is a bit controversial because the AP will
> send multicast frames immediately after the beacon and the time constraints
> are really high. Relying mac80211 to be fast enough here might not be
> reliable in all situations.

I agree that mac80211 is not fast enough to disable power save when multicast
bit is set. But a quick testing with multicast traffic with power save
enabled shows
me that the traffic is passing without much failures(97% passes
through and this is
not a small number considering my high traffic/noisy channel
conditions). So, the reason
 is not strong enough or the mac80211 is not too slow to respond to a
mc traffic in
practical conditions and hence the check need not be removed.

> And there's no need to send a null frame, AP
> will send the frames immediately after the dtim beacon no matter what.

You are right. In that case, if mc bit is set, we can change the code
to just disable ps
and not to send a null frame.
But this pops up another issue! How to enable ps after waking up for mc traffic?
For this we have got to have the dynamic_ps_timer called from the rx path also.
This enables ps after the specified timeout. I don't see any good reason for not
to have this timer in Rx path also. Thoughts?

Thanks
Vivek.
