Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vps0.lunn.ch ([178.209.37.122]:37877 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751306AbdC1PSv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 11:18:51 -0400
Date: Tue, 28 Mar 2017 17:18:37 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alban <albeu@free.fr>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        John Crispin <john@phrozen.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        m@kresin.me
Subject: Re: [PATCH 1/7] Documentation: dt: net: Update the ath9k binding for
 SoC devices
Message-ID: <20170328151837.GC3152@lunn.ch> (sfid-20170328_172021_896431_EF0D4A4C)
References: <1489439116-4233-1-git-send-email-albeu@free.fr>
 <1897671.fKa4XTnU1K@debian64>
 <20170328104441.5feedcf4@avionic-0020>
 <2357006.NGKQYCh4BG@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2357006.NGKQYCh4BG@debian64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> But LEDE/OpenWRT rely on the firmware loading API more than ever and 
> currently there is not a replacement for it.

....


> I looked into 10-ath9k-eeprom [0] of LEDE's AR71XX target and I noticed
> that quite a few devices patch the MACs of the wifi.
> If you look at the code for the Airtight C-55 and C-60, Meraki MR18,
> Meraki Z1, you'll notice that each one has to add a fixed value (+1,
> +2, ...) to the extraced MAC-Address. So how would you replicate this,
> with "nvmem-cell-names = address" without some sort of 
> nvmem-provider-processor?

...
 
> https://github.com/lede-project/source/blob/master/target/linux/ar71xx/files/arch/mips/ath79/dev-eth.c#L1204
> 
> and grep lists the following devices:
> mach-dgl-5500-a1.c, mach-dhp-1565-a1.c, mach-dir-505-a1.c, mach-dir-615-c1.c
> mach-dir-615-i1.c, mach-dir-825-b1.c, mach-dir-825-c1.c, mach-tew-673gru.c
> mach-tew-712br.c, mach-tew-732br.c, mach-tew-823dru.c

I would say a big part of the problem is that all of these use cases
are outside of mainline. Why should mainline support something which
is not actually used in mainline.

So i would suggest your first step is to bring some of these devices
into mainline. Once in mainline, it becomes a mainline issue, and
people will help get it solved.

       Andrew
