Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62063 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab1BDKXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 05:23:37 -0500
Received: by iyj18 with SMTP id 18so1974898iyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 02:23:36 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19787.54182.293274.705139@gargle.gargle.HOWL>
Date: Fri, 4 Feb 2011 15:53:34 +0530
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k: Drain txq before sending a nullfunc frame.
In-Reply-To: <AANLkTim_7Xup048eGxz2HWj0AqRS_+jvC1LqgCdU9ZOh@mail.gmail.com>
References: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
	<19787.47298.50879.401166@gargle.gargle.HOWL>
	<AANLkTim_7Xup048eGxz2HWj0AqRS_+jvC1LqgCdU9ZOh@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan wrote:
> So, will it be appropriate to add stop and wake queue while calling
> ath_drain_all_txq?

Am not sure. I happened to look at that comment and thought it a bit
odd that the caller is expected to call wake_queues().

> Currently, flush() is called only when mac80211 is moving to off
> channel. Even if we call flush before sending nullfunc frame for power
> save, a question arises if it should be done with drop = true or
> false.  If set as false, there is a possibility that the frames might
> be still around in the hw when nullfunc is sent and the same issue
> might pop up.

"Still around in the hw" ?

ath_drain_all_txq() will stop HW DMA first and then remove all the
pending frames in all HW queues and add them to the free buffer list.

When flush() is called, the driver would empty its HW queues and then
mac80211 would proceed to send the nullfunc frame. Isn't this the fix
that you require ?

> Drop is set as false for scanning. iwlwifi waits for 2sec for all the
> packets to complete but for ath9k, since it is asynchronous, I am not
> quite sure of how to wait for tx_completion of all pending packets.

Not sure I understand. Why should we wait for completion of pending packets
when we have just drained them ?

> We were considering yet another approach too:
> In this case, if a nullfunc frame for PS comes to the driver when
> there are pending frames in the hw queue(the frames queued before
> 100ms and still pending because of highly noisy environment), silently
> drop the frame so that mac80211 will try once again after 100ms to go
> to PS. The issue that I face here is, ath9k does not know whether this
> frame is actually for PS or for fake sleep before scanning.

Well, silently dropping frames is generally frowned upon. :)

Sujith
