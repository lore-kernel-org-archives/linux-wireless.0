Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:38798 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752609AbYCQU5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 16:57:30 -0400
Message-ID: <20080317225724.th0d46jpsc0o48o8@hayate.ip6> (sfid-20080317_205735_232273_F568BCAA)
Date: Mon, 17 Mar 2008 22:57:24 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] fix error handling logic in generic_rndis_bind
References: <20080317161007.GA32154@dmon-lap.sw.ru>
In-Reply-To: <20080317161007.GA32154@dmon-lap.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Dmitri Monakhov <dmonakhov@openvz.org>:

> Hi,
> Today after i've plugged usbdevice to my notebook i've got OOPS
> which was caused by generic_rndis_bind() probe function.
> BUG LOG:
  ...
>
> BUGGY PLACE:
>
> generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
  ...
>
> Bug was introduced by following commit:
> commit 039ee17d1baabaa21783a0d5ab3e8c6d8c794bdf
> Author: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Date:   Sun Jan 27 23:34:33 2008 +0200
>

Thanks for noticing this. Problem is that when rndis_query fails  
'phym' pointer is not set. That rndis_query was add for wireless  
device support, it's known that wired devices may fail that query, and  
shouldn't fail out from generic_rndis_bind. Correct fix is to either  
point 'phym' to zero u32 or prevent  use when rndis_query fails. I'll  
send patch very soon.

  - Jussi Kivilinna



