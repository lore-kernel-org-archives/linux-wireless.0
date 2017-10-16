Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41976 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdJPJZB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 05:25:01 -0400
Message-ID: <1508145899.10607.30.camel@sipsolutions.net> (sfid-20171016_112504_583900_A5870E0D)
Subject: Re: [PATCH] iw: add command to register and capture mgmt frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: Steve deRosier <derosier@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 16 Oct 2017 11:24:59 +0200
In-Reply-To: <20171016084810.plzog2dtzakra4ae@bars>
References: <20171014210036.29556-1-sergey.matyukevich.os@quantenna.com>
         <CALLGbR+DonvXRDysZGx3fJ0wGQsmnWNW3db7mv9KObwTcicnOg@mail.gmail.com>
         <20171015095133.prxuuukv6osx52td@bars>
         <1508138777.10607.14.camel@sipsolutions.net>
         <20171016084810.plzog2dtzakra4ae@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-10-16 at 11:48 +0300, Sergey Matyukevich wrote:
> 
> Well, monitor mode support in qtnfmac is in our todo list for sure. 

Sure. I'm saying you don't really need full monitor support at all,
just a pure software construct for this.

> Meanwhile the purpose of the patch was not to implement a full-
> fledged mgmt packet capture. We have monitor mode and mature capture
> tools for that.

Right, and I didn't originally see the patch as such, just that the
discussion (and in particular Julian's suggestion) veered off in that
direction.

> Nevertheless in certain cases it is handy to dump selected types of
> mgmt frames while system is up and running without adding the whole
> monitor overhead. The idea was that NL80211_CMD_REGISTER_FRAME and iw
> are the right tools for that task. Anyway, iw is something like a
> 'swiss-army-knife' tool for various tasks related to
> mac80211/cfg80211 reporting and troubleshooting.

I'd see this particular feature in iw more as a way to debug the
registrations, but whatever you ultimately want to use it for I neither
can nor want to control :-)

> Let me know if you have any objections to implementation details :)

Yeah, I'll need to review it, just need a bit more time for that.

> Then I will resubmit it addressing all the comments. Besides I am
> going to change command name from 'capture' to 'dump' to avoid
> confusion. Finally, I will update commit message adding information
> about unicast nature of those registrations.

Sounds good :)

Do you want to resend before I review it?

johannes
