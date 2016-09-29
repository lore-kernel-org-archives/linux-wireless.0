Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34905 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752387AbcI2LWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Sep 2016 07:22:15 -0400
Message-ID: <1475148131.6673.10.camel@sipsolutions.net> (sfid-20160929_132219_828921_0F1D7953)
Subject: Re: rfkill guidance
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonathan Richardson <jonathan.richardson@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        devicetree <devicetree@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        Mark Rutland <mark.rutland@arm.com>
Date: Thu, 29 Sep 2016 13:22:11 +0200
In-Reply-To: <fc993a0d-25cc-fb1c-3d96-86b12d1140d2@broadcom.com> (sfid-20160928_225432_125394_86BA511B)
References: <324c35c6-49ca-174c-db07-674532f3e628@broadcom.com>
         <1474961105.5141.5.camel@sipsolutions.net>
         <0a8cff88-73aa-8311-7afe-98612161421f@broadcom.com>
         <1475044682.4139.18.camel@sipsolutions.net>
         <fc993a0d-25cc-fb1c-3d96-86b12d1140d2@broadcom.com>
         (sfid-20160928_225432_125394_86BA511B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This clarifies the issue, thanks. Basically the reason is history -
> this user space code has been around for a while. It turns out the
> HCI BT driver doesn't exist as it should. If it did, then the
> regulator could be tied to the driver. Now I see what's missing.

So like what Marcel wrote over in his email, but with regulator vs.
GPIO. Seems completely reasonable for the BT HCI driver to support
that, if you ask me.

> We will push on the team responsible for the BT drivers but all I
> need to know right now is that an rfkill driver isn't necessary.

And indeed, that would get rid of the need for anything rfkill.

> There might be some need for this but for our purpose I think the
> right path is to have a BT driver doing what this user space app is
> doing and then integrate whatever is missing with this HCI User
> Channel.
> 

Sounds good to me, even if I have no idea (and don't really need to
know) what all that is :)

I'll look at killing the rfkill-regulator driver entirely though,
since, afaict, nothing uses it.

johannes
