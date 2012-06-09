Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56423 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2FIUsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 16:48:55 -0400
Received: by obbtb18 with SMTP id tb18so4362545obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jun 2012 13:48:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339232144.4539.38.camel@jlt3.sipsolutions.net>
References: <1339187469-12778-1-git-send-email-jason@cozybit.com>
 <1339187469-12778-3-git-send-email-jason@cozybit.com> <1339232144.4539.38.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Sat, 9 Jun 2012 13:48:34 -0700
Message-ID: <CAPjQAd-JEGh+0vxPiysd55qwP54ezY9avE_=ycTT-zgSWD-u8A@mail.gmail.com> (sfid-20120609_224935_251097_D62AC286)
Subject: Re: [PATCH 2/2] mac80211: Use signal strength as a proxy for expected datarate.
To: devel@lists.open80211s.org
Cc: Jason Abele <jason@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Sat, Jun 9, 2012 at 1:55 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-06-08 at 13:31 -0700, Jason Abele wrote:
>
>> +     if (sta->tx_packets > 100)
>> +             rate = max(ewma_read(&sta->avg_rate), 10UL);
>> +     else
>> +             /* Not enough traffic sent, use rx signal strengh as proxy */
>> +             rate = rssi_get_rate(sta);
>
> This just seems completely wrong to me. There's very little correlation
> between bitrates and RSSI, in fact, we once had 0 dBm power by accident
> and got better performance than with 15 dBm power (due to another bug,
> but still)...

I would say this is an improvement over the existing approach, which
assigns the lowest rate (and therefore a poor metric) to all mesh
paths over new peers.  This means that a possibly good path through a
new peer is not used until existing mesh paths degrade below this
initial poor metric.

Alternatively we had considered to initialize the metric with the best
(lowest) metric but that just reverses the problem, as the new peers
would attract traffic away from good established paths.

By using RSSI we can at least choose a sensible initial value for the
airtime link metric.  I agree with you in that a high RSSI does not
necessarily mean higher rates, but I would not say that there is "very
little correlation" between the two.  SNR is directly correlated with
datarates¹.  Unfortunately SNR measurements are not available at the
mac80211 layer.  But at equal noise levels, which is not unlikely
between two direct peer neighbors, RSSI will correlate with SNR
measurements.

Keep in mind that the RSSI is only used until traffic starts flowing
through that peer.  Once valid rate statistics are available, the RSSI
is no longer used to calculate the metric.

> Looking at the code that uses this, I also note:
>
>>       /* This should be adjusted for each device */
>>         int device_constant = 1 << ARITH_SHIFT;
>
> which seems *totally* wrong. Maybe it's time to rethink this code?

Indeed, but the standard defines this constant that "Varies depending
on PHY" (see sect. 13.9).  We would have to get each driver to report
the right value.

Cheers,

Javier

[1] For instance, see
http://www.inf.ed.ac.uk/teaching/courses/cn/papers/ygz-infocom08.pdf

> johannes
>
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
