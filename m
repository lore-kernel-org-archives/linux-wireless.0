Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40092 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932936AbdCJJPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 04:15:23 -0500
Message-ID: <1489137311.3038.3.camel@sipsolutions.net> (sfid-20170310_124253_455921_BF79C9A8)
Subject: Re: [PATCH] ath6kl: Remove old 802.11a-only channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostyslav Khudolii <rkhudolii@airtame.com>
Cc: kvalo@qca.qualcomm.com, ath6kl@lists.infradead.org,
        linux-wireless@vger.kernel.org, Attila Sukosd <attila@airtame.com>
Date: Fri, 10 Mar 2017 10:15:11 +0100
In-Reply-To: <CAPXt_daQxHAsPfeRjP0CZfq_Uu4EXHvjsko-EUb0mKmDaef_SQ@mail.gmail.com> (sfid-20170310_101153_737719_AB380131)
References: <CAPXt_dabk8KNL0HTHZJfoHT+93ZS+3R31tVEPb4zpKJWE65cMw@mail.gmail.com>
         <1489136175.3038.2.camel@sipsolutions.net>
         <CAPXt_daQxHAsPfeRjP0CZfq_Uu4EXHvjsko-EUb0mKmDaef_SQ@mail.gmail.com>
         (sfid-20170310_101153_737719_AB380131)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-10 at 10:11 +0100, Rostyslav Khudolii wrote:
> On 10 March 2017 at 09:56, Johannes Berg <johannes@sipsolutions.net>
> wrote:
> > On Fri, 2017-03-10 at 09:49 +0100, Rostyslav Khudolii wrote:
> > > Channels 34/38/42/46 can only be used for compatibility with
> > > old devices sold in Japan. Modern products, such as AR6003/AR6004
> > > don't support these channels.
> > > Keeping them in the upstream is error prone and requires full
> > > network stack support.
> > 
> > Seems pointless. Nothing in the network stack really cares much
> > about
> > the channel numbers, so what exactly does this improve?
> > 
> 
> Without this one, a user is able to start an AP using wpa_supplicant,
> for example, on one of these channels (34/38/42/46), without getting
> any warning/error from the cfg80211 or ath6kl - which is correct
> (since these channels match regdom rules). However, the AR6003 and
> its
> firmware (we're using v3.4.0.225) will fail and return
> "WMI_CMDERROR_EVENTID" with "INVALID_PARAM" error code.
> In my opinion, ath6kl shouldn't support anything the firmware
> doesn't.
> We should also handle WMI_CMDERROR_EVENTID properly (not just
> printing
> a message), but this is another problem, I believe.

Ah. I didn't make the connection that AR6003 was actually a product
that used this driver and thought you were using it as another peer and
then the two couldn't make a connection...

My bad.

johannes
