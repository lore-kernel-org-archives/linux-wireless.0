Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0056.outbound.protection.outlook.com ([104.47.41.56]:56000
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750914AbdJPIsZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 04:48:25 -0400
Date: Mon, 16 Oct 2017 11:48:11 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steve deRosier <derosier@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] iw: add command to register and capture mgmt frames
Message-ID: <20171016084810.plzog2dtzakra4ae@bars> (sfid-20171016_104829_759154_3699AAE7)
References: <20171014210036.29556-1-sergey.matyukevich.os@quantenna.com>
 <CALLGbR+DonvXRDysZGx3fJ0wGQsmnWNW3db7mv9KObwTcicnOg@mail.gmail.com>
 <20171015095133.prxuuukv6osx52td@bars>
 <1508138777.10607.14.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1508138777.10607.14.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes and all,

> So first, I'll say that I have no objection in principle to the patch,
> as a debugging aid.
> 
> However, the story is more complicated.
> 
> > IIUC tshark and other specific capture tools need wireless netdevice
> > to be in monitor mode.
> 
> This is correct, but shouldn't be a problem.
> 
> > This particular iw command is based on
> > NL80211_CMD_REGISTER_FRAME
> > and related cfg80211 ops. In fact, this command can be used to
> > subscribe
> > to mgmt frames when wireless device is up and running in AP or STA
> > mode.
> > That can be convenient for monitor and debug purposes. There is a
> > limitation though: currently cfg80211 core allows only one subscriber
> > for each particular frame/pattern.
> 
> If you're looking for a tool to actually do something like sniffer,
> this API isn't the right thing to do.
> 
> That's why I also don't think it should be added to tshark.
> 
> Remember that with the use of this API also come certain obligations.
> For example, if you subscribe to (certain) action frames and then don't
> actually process them as described by the spec, then the subscriber
> MUST generate responses with the 0x80 bit ORed into the action code,
> returning the frame as not understood. Clearly, this isn't something
> that iw does and can implement.
> 
> Additionally, as you noted, and it's for this exact reason because
> otherwise responsibilities wouldn't be clearly defined, there can only
> be a single subscriber to a certain set of frames, as specified by the
> subtype and match prefix, so using it as a type of sniffer or debug
> tool may affect other functional operation.
> 
> 
> In mac80211, it's _always_ possible to add a monitor interface, and
> given no special flags (which may or may not be supported by a given
> driver anyway) this monitor interface is a pure software construct and
> will in no way affect device operation - apart from sending all
> received frames to the monitor interface at the beginning of mac80211's
> operation.
> 
> I see no reason, other than needing a little bit of coding, that this
> couldn't similarly be supported in qtnfmac.

Well, monitor mode support in qtnfmac is in our todo list for sure. Meanwhile
the purpose of the patch was not to implement a full-fledged mgmt packet
capture. We have monitor mode and mature capture tools for that.

Nevertheless in certain cases it is handy to dump selected types of mgmt frames
while system is up and running without adding the whole monitor overhead. The
idea was that NL80211_CMD_REGISTER_FRAME and iw are the right tools for that
task. Anyway, iw is something like a 'swiss-army-knife' tool for various tasks
related to mac80211/cfg80211 reporting and troubleshooting.

Speaking of the patch, you mentioned that you have no objection in principle.
Let me know if you have any objections to implementation details :)
Then I will resubmit it addressing all the comments. Besides I am going
to change command name from 'capture' to 'dump' to avoid confusion.
Finally, I will update commit message adding information about unicast
nature of those registrations.

Regards,
Sergey
