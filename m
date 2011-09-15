Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38718 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935225Ab1IOWgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 18:36:35 -0400
Received: by fxe4 with SMTP id 4so1094368fxe.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 15:36:34 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Harshal Chhaya <harshal@gmail.com>
Subject: Re: Latency and connection problems with a carl9170-based AP
Date: Fri, 16 Sep 2011 00:36:19 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <CAJ8GFOgNRAr7LvnO8f0Y8uvkQdwhz7uUXRQ6BXomjO05RiiYjg@mail.gmail.com> <201109141932.02929.chunkeey@googlemail.com> <CAJ8GFOg-sac_+5xn95rJkkxcUgXttUdC=qUtQ_qcw+pYrcpNuA@mail.gmail.com>
In-Reply-To: <CAJ8GFOg-sac_+5xn95rJkkxcUgXttUdC=qUtQ_qcw+pYrcpNuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109160036.19908.chunkeey@googlemail.com> (sfid-20110916_003639_041711_D49790E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, September 15, 2011 11:37:58 PM Harshal Chhaya wrote:
> On Wed, Sep 14, 2011 at 12:32 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Wednesday, September 14, 2011 01:19:59 PM Harshal Chhaya wrote:
> >> Most of the disconnects seem to be caused by beacons that update the
> >> TIM IE but not the overall length. The result is a corrupted RSN IE
> >> (e.g. the IE length says 20 bytes but the IE is only 19 bytes in size)
> >> which causes the clients to disconnect. This problem lasts for only
> >> one beacon (i.e. the next beacon has the right size) but it is enough
> >> to cause the clients to disconnect. Is there a way to fix this?
>> Now that is really interesting. Do you know if the TIM IE is generated
>> properly by ieee80211_beacon_add_tim in net/mac80211/tx.c?
> 
> I don't know if TIM IE is valid but a change in size of this IE causes
> the problem. Do you need more details or packet captures or something
> else to understand the problem better?
There's a 6 ms window between the TBTT event and beacon xmit. Most x86
[which have a USB port] and all AMD64 are fast enough to react in time.
Do you think you can check if your embedded system is fast enough?

An alternative approach we could reorder the TIM IE within the beacon
and put it at the end. This step reduces the delta between the old
and new beacon and prevents the corruption.
> >> Another problem when power save is enabled is the large and
> >> unpredictable latency. I understand how enabling power save can
> >> increase latency but my ping times go from 3-4 ms without power save
> >> to a wide range of 3 ms - 3 s after I enable power save. I am trying
> >> smaller beacon intervals to reduce this latency but even at a beacon
> >> interval of 25ms, I get ping times of up to ~400 ms. How do I reduce
> >> this wide variation in latency.
> > What's the listen interval of your stations?
> > Maybe max_listen_interval=1 in hostapd.conf helps.
> 
> The listen interval on the clients is 1. It's as if the beacon doesn't
> have the right TIM bit set or the device is missing beacons. I will
> narrow down my test set to a single client and capture the packets to
> understand the interaction better.
ok, understood.

Regards,
	Chr
