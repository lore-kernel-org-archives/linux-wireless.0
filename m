Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64689 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0KBWAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 18:00:06 -0400
Received: by fxm16 with SMTP id 16so6267351fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 15:00:04 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: =?iso-8859-1?q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
Subject: Re: [ath9k-devel] [RFC] ath9k: fix tx queue selection
Date: Tue, 2 Nov 2010 23:59:11 +0100
Cc: Felix Fietkau <nbd@openwrt.org>, ath9k-devel@lists.ath9k.org,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <alpine.DEB.2.00.1011021655080.23045@vtdt3> <4CD046D2.4080703@openwrt.org>
In-Reply-To: <4CD046D2.4080703@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011022359.12025.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag 02 November 2010 schrieb Felix Fietkau:
> On 2010-11-02 5:13 PM, Björn Smedman wrote:
> > The following patch attempts to fix some problems with ath9k tx queue 
> > selection:
> > 
> > 1. There was a posible mismatch between the queue selected for QoS packets 
> > (on which locking, queue start/stop and statistics where performed) and 
> > the queue actually used for TX. This is fixed by selecting the tx queue 
> > based on the TID of the 802.11 header for this type of packet.
> This should not be necessary. mac80211 should take care of queue
> selection properly for QoS frames. If it doesn't, then that is the bug
> that needs to be fixed...

Not sure if this is related but I had some issues with rt2800pci and tx queue
selection as well. This was caused by a bug in the net stack. See [1] for the
details.

I don't have any clue if this also affects ath9k but this issue sounds similar.

Helmut

[1] http://www.spinics.net/lists/netdev/msg139832.html
