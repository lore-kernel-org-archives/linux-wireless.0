Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59528 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab1INRcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 13:32:15 -0400
Received: by fxe4 with SMTP id 4so1954614fxe.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 10:32:14 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Harshal Chhaya <harshal@gmail.com>
Subject: Re: Latency and connection problems with a carl9170-based AP
Date: Wed, 14 Sep 2011 19:32:02 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAJ8GFOgNRAr7LvnO8f0Y8uvkQdwhz7uUXRQ6BXomjO05RiiYjg@mail.gmail.com>
In-Reply-To: <CAJ8GFOgNRAr7LvnO8f0Y8uvkQdwhz7uUXRQ6BXomjO05RiiYjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109141932.02929.chunkeey@googlemail.com> (sfid-20110914_193219_215086_8DB3821B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, September 14, 2011 01:19:59 PM Harshal Chhaya wrote:
> Most of the disconnects seem to be caused by beacons that update the
> TIM IE but not the overall length. The result is a corrupted RSN IE
> (e.g. the IE length says 20 bytes but the IE is only 19 bytes in size)
> which causes the clients to disconnect. This problem lasts for only
> one beacon (i.e. the next beacon has the right size) but it is enough
> to cause the clients to disconnect. Is there a way to fix this?
Now that is really interesting. Do you know if the TIM IE is generated
properly by ieee80211_beacon_add_tim in net/mac80211/tx.c?
 
> Another problem when power save is enabled is the large and
> unpredictable latency. I understand how enabling power save can
> increase latency but my ping times go from 3-4 ms without power save
> to a wide range of 3 ms - 3 s after I enable power save. I am trying
> smaller beacon intervals to reduce this latency but even at a beacon
> interval of 25ms, I get ping times of up to ~400 ms. How do I reduce
> this wide variation in latency.
What's the listen interval of your stations?
Maybe max_listen_interval=1 in hostapd.conf helps.

Regards,
	Chr
