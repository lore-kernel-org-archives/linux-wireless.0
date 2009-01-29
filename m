Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:34355 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZA2GGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 01:06:49 -0500
Received: by wf-out-1314.google.com with SMTP id 27so8517110wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 22:06:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090128170303.32025.21799.stgit@tikku>
References: <20090128170215.32025.32389.stgit@tikku>
	 <20090128170303.32025.21799.stgit@tikku>
Date: Thu, 29 Jan 2009 11:36:48 +0530
Message-ID: <8e92b4100901282206r64a07a9dtcc44db645d301b28@mail.gmail.com> (sfid-20090129_070702_145344_32FCF142)
Subject: Re: [PATCH v3 2/2] mac80211: use ps-poll when dynamic power save mode
	is disabled
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 10:33 PM, Kalle Valo <kalle.valo@nokia.com> wrote:

> +                                * Here is assumed that the driver will be
> +                                * able to send ps-poll frame and receive a
> +                                * response even though power save mode is
> +                                * enabled, but some drivers might require
> +                                * to disable power save here. This needs
> +                                * to be investigated.

ath9k too needs power save to be disabled to send or receive any frame. Same as
broadcom. I hope it is the same for many others too. I'm curious about
the design of
stlc45xx/p54 since it is capable of sending/receiving even though power save is
enabled. I wonder what blocks of the hw are off when ps is enabled
since it is capable
of doing the basic operation of Tx/Rx which is the only thing expected
from a driver.
I seriously doubt if NIC is saving any power at all or the hw design
is very novel and
interesting.

Thanks,
Vivek.
