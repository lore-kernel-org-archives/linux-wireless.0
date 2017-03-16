Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49684 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750899AbdCPWek (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 18:34:40 -0400
Message-ID: <1489703635.3930.5.camel@sipsolutions.net> (sfid-20170316_233446_186508_99D61778)
Subject: netdev level filtering? perhaps pushing socket filters down?
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 16 Mar 2017 23:33:55 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Occasionally - we just had another case - people want to hook into
packets received and processed by the mac80211 stack, but because they
don't need all of them (e.g. not data packets), even adding a monitor
interface and bringing it up has too high a cost because SKBs need to
be prepared to send them to the monitor interface, even if no socket is
consuming them.

Ideally, we'd be able to detect that there are filter programs attached
to the socket(s) that are looking at the frames coming in on the
monitor interface, and we could somehow magically run those before we
create a new SKB.
One problem here is that we wouldn't really want to prepare all the
radiotap header just to throw it away, so we'd have to be able to
analyse the filter program to make sure it doesn't access anything but
the radiotap header length, and that only in order to jump over it.
That seems ... difficult, but we don't even know the header length -
although we could fudge that and make a very long constant-size header,
which might make it possible to do such analysis, or handle it by
trapping on such access. But it seems rather difficult to implement
this.

The next best thing would be to install a filter program on the virtual
monitor *interface* (netdev), but say that it doesn't get frames with
radiotap, but pure 802.11 frames. We already have those in SKB format
at this point, so it'd be simple to run such a program and only pass
the SKB to the monitor netdev's RX when the program asked to do that.

This now seems a bit like XDP, but for XDP this header difference
doesn't seem appropriate either.

Anyone have any other thoughts?

Thanks,
johannes
