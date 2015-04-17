Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932904AbbDQQXX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 12:23:23 -0400
Message-ID: <1429287857.20604.13.camel@redhat.com> (sfid-20150417_182327_687650_63637EFE)
Subject: Re: wireless driver ath9k and module 80211 interaction
From: Dan Williams <dcbw@redhat.com>
To: Roshanak Rasoli <mrs.roshanak@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 Apr 2015 11:24:17 -0500
In-Reply-To: <CAGpeqH3J4BvcDjWfVfxeHKj=aY=B3HYjerfN2ZbBQ3WFUQKBWg@mail.gmail.com>
References: <CAGpeqH3J4BvcDjWfVfxeHKj=aY=B3HYjerfN2ZbBQ3WFUQKBWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-04-17 at 18:01 +0200, Roshanak Rasoli wrote:
> Hi experts,
> 
> I have a question about the code  that you wrote;
> 
> 1- How does the ath9k announce itself to the mac80211?

The ath9k driver handles its own hardware detection via normal kernel
probing and matching mechanisms, and you end up in
drivers/net/wireless/ath/ath9k/pci.c::ath_pci_probe() or ath_ahb_probe()
depending on the bus the device uses.  From there ath9k calls
ieee80211_alloc_hw() which is how ath9k "announces" itself to mac80211.

> 2- How can the mac80211 know how to configure the ath9k.

The hardware module (ath9k) sends a set of "ops" (struct ieee80211_ops)
to mac80211 in the ieee80211_alloc_hw() call that contains callbacks
that mac80211 will run when it needs to configure the device.  See
drivers/net/wireless/ath/ath9k/main.c for the ath9k_ops structure.

Dan

> Could you please point out to the code.
> 
> Thanks in advance.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


