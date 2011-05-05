Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44558 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1EEBk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 21:40:27 -0400
Received: by pwi15 with SMTP id 15so773178pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 18:40:27 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19906.158.278401.536454@gargle.gargle.HOWL> (sfid-20110505_034031_274225_14D7E481)
Date: Thu, 5 May 2011 07:12:54 +0530
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: linux-wireless@vger.kernel.org
Subject: bug: 2 second wireless stall on ath9k link
In-Reply-To: <BANLkTinJK3B_dcX4Qmuo=hC5j654YLLmCA@mail.gmail.com>
References: <BANLkTinJK3B_dcX4Qmuo=hC5j654YLLmCA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Halperin wrote:
> Hi,
> 
> I have two identical Dell Inspiron 530n desktops running latest w-t
> (07e789c5094735747b3df8a7840f61467575ba9e, master 2011-05-04) on
> Ubuntu 10.04.2 LTS. I have uninstalled network-manager from both
> devices and, as far as I can tell, no software processes or daemons
> interfere with my wireless configurations.
> 
> The AP machine has an AR9280-based device and an IWL5300 based device.
> I blacklist ath9k and iwlagn modules from loading on boot. It is
> running latest hostap.git, though I've seen the same issue with older
> versions.
> 
> The client machine has one AR9380-based NIC, one IWL5300-based NIC,
> and one RT2800pci NIC. I blacklist ath9k, iwlagn, and rt2800pci from
> loading on boot.
> 
> When I set up the client to connect (using iwconfig essid) to the AP
> (no encryption, channel 48 with HT40-) and run iperf, I sometimes see
> 2-second drops of the connection. I run iperf to generate elastic TCP
> flows that see ~150 Mbps, and in parallel I run ping <AP> -i 0.2.
> Here's the ping log:

Your timing couldn't be better. :)
https://patchwork.kernel.org/patch/753862/

Sujith
