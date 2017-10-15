Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0041.outbound.protection.outlook.com ([104.47.32.41]:32416
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751618AbdJOJvp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Oct 2017 05:51:45 -0400
Date: Sun, 15 Oct 2017 12:51:33 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Steve deRosier <derosier@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH] iw: add command to register and capture mgmt frames
Message-ID: <20171015095133.prxuuukv6osx52td@bars> (sfid-20171015_115415_783278_4C035310)
References: <20171014210036.29556-1-sergey.matyukevich.os@quantenna.com>
 <CALLGbR+DonvXRDysZGx3fJ0wGQsmnWNW3db7mv9KObwTcicnOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALLGbR+DonvXRDysZGx3fJ0wGQsmnWNW3db7mv9KObwTcicnOg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Add new command to register for receiving multiple mgmt frames,
> > capture and print them. Frames are selected by their type and
> > pattern containing their the first several bytes of the frame
> > that should match.
> >
> 
> Forgive me for asking, what does this provide that isn't already
> available in tshark? And since we already have user-space tools
> tailored for capturing and filtering any frames, including management
> frames, why do we need to add this to iw?

IIUC tshark and other specific capture tools need wireless netdevice to be
in monitor mode. This particular iw command is based on NL80211_CMD_REGISTER_FRAME
and related cfg80211 ops. In fact, this command can be used to subscribe
to mgmt frames when wireless device is up and running in AP or STA mode.
That can be convenient for monitor and debug purposes. There is a
limitation though: currently cfg80211 core allows only one subscriber
for each particular frame/pattern.

It looks like 'capture' part of commit message is a bit confusing.

Regards,
Sergey
