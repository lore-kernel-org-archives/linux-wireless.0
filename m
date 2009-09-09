Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:61225 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZIIFrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 01:47:13 -0400
Received: by iwn42 with SMTP id 42so1619639iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 22:47:15 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 8 Sep 2009 22:39:28 -0700
Message-ID: <43e72e890909082239o62061a5q987696f4179b74b3@mail.gmail.com>
Subject: Re: ar9271 TX/RX buffer management
To: Denis Kirjanov <kirjanov@gmail.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	Benoit PAPILLAULT <benoit.papillault@luceor.com>
Cc: devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org,
	Felix Fietkau <nbd@openwrt.org>,
	Christian Lamparter <chunkeey@web.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding linux-wireless as I review ath9k/ar9170 tx/rx buffer management here.

On Tue, Sep 8, 2009 at 1:54 PM, Denis Kirjanov<kirjanov@gmail.com> wrote:
> Looks like tx/rx engine initialization code is very similar to ath9k
> driver.

I expect most of the driver to be very similar to ath9k, what changes
here is the transport and because of it support for HTC/HIF. What also
changes with the new transport requirements is the need to sleep
during read/writes. This is actually the main reason for a new
mac80211 driver interface. We could have mucked with ath9k itself but
feared that the changes are too intrusive so instead we'll work on a
different driver core where this is done. Technically it may be
possible in the future to have ath9k rely on the same driver core, who
knows but for now the job is to get ar9271 support up.

> The question is where to obtain some values such as the number of TX|RX
> buffers? Will these values are the same as that of the previous driver?

That's yet to be determined/developed and I'm glad you asked. First
let me review ath9k's TX/RX buffer management, then I'll review ar9170
buffer management and explain why I think we should consider doing
something a little different for ath9k_htc. Note I wrote ar9170, not
ar9271.

ath9k TX buffer management
========================

ath9k allocates a preset of TX buffers structs (struct ath_buf) upon
init and stuffs them into a spare buffer linked list. When mac80211
informs us it wants to TX an skb, ath9k_tx(), a buffer is taken from
this spare list, the skb is linked to the ath_buf, DMA'd and then the
ath_buf added onto the appropriate tx queue linked list depending on
the skb priority/TID. Upon TX completion the ath_buf is reset and put
back into the spare buffer list. When we are are low on spare ath_buf
buffers we ask mac80211 to stop sending us data, once we have enough
free spare buffers we wake the queues up again. We guarantee that we
will at some point tell mac80211 to send us data again as we only tell
mac80211 to stop sending us data if we have at least one pending
completion buffer list.

ath9k RX buffer management
=========================

ath9k allocates a preset of RX buffers and stuffs them into a linked
list. The buffers are DMA'd so that the hardware can stuff into each
buffer data for us to retrieve and send up to mac80211. Upon RX we
always allocate a new buffer prior to sending a frame up to mac80211
so that we can fill in the gap for the missing skb of the current skb
and if there is no more memory we stuff the buffer we currently are
processing into the free RX buffers linked list and disregard the
DMA'd data. We then tell the hardware it can use that same buffer
space again. If we were able to allocate a new buffer in place for the
current one we send it to mac80211 for processing. We use a
predetermined RX buffer size. This RX buffer size is the space
required to receive the biggest frame possible on the ath9k 802.11n
hardware -- which happens to be the biggest AMSDU frame. I should note
that although AMSDU frames are typically not received as I don't think
many devices or drivers support sending AMDSU frames I believe wifi
cert requires you to RX AMSDU frames. Anyway this AMSDU size
requirement pushes our RX buffer size close to 4 KB and because the
kernel only gaurantees it'll *at least* allocate the requested size we
sometimes end up allocating 8KB per buffer on some systems. We could
potentially improve upon this, I believe we'd have to link AMSDU data
together across different descriptors, and I think that's possible.

ar9170 TX buffer management
=========================

ar9170 uses a tx_pending skb_buf_head for stashing skbs mac80211 sends
it. Contrary to ath9k it uses the skb to place the private driver tx
control info for the skb to indicate to the hardware how to transmit
that frame. Aggregates are put into an another skb_queue_head for the
destination TID for the destination sta and that TID is added to a
linked list of pending TIDs which need processing. It later iterates
through the list of TIDs, and queues pending buffers ont the
tx_pending skb_buf_head. Eventually we peg the skb->data onto a urb
and submit it to the device on the endpoint.

ar9170 RX buffer management
==========================

ar9170 uses a USB stream mode to receive buffers. This means a single
urb received being processed can contain more than one data buffer.
This gets untangled by ar9170_rx() and handled individually on
ar9170_handle_mpdu(). Because the data is tangled on a stream it means
we have to allocate an skb for each frame and then copy the data onto
it. This is done on  ar9170_rx_copy_data().

-------------

What I'd like to eventually see is a common shared buffer management
for TX for aggregation for drivers like ar9170 or ath9k where
aggregation is done in software. Then we won't have such different
implementations. Using the skb_buf_head usage on ar9170 seems
appealing over ath9k's linked list of buffers, however not that this
is easily possible on ar9170 as the skb->data is simply filled with
the ar9170_tx_control info. I can't think of a way to do the same on
ath9k. If we can figure out a way it'd be great so we can try to
eventually share buffer management for aggregation on mac80211. I
shall note some aspects of aggregation is handled in firmware for
ar9271, haven't gotten to review what exactly yet.

One thing which I think we should learn from how ar9170 is implemented
for ar9271 is using urb anchors.

  Luis
