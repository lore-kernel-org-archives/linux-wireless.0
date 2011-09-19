Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39794 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab1ISNGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 09:06:24 -0400
Received: by fxe4 with SMTP id 4so3877352fxe.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 06:06:22 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Harshal Chhaya <harshal@gmail.com>
Subject: Re: Latency and connection problems with a carl9170-based AP
Date: Mon, 19 Sep 2011 15:06:19 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <CAJ8GFOgNRAr7LvnO8f0Y8uvkQdwhz7uUXRQ6BXomjO05RiiYjg@mail.gmail.com> <201109160036.19908.chunkeey@googlemail.com> <CAJ8GFOjhTWbwhszHKGe5ewG060X77rSBUcWQy-9bSC9GF=FE+Q@mail.gmail.com>
In-Reply-To: <CAJ8GFOjhTWbwhszHKGe5ewG060X77rSBUcWQy-9bSC9GF=FE+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109191506.19152.chunkeey@googlemail.com> (sfid-20110919_150626_632067_C34F83B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, September 19, 2011 04:32:14 AM Harshal Chhaya wrote:
> On Thu, Sep 15, 2011 at 5:36 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Thursday, September 15, 2011 11:37:58 PM Harshal Chhaya wrote:
> >> On Wed, Sep 14, 2011 at 12:32 PM, Christian Lamparter
> >> <chunkeey@googlemail.com> wrote:
> >> > On Wednesday, September 14, 2011 01:19:59 PM Harshal Chhaya wrote:
> >> >> Most of the disconnects seem to be caused by beacons that update the
> >> >> TIM IE but not the overall length. The result is a corrupted RSN IE
> >> >> (e.g. the IE length says 20 bytes but the IE is only 19 bytes in size)
> >> >> which causes the clients to disconnect. This problem lasts for only
> >> >> one beacon (i.e. the next beacon has the right size) but it is enough
> >> >> to cause the clients to disconnect. Is there a way to fix this?
> >>> Now that is really interesting. Do you know if the TIM IE is generated
> >>> properly by ieee80211_beacon_add_tim in net/mac80211/tx.c?
> >>
> >> I don't know if TIM IE is valid but a change in size of this IE causes
> >> the problem. Do you need more details or packet captures or something
> >> else to understand the problem better?
> > There's a 6 ms window between the TBTT event and beacon xmit. Most x86
> > [which have a USB port] and all AMD64 are fast enough to react in time.
> > Do you think you can check if your embedded system is fast enough?
> 
> I did not know about the 6ms constraint. Thanks for that detail. Where
> do I  add debug prints (i.e which function in which file) to confirm
> that my platform meets the 6ms requirement?
Is the driver/fw really that hard to understand? After all, you are lucky
to have the HW specs. I would put it into the firmware:
 
start: first line in handle_pretbtt in wlan.c
stop: right after set(AR9170_MAC_REG_BCN_CTRL, AR9170_BCN_CTRL_READY);
	 in cmd.c

BTW: I got the name wrong, it's not TBTT but the PRETBTT event which
is triggered 6 ms before the TBTT.

> Also, does the host wait for the TBTT event before processing the next
> beacon? I am not clear on the beacon xmit path and would very much
> appreciate some details on who (carl9170/mac80211/hostapd) is
> responsible for which part of the beacon creation and transmission so
> I can debug appropriately.
After the PRETBTT event is triggered, the firmware/driver/mac80211 has
6ms to update the beacon. Of course, you can play around with different
delays, just update CARL9170_PRETBTT_KUS in hw.h and recompile the
fw and driver.

> > An alternative approach we could reorder the TIM IE within the beacon
> > and put it at the end. This step reduces the delta between the old
> > and new beacon and prevents the corruption.
> 
> I can try this too if you can tell me which function controls this.
in net/mac80211/tx.c look for the NL80211_IFTYPE_AP case
and move:

	if (beacon->tail)
		memcpy(skb_put(skb, beacon->tail_len),
				beacon->tail, beacon->tail_len);

in front of
	if (local->tim_in_locked_section) {

Regards,
	Chr
