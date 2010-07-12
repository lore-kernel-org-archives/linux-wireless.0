Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42411 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0GLQZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 12:25:34 -0400
Received: by qwh6 with SMTP id 6so1345222qwh.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jul 2010 09:25:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com>
References: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com>
Date: Mon, 12 Jul 2010 09:25:33 -0700
Message-ID: <AANLkTilFB6o-Qq0VTVNhd01TpdLX4JUYCAlZu-RgKH1I@mail.gmail.com>
Subject: Re: Rate control & USB
From: Steve deRosier <steve@cozybit.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo,

I don't know much about the details of either the rate control
algorithms, or other USB devices, but the usb8388 with the libertas_tf
driver _does_ report per skb tx feedback, not just that the frame has
been sent to the hardware.  Perhaps there's other USB devices that
also have good feedback?

In any case, I'm just asking that nothing gets broken in the case
where the USB devices _do_ provide the tx feedback information.  I
assume you weren't going to break anything, but I just wanted to make
sure you knew that some USB devices did have this feature.

- Steve

On Mon, Jul 12, 2010 at 3:48 AM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
> I am currently looking into the old problem of the mac80211 rate
> control algorithms
> and USB devices. The Ralink USB devices (and as far as I know, the
> other USB devices
> as well), do not work well with the PID and Minstrel algorithms. This
> is caused by the
> fact that USB devices do not report the TX status to mac80211.
>
> When the URB callback function is called, it only indicates the frame
> was uploaded
> to the hardware, and the frame has been enqueued in the hardware queue
> within the
> USB device itself. The statistics about the number of retries and the
> ACK status are
> therefor lost.
>
> These statistics are however often still available (in a limited form)
> within the device
> registers. Although these statistics cannot be obtained per frame, it
> might still be
> possible to control a working rate control algorithm with it.
>
> My current idea for this, is not to generate a completely new
> algorithm, but base
> it on the currently existing rate controls. For this I want to
> introduce a new flag:
> IEEE80211_HW_REQUIRES_BATCH_TX_STATUS, This flag will enable
> polling in mac80211, where the callback function ieee80211_ops->get_tx_stats
> is called. In this function the driver can fill in a structure
> containing the number
> of Acked frames, non-acked frames and retries. This structure can then be
> passed to a new function in the rate_control_ops structure.
>
> The problem here is that we have lost the per-sta statistics. However using the
> single TX status reports, we can count the number of frames which are sent for
> a given STA during the poll interval. We can then determine the percentage of
> frames sent for that STA, We can then add the percentage of the retry and ACK
> count to each STA. Throughout poll interval the rate algorithm would send all
> frames to the same STA with the same TX rate, but between polls, the rate will
> be updated.
>
> Overall these changes will not make the optimal use of PID or
> Minstrel, but it would
> at least improve the situation for USB.
>
> Any thoughts about this solution?
>
> Ivo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
