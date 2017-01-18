Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:34597 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbdARCRy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 21:17:54 -0500
Received: by mail-pg0-f51.google.com with SMTP id 14so29392163pgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2017 18:17:13 -0800 (PST)
Date: Tue, 17 Jan 2017 18:09:43 -0800
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>
Subject: Re: [PATCH v2 2/3] mwifiex: pcie: don't loop/retry interrupt status
 checks
Message-ID: <20170118020942.GA37198@google.com> (sfid-20170118_031820_927043_E9FFCD6E)
References: <20170113233538.36196-1-briannorris@chromium.org>
 <20170113233538.36196-2-briannorris@chromium.org>
 <20170116005452.GI23285@dtor-ws>
 <20170117194822.GA29749@google.com>
 <20170117204455.GA6888@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
In-Reply-To: <20170117204455.GA6888@dtor-ws>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 17, 2017 at 12:44:55PM -0800, Dmitry Torokhov wrote:
> On Tue, Jan 17, 2017 at 11:48:22AM -0800, Brian Norris wrote:
> > Also, FWIW, I did some fairly non-scientific tests of this on my
> > systems, and I didn't see much difference. I can run better tests, and
> > even collect data on how often we loop here vs. see new interrupts.
> 
> That would be great. Maybe packet aggregation takes care of interrupts
> arriving "too closely" together most of the time, I dunno.

OK, so I did some basic accounting of how many times this while loop
runs in a row. I don't know if they're highly illuminating, but here
goes. They're listed as a histogram, where the first column is number of
samples that exhibited the behavior and second column is number of times
going through the loop before exiting (i.e., seeing no more INT_STATUS):

Idle (just scanning for networks occasionally, and loading a web page or
two) for a minute or two:
      1 
    265 1
      2 2

Downloading a Chrome .deb package via wget, in a loop:
    857 0
  36406 1
  32386 2
   2230 3
    153 4
     11 5

Running a perf client test (i.e., TX traffic) in a loop:
   1694 0
 247897 1
  25530 2
    441 3
     18 4

So it seems like in some cases, it's at least *possible* to have a little bit
of potential savings on 10-50% of interrupts when under load. (i.e., see
that ~50% of interrupt checks take 2, 3, 4, or 5 loops in the second
example.)

Now, I also did some perf numbers with iperf between a Raspberry Pi iperf
server and an ARM64 system running mwifiex. On the whole, the TX side was
probably bottlenecked by the RPi, but the RX side was pretty good.

I'll attach full numbers, but the percentage delta is as follows:

                               Mean     Median
                               ------   ------
% change, bi-direction (RX):   -0.3     -4.5
% change, bi-direction (TX):    1.034    4.45
% change, TX only:             12.96    13.35
% change, RX only:             -6.5     -3

I'm not sure I have a good explanation for the gain in TX performance.
Perhaps partly the reduction in complexity (e.g., unnecessary register
reads). Perhaps also because I had IEEE power-save enabled, so without
this patch, performance could (theoretically) be harmed by the issue
mentioned in the commit description (i.e., occasional slow PCIe reads)
-- though I guess we probably don't enter power-save often during iperf
tests.

So, there could definitely be some methodology mistakes or other
variables involved, but these don't seem to show any particularly bad
performance loss, and if we did, we might consider other approaches like
NAPI for tuning them.

Brian

--u3/rZRmxL6MmkK24
Content-Type: text/csv; charset=us-ascii
Content-Disposition: attachment; filename="summary.csv"

,Mbit/s,,,,,,,,,,Min,Max,Mean,Median,Stddev
Before: Bidirectional RX,193,163,198,147,194,195,129,167,198,174,129,198,175.8,183.5,24.142171494
Before: Bidirectional TX,15.2,21.4,15.8,26.2,13.8,12.6,22.9,14.3,14.7,35.1,12.6,35.1,19.2,15.5,7.1870253466
Before: TX only,60.6,52.4,70,66,60.9,64.9,58.3,59.8,53.3,58.3,52.4,70,60.45,60.2,5.4530827163
Before: RX only,151,186,209,201,180,208,210,189,176,196,151,210,190.6,192.5,18.476411388
After: Bidirectional RX,171,194,187,165,167,197,163,199,192,120,120,199,175.5,179,24.0381641007
After: Bidirectional TX,30.4,19,19.8,20.2,20.7,20.1,27.3,18.8,19.3,6.74,6.74,30.4,20.234,19.95,6.1485322548
After: TX only,73.9,78.1,73.3,73.2,74.5,82.1,73.8,69.6,68.7,66.9,66.9,82.1,73.41,73.55,4.4500811478
After: RX only,160,163,179,195,203,187,192,202,207,153,153,207,184.1,189.5,19.4676369621
,,,,,,,,,,,,,,,
Delta: Bidirectional RX,,,,,,,,,,,,,-0.3,-4.5,
Delta: Bidirectional TX,,,,,,,,,,,,,1.034,4.45,
Delta: TX only,,,,,,,,,,,,,12.96,13.35,
Delta: RX only,,,,,,,,,,,,,-6.5,-3,
,,,,,,,,,,,,,,,
,,,,,,,,,,,,,-0.17%,-2.45%,
,,,,,,,,,,,,,5.39%,28.71%,
,,,,,,,,,,,,,21.44%,22.18%,
,,,,,,,,,,,,,-3.41%,-1.56%,

--u3/rZRmxL6MmkK24--
