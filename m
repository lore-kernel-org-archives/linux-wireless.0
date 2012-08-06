Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52379 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab2HFTPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:15:49 -0400
Received: by yhmm54 with SMTP id m54so2868792yhm.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 12:15:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343938505.4471.31.camel@jlt3.sipsolutions.net>
References: <1343938505.4471.31.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Aug 2012 12:15:28 -0700
Message-ID: <CAB=NE6UUCVUDAn75UNX1uH=BMPkmjCtWr16iYBrGifkESCv=sA@mail.gmail.com> (sfid-20120806_211553_186910_782DC454)
Subject: Re: [PATCH] compat: handle pci suspend/resume on kernel 2.6.29
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 2, 2012 at 1:15 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Before kernel 2.6.29, we use compat_pci_{suspend,resume}
> and not the SIMPLE_DEV_PM_OPS, which include the code for
> PCI device handling. For 2.6.30 and higher, the core PCI
> code includes the device handling.
>
> That leaves 2.6.29 as the odd one out and causes suspend
> and resume to fail. Fix it by including the PCI device
> handling code in the definition of SIMPLE_DEV_PM_OPS for
> that kernel version.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied and pushed, thanks!

  Luis
