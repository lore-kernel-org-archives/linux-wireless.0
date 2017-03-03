Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39702 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752002AbdCCNb1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 08:31:27 -0500
Message-ID: <1488543607.25750.1.camel@sipsolutions.net> (sfid-20170303_143143_345634_9043930A)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
From: Johannes Berg <johannes@sipsolutions.net>
To: Jithu Jance <jithu.jance@broadcom.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        Jouni Malinen <j@w1.fi>,
        Avraham Stern <avraham.stern@intel.com>
Date: Fri, 03 Mar 2017 13:20:07 +0100
In-Reply-To: <CA+gyVQ24qDqpOBKPjVaZ_BFAJa9kLMjA=nD8FF8V7HvxUkWb=w@mail.gmail.com> (sfid-20170223_115633_378165_DF472B50)
References: <20170221100957.30965-1-johannes@sipsolutions.net>
         <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com>
         <1487673603.2215.3.camel@sipsolutions.net>
         <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com>
         <1487680651.2215.5.camel@sipsolutions.net>
         <3fa1e3ac-5722-c46d-acc1-62407f4eef07@broadcom.com>
         <CA+gyVQ11yZjkJXjiVoMVijs=_K8itZMQrces9XQha_bT4=H-DA@mail.gmail.com>
         <9b6de09f-d872-fd67-971a-6da369fefe1a@broadcom.com>
         <1248c04b-a643-9254-383c-707ab68c0815@broadcom.com>
         <CA+gyVQ24qDqpOBKPjVaZ_BFAJa9kLMjA=nD8FF8V7HvxUkWb=w@mail.gmail.com>
         (sfid-20170223_115633_378165_DF472B50)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-02-23 at 16:26 +0530, Jithu Jance wrote:
> On Thu, Feb 23, 2017 at 4:10 PM, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
> > 
> > Ehm. Looking at the code in wpa_supplicant_event_assoc() it would
> > be
> > better to use NL80211_CMD_EAPOL_PORT_VALID event to cover both
> > WPA/WPA2-PSK and 8021X.
> 
> Yes. IMHO, the assoc/reassoc ind should move the state to
> WPA_ASSOCIATED and a separate event like
> NL80211_CMD_EAPOL_PORT_VALID/AUTHORIZED should move the connection
> state to WPA_COMPLETED.

That seems reasonable.

Avi just looked also at distinguishing if/when fresh 1X authentication
is required, particularly with roaming. For that, he's suggesting to
add a flag AUTHORIZED to the ROAMED event.

We could, possibly, have a PORT_AUTHORIZED event for that as well, but
it'd be more complicated, since then you'd have to wait for that and if
it doesn't come time out - or we'd need a "PORT_UNAUTHORIZED" or
"PLEASE_START_1X" instead? None of that really seems like such a great
idea.

Perhaps instead it'd make sense to instead include the new AUTHORIZED
flag in the CONNECT_RESULT as well, if authorized? I basically see 3
valid cases:

 * connection successful with authorized port
 * connection successful with need for 1X handshake (non-offloaded)
 * connection failed

Why should we have the case of
 * association successful but 4-way-HS failed

separately?

johannes
