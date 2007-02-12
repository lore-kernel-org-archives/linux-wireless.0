Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-44.dex002.intermedia.net ([64.78.21.135]:23166 "EHLO
	dhost002-44.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965288AbXBLSoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 13:44:39 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Mon, 12 Feb 2007 10:30:20 -0800
To: Michael Buesch <mb@bu3sch.de>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Message-ID: <20070212183020.GA16597@instant802.com>
References: <200702041344.19117.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200702041344.19117.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 04, 2007 at 01:44:18PM +0100, Michael Buesch wrote:

> We need the phase1 for bcm43xx. We need to upload it to
> card memory and we need to pass it on every TX on the DMA.

> So, currently we receive the phase1 key on the first
> encrypted TX. That's too late, as we already receive encrypted
> packets before that. bcm43xx needs the phase1 key (and the iv32)
> on RX. It uses the one uploaded into the card memory. But it
> is not uploaded, yet, as we did not TX any encrypted packet.

How exactly is this supposed to work for RX? Phase1 needs to be
calculated after 65536 frames (whenever iv32 changes), but the
exact time for RX case is unclear due to possible loss of frames and
retransmissions etc. Is bcm43xx just going drop couple of packets
whenever the phase1 value is changed? Or is there some kind of
mechanism for the hardware/firmware request a new phase1 value? Or is
this supposed to be recovered from in software (which is something that
d80211 is able to do if the radio driver notifies that the frame was not
decrypted)?

-- 
Jouni Malinen                                            PGP id EFC895FA
