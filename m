Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63581 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab1DHFgy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 01:36:54 -0400
Received: by wwa36 with SMTP id 36so3827565wwa.1
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 22:36:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D9E2380.30006@googlemail.com>
References: <4D9E2380.30006@googlemail.com>
Date: Fri, 8 Apr 2011 11:06:52 +0530
Message-ID: <BANLkTi=An7ozDgUr5yDn871yAsjZfGp-AA@mail.gmail.com>
Subject: Re: ath9k: antenna selection possible?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Dennis Borgmann <dennis.borgmann@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 8, 2011 at 2:20 AM, Dennis Borgmann
<dennis.borgmann@googlemail.com> wrote:
> Hello linux-wireless list!
>
> ath5k got an option to change usage of antennae as mentioned here (via
> debugfs):
>
> http://www.mail-archive.com/ath5k-devel@lists.ath5k.org/msg02979.html
>
> Is this possible with ath9k as well? And if so, how?

Currently we can only change the tx/rx chain mask like this
sudo echo 0x1 > /sys/kernel/debug/ieee80211/phy0/ath9k/rx_chainmask
sudo echo 0x1 > /sys/kernel/debug/ieee80211/phy0/ath9k/tx_chainmask

We need to add the set_antenna/get_antenna call backs.

>
> Best regards,
> Dennis
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
