Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36636 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750864AbdE2Jbr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 May 2017 05:31:47 -0400
Message-ID: <1496050303.2467.3.camel@sipsolutions.net> (sfid-20170529_113150_652842_94250423)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Date: Mon, 29 May 2017 11:31:43 +0200
In-Reply-To: <29d43b7d-6cb6-0734-6a52-31fa98e9c1bc@broadcom.com> (sfid-20170529_111825_524433_97F9D9F2)
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
         <1495030794.2442.21.camel@sipsolutions.net>
         <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com>
         <1495099355.2553.1.camel@sipsolutions.net>
         <4e0672aa-51bc-115f-32b7-b1a8eb747e5b@broadcom.com>
         <1495104012.2553.3.camel@sipsolutions.net>
         <adcf52eb-cc8f-82de-3820-3f96a0d1f8d3@broadcom.com>
         <1495189263.3274.4.camel@sipsolutions.net>
         <c3c14002-c9c5-490a-2e8f-826d601d0d84@broadcom.com>
         <1495448886.2653.12.camel@sipsolutions.net>
         <29d43b7d-6cb6-0734-6a52-31fa98e9c1bc@broadcom.com>
         (sfid-20170529_111825_524433_97F9D9F2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> > Note that this (checking NEW_KEY) only works when you don't have
> > any split between AP/client cases. Not sure what's the case for
> > you.
> 
> Late response so hopefully you recall, but what do you mean by "any 
> split between AP/client cases"?

I meant the capability split - let's say you support 4-way-HS only for
client, but not for AP. Then you have to support the NEW_KEY command
for the AP case, even if you might not support non-offloaded 4-way-HS
for the client case.

So if something supports the following:

 * client: offloaded 4-way-HS only
 * AP: not offloaded 4-way-HS only

Then you have to support NEW_KEY (AP case) and then using NEW_KEY to
detect whether or not a wpa_s configuration option to not use offloaded
4-way-HS can be used will not work correctly.

I don't really see that this is a sensible configuration, but I could
imagine it existing if somebody "bolted on" AP functionality for a
client-side chipset or something like that.

Again, I think I'm happy to leave this up to you - this kind of
configuration option should really only be used for debugging anyway,
so just getting errors later is probably fine.

johannes
