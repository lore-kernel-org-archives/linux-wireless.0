Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55374 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab2AJNnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 08:43:21 -0500
Received: by pbdu13 with SMTP id u13so2824499pbd.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jan 2012 05:43:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201101301.q0AD1qSK004871@mail.maya.org>
References: <4EFF12D9.3010602@01019freenet.de>
	<2766356.70ylY68Gqi@helmutmobil.site>
	<4F040FEA.3080703@01019freenet.de>
	<1408490.qSFZVkU7fA@helmutmobil.site>
	<4F0562DF.3000200@dualc.maya.org>
	<CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com>
	<4F0AEBAB.9020104@01019freenet.de>
	<CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
	<201201100803.q0A83nsQ003757@mail.maya.org>
	<CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
	<201201101156.q0ABuS87004643@mail.maya.org>
	<CAGXE3d9usjQB+9jkBPgtvL6fT8L84ZzDQQ3UqHyMdb+PRfhrKA@mail.gmail.com>
	<201201101301.q0AD1qSK004871@mail.maya.org>
Date: Tue, 10 Jan 2012 14:43:21 +0100
Message-ID: <CAGXE3d9R7BOfTOc=SW6NT89=CxBugXBEnj+nffKw4M-VwtPcpA@mail.gmail.com> (sfid-20120110_144325_118154_E35FD9CB)
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Jan 10, 2012 at 2:01 PM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> Helmut Schaa schrieb:
> [...]
>> So this looks good to me although the broken tx status for BAR frames
>> is for sure a rt2800pci problem (or even a hw issue).
>
> Sorry - What do you mean with "hw issue"? Is my hw broken?

Hehe, no :)

> Or is it a specific "behavior" of exactly this device:

I think most rt2800pci will behave the same and just interpret a
BlockAck as response to a BAR in a different manner as a BlockAck
in response to a Data frame.

When we send the BAR we tell the hw that the frame needs to be
acknowledged and according to the spec the hw will only count
a normal ACK as successful transmission, the peer will however
answer with a BlockAck as long as a BA session is active.

It might be possible to advise the hw to allow the BAR to be acked
by a BlockAck by specifying AMDPU=1 in the TXWI. Not sure
if that breaks anything else.

However, a BAR seems to be "ack-able" by both an ACK and a
BlockAck according to 802.11-2007. If the recipient answers with
an ACK the BA session might already be terminated and we would
stop the BA session as soon as 3 BARs failed with the previous
patch. This should be fine I guess.

So you might just give the following a try (also fully untested and
maybe with some of your debugging output enabled).

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c
b/drivers/net/wireless/rt2x00/rt2x00queue.c
index e4641da..5d0a3d3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -393,6 +393,9 @@ static void
rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 		txdesc->u.ht.txop = TXOP_SIFS;
 	else
 		txdesc->u.ht.txop = TXOP_HTTXOP;
+
+	if (ieee80211_is_back_req(hdr->frame_control))
+		__set_bit(ENTRY_TXD_HT_AMPDU, &txdesc->flags);
 }

 static void rt2x00queue_create_tx_descriptor(struct rt2x00_dev *rt2x00dev,
