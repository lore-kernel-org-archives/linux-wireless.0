Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34097 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbbGJFUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 01:20:14 -0400
Received: by wgov12 with SMTP id v12so55222681wgo.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 22:20:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559F0BEF.4000808@candelatech.com>
References: <559F0BEF.4000808@candelatech.com>
Date: Fri, 10 Jul 2015 07:20:13 +0200
Message-ID: <CA+BoTQm-e__mFFPBpr+Lphe3BGs+m3EaLZkn1DE2nz8EkKHT6Q@mail.gmail.com> (sfid-20150710_072018_726064_F770B7C1)
Subject: Re: How is AP supposed to handle power-save packets from peer?
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 July 2015 at 02:03, Ben Greear <greearb@candelatech.com> wrote:
> Suppose one is doing heavy download (AP -> peer traffic), and there are lots of frames in the
> NIC's tx buffers (ath10k firmware, in this case).
>
> Then, peer sends a power-save pkt telling AP it is going off-channel or otherwise
> will be unavailable.

I assume you're exploring the worst-case scenario when all tx buffers
are consumed and peer goes to sleep, am I correct?


>
> What is the appropriate behaviour from the AP?  Can the firmware just drop all those tx frames to
> make room to handle other stations?  Maybe report ACK failure and hope the upper level stacks
> retransmit as appropriate?
>
> Or, is the host supposed to flush the peer's packets to clear out the frames?
>
> Or, is firmware somehow supposed to keep all the frames for when the peer comes back?

Firmware will keep frames buffered until station wakes up again.

There's a timeout to detect stale stations as far as I'm aware and the
default value is 10s (sounds familiar? this goes back to mgmt tx/
credit starvation). This makes to handle stations that go to sleep and
then out of range/away. AP doesn't need to keep frames buffered till
the end of time. Once the timeout is hit firmware stops caring about
station's last seen sleep state transition and marks it as awake and
just sends frames to it (with tons of retransmits if it's really not
there anymore since there'd be noone to ACK) - in which case you'll
get no_ack=1 in tx status.

See: WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS

Ideally there should be little to no buffer bloat but it's difficult
to do that considering aggregation sizes of 11ac..


Michał
