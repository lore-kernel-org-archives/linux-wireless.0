Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40884 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750880AbdJPH0U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 03:26:20 -0400
Message-ID: <1508138777.10607.14.camel@sipsolutions.net> (sfid-20171016_092623_688359_86A50C2D)
Subject: Re: [PATCH] iw: add command to register and capture mgmt frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Steve deRosier <derosier@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 16 Oct 2017 09:26:17 +0200
In-Reply-To: <20171015095133.prxuuukv6osx52td@bars>
References: <20171014210036.29556-1-sergey.matyukevich.os@quantenna.com>
         <CALLGbR+DonvXRDysZGx3fJ0wGQsmnWNW3db7mv9KObwTcicnOg@mail.gmail.com>
         <20171015095133.prxuuukv6osx52td@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Looks like this played out while I wasn't paying attention :-)

So first, I'll say that I have no objection in principle to the patch,
as a debugging aid.

However, the story is more complicated.

> IIUC tshark and other specific capture tools need wireless netdevice
> to be in monitor mode.

This is correct, but shouldn't be a problem.

> This particular iw command is based on
> NL80211_CMD_REGISTER_FRAME
> and related cfg80211 ops. In fact, this command can be used to
> subscribe
> to mgmt frames when wireless device is up and running in AP or STA
> mode.
> That can be convenient for monitor and debug purposes. There is a
> limitation though: currently cfg80211 core allows only one subscriber
> for each particular frame/pattern.

If you're looking for a tool to actually do something like sniffer,
this API isn't the right thing to do.

That's why I also don't think it should be added to tshark.

Remember that with the use of this API also come certain obligations.
For example, if you subscribe to (certain) action frames and then don't
actually process them as described by the spec, then the subscriber
MUST generate responses with the 0x80 bit ORed into the action code,
returning the frame as not understood. Clearly, this isn't something
that iw does and can implement.

Additionally, as you noted, and it's for this exact reason because
otherwise responsibilities wouldn't be clearly defined, there can only
be a single subscriber to a certain set of frames, as specified by the
subtype and match prefix, so using it as a type of sniffer or debug
tool may affect other functional operation.


In mac80211, it's _always_ possible to add a monitor interface, and
given no special flags (which may or may not be supported by a given
driver anyway) this monitor interface is a pure software construct and
will in no way affect device operation - apart from sending all
received frames to the monitor interface at the beginning of mac80211's
operation.

I see no reason, other than needing a little bit of coding, that this
couldn't similarly be supported in qtnfmac.

Now, there *is* one problem with this - namely that this can
significantly affect performance. The reason is that all frames need to
be sent to the monitor interface, even if they're immediately discarded
using a BPF socket filter. Sending them there means allocating a new
SKB (not necessarily copying the data, but still), as well as
generating radiotap header information for the frames. In many cases
data frames are immediately discarded so all this work is for naught.

What I had worked on a while ago to solve this problem is an eBPF
filter attached just before the "branch point" to the monitor
interface, this filter gets access to the frame (without radiotap data)
and some limited RX status data.

You can find the code for this here (may need rebasing, but I have
merged all the RX path logic changes already):

https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
/log/?h=bpf


Now, there are two problems with this still (afaict):

   1. It doesn't cover the TX status path, which it should, since that
      also goes to the monitor interfaces. This is easily solved, I think
      I just forgot about it :) (This may need an additional field in the
      metadata, but that's not a problem)
   2. It doesn't deal with already decapsulated RX, i.e. devices where the
      802.11->ethernet decapsulation is done in the device already. This
      was the reason I didn't merge this, and the problem I see with this
      is that even if we do add additional metadata, it's hard to ensure
      that eBPF programs won't ignore it.

johannes
