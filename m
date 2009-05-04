Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:37590 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931AbZEDQfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:35:37 -0400
Received: by ewy24 with SMTP id 24so4098225ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 09:35:37 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: IEEE80211 Acknowledgement
Date: Mon, 4 May 2009 18:35:34 +0200
Cc: Alexandre Becholey <alexandre@shockfish.com>,
	linux-wireless@vger.kernel.org
References: <49FF06BB.2090106@shockfish.com> <200905041729.13805.IvDoorn@gmail.com> <1241451174.8683.48.camel@johannes.local>
In-Reply-To: <1241451174.8683.48.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200905041835.35104.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 04 May 2009, Johannes Berg wrote:
> On Mon, 2009-05-04 at 17:29 +0200, Ivo van Doorn wrote:
> > Hi,
> > 
> > Just as side information for other readers:
> > 
> > Alexandre is looking into the problem of rt2500usb/rt73usb and
> > possibly other USB drivers, that they cannot report the ACK status
> > of frames to mac80211 which is problematic for hostapd.
> 
> I realise that this probably doesn't help and is tangential to the
> question being asked, but I do not think processing ACK frames in
> software is possible for this, since the software does not know which
> frame was transmitted, due to four queues being used, and retries etc.

Well I believe the idea would be that (I'll see if I can dig up a reference
to the initial discussion about this feature on this list) the driver sets a flag
that mac80211 needs to keep a list of all frames send out to the driver and
listens for ACK's.

As soon as a ACK was passed from driver to mac80211 it could check if
the corresponding frame was in the list and remove the frame from the list
and generate a tx_status response indicating success.
Off course all frames must be checked for the timeout value as well to see
if the frame wasn't send (in which case the tx_status event is send as well).

There shouldn't be a problem with multi-queue with this if the list of frames
is put onto a single list instead of one list per queue.
As for the retries and other statistics, do we honestly care?
At the moment rt2500usb/rt73usb indicate the frame has not been acked
and set the retry value to 1. If we somehow can tell if the frame was send out
or not, isn't that a step forward already? The retry value is needed for the
rate algorithm, but it is receiving the same incorrect value now as well, so it wouldn't
be a step backward in that perspective. ;)

Ivo
