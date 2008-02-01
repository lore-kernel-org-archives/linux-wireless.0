Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.227]:55963 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbYBAWRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 17:17:09 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1983019wxd.4
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 14:17:08 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 QoS/aggregation questions, thoughts
Date: Fri, 1 Feb 2008 23:16:44 +0100
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Tomas Winkler <tomasw@gmail.com>,
	Patrick McHardy <kaber@trash.net>
References: <1201882512.4188.66.camel@johannes.berg>
In-Reply-To: <1201882512.4188.66.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802012316.44283.IvDoorn@gmail.com> (sfid-20080201_221717_878408_9897D2A4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Below are some comments regarding the rt2x00 implementations of
rings/queues. Note that all comments are for the actual hardware or
the current implementation inside rt2x00.git.
Queue handling has received a drastic overhaul in rt2x00, so the
implementation, especially for the beacon, is different then currently
in wireless-2.6. For the beacons I also have to add that rt2x00.git now
supports multiple virtual interfaces in master mode, which were made
possible due to the changes in the queue handling.
All patches are currently in testing, and I hope to send them to wireless-2.6
next weekend.

>      1. move queue configuration for data queues to bss-config
>         structure, it really is part of the bss configuration since it
>         is mandated by the AP
>      2. get rid of IEEE80211_TX_QUEUE_BEACON, it isn't used in mac80211
>         and it's not hardware-independent, not all hardware actually
>         uses a queue for beacons (b43 for example does beaconing
>         differently), those drivers that do use a queue will have to do
>         that internally. Also, the one place where it is used is the
>         queue configuration for IBSS beacons, but that somewhat bogus
>         anyway since we never reset that should we go back into AP mode
>         after being in IBSS! Hence, I think the driver should handle
>         that when an interface is brought up. Ivo, any comments?

rt2x00 uses the IEEE80211_TX_QUEUE_BEACON, but mostly for the internal
usage you described. Although only rt2400pci and rt2500pci have the actual
"ring" in the register, all other drivers use it as reference to

Per interface a queue entry is assigned in the ieee80211_vif private data,
this means that the queue structure itself is only used to find a free entry
for the interface.

>      3. get rid of IEEE80211_TX_QUEUE_AFTER_BEACON, we have
>         IEEE80211_TXCTL_SEND_AFTER_DTIM now and that is
>         hardware-independent

rt2400pci, rt2500pci and rt2500usb have a special dedicated queue which is called
the ATIM queue. The implementation is a guess since it was never used in the
legacy drivers. But it is clear it contains frames which are send directly after the beacon.
rt61pci and rt73usb don't contain the ATIM ring, and there doesn't seem to be a valid
replacement. Since Ralink never released the AP version of there driver under the GPL,
getting the driver to work in AP mode is mosting guessing.

>      4. remove IEEE80211_TX_QUEUE_SVP, it's something strange and
>         atheros specific

I always wondered what the queue was. ;)

>      5. remove IEEE80211_TX_QUEUE_DATA4, only rt61pci uses that and that
>         use is strange, Ivo? We never submit frames to that queue...

In rt2x00.git that queue has been removed.
A short overview of rings in rt2x00:
rt2400pci: PRIO, TX, ATIM, BEACON
rt2500pci: PRIO, TX, ATIM, BEACON
rt2500usb: PRIO, TX, ATIM, BEACON
rt61pci: AC0, AC1, AC2, AC3, MGMT, HCCA
rt73usb AC0, AC1, AC2, AC3, MGMT, HCCA

The legacy drivers uses the MGMT and PRIO rings to send management frames over.
ATIM and HCCA are unused and the AC* and TX rings are used for frames.

rt2x00 changed this and made the PRIO queue normal TX queue with higher priority
then the TX ring. I am not really sure what to make of the MGMT queue, up untill now
it was unused, but if there is some use for it...
HCCA queue is a big mysterie, there are registers to initialize it inside the device,
but in implementation of the legacy driver the queue was unused, I haven't found a
correct entry point yet to send frames over it, since that interface seems to be missing
in the device... So either I am missing something or the queue was half-implemented
in the device itself.. :S

> This would leave us with the regular WMM four data queues. When hardware
> announces more than four queues we would assume that the remaining
> queues are usable for aggregation so that drivers for hardware that
> needs a beacon queue (for example) would have to subtract that from the
> number of available queues announced to mac80211.

Which already happened I believe..

Ivo
