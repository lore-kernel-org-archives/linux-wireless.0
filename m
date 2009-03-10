Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a80-127-65-128.adsl.xs4all.nl ([80.127.65.128]:57121 "EHLO
	linux.wilsoft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZCJHds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 03:33:48 -0400
Message-ID: <678e6036a51d4d15838f21b4561ec67b.squirrel@www.wilsoft.nl> (sfid-20090310_083352_104802_AB67770D)
In-Reply-To: <1236650824-9568-1-git-send-email-lrodriguez@atheros.com>
References: <1236650824-9568-1-git-send-email-lrodriguez@atheros.com>
Date: Tue, 10 Mar 2009 07:45:29 +0100 (CET)
Subject: Re: [PATCH 0/4] ath9k: Fix usage on SMP systems with PCI devices
From: "W. van den Akker" <listsrv@wilsoft.nl>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Luis,

I will test it on my system.

To be continued...

gr,
WIllem

> Here's the long expected finished serialization series for ath9k
> which fixes usage of ath9k on PCI devices with SMP systems. The
> CPU notifier is perhaps overkill but technically it is correct.
>
> I finally managed to get a system to test this thing on and was able
> to reproduce and at least for me and Adel Gadllah it fixes the issue
> on STA, AP and IBSS modes.
>
> I would usually wait on for more testing but at this point I'm quite
> happy with the results. The serialization components are candidates for
> stable, the cpu notifier is not required we assume we don't want to
> support
> CPU hotplug for 2.6.27 and 2.6.28 :)
>
> Luis R. Rodriguez (4):
>   ath9k: implement IO serialization
>   ath9k: AR9280 PCI devices must serialize IO as well
>   ath9k: add cpu notifier to enhance device configuration
>   ath9k: remove dummy PCI "retry timeout" fix
>
>  drivers/net/wireless/ath9k/ath9k.h |    8 ++++
>  drivers/net/wireless/ath9k/hw.c    |   73
> +++++++++++++++++++++++++++++++++++-
>  drivers/net/wireless/ath9k/hw.h    |   11 ++++-
>  drivers/net/wireless/ath9k/main.c  |   30 +++++++++++++++
>  drivers/net/wireless/ath9k/pci.c   |   22 ++---------
>  5 files changed, 123 insertions(+), 21 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
>
>



-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

