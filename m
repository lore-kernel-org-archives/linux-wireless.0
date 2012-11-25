Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50652 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab2KYAzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 19:55:40 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so7219905pbc.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 16:55:39 -0800 (PST)
Date: Sat, 24 Nov 2012 16:55:31 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: Cesare Leonardi <celeonar@gmail.com>
Cc: 656813@bugs.debian.org, s.L-H@gmx.de,
	linux-wireless@vger.kernel.org
Subject: Re: cfg80211: failed to add phy80211 symlink to netdev!
Message-ID: <20121125005531.GA2326@elie.Belkin> (sfid-20121125_015551_603460_D9C10A34)
References: <20120808215346.GA17574@tommaso>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120808215346.GA17574@tommaso>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reassign 656813 src:linux linux-2.6/3.2.1-1
# 3.0->3.1 regression
severity 656813 important
found 656813 linux/3.2.21-3, linux/3.4.4-1~experimental.1
fixed 656813 linux/3.5-1~experimental.1
quit

Cesare Leonardi wrote:

> I admit that starting from the Stanislaw Gruszka's reply i was a bit
> lost in this bug report...
>
> With this followup i only wanted to say that with the kernel 3.5 the
> message "cfg80211: failed to add phy80211 symlink to netdev!" is gone.

Hurrah, thanks for testing.

Relevant patches:

  7ed85b65ab61 net/wireless: ipw2200: Fix WARN_ON occurring in
               wiphy_register called by ipw_pci_probe
  b4050790d0a6 ipw2200: Fix order of device registration
  e19d8baf8cfc ipw2100: Fix order of device registration
  aac495a8002b net/wireless: ipw2100: Fix WARN_ON occurring in
               wiphy_register called by ipw2100_pci_init_one

They apply cleanly to 3.2.y, though I haven't tested them.  If you'd
like instructions for trying a backport, please don't hesitate to ask.

Ciao,
Jonathan
