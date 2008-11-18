Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:14714 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbYKRONi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 09:13:38 -0500
Received: by wf-out-1314.google.com with SMTP id 27so3171125wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 18 Nov 2008 06:13:37 -0800 (PST)
Message-ID: <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com> (sfid-20081118_151342_814259_8B7C1A9E)
Date: Tue, 18 Nov 2008 16:13:37 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
Cc: "John Linville" <linville@tuxdriver.com>,
	"reinette chatre" <reinette.chatre@intel.com>,
	"Marcel Holtmann" <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Matt Mackall" <mpm@selenic.com>,
	"Christophe Dumez" <dchris@gmail.com>, "Zhu Yi" <yi.zhu@intel.com>,
	"=?UTF-8?Q?Jan_V=C4=8Del=C3=A1k?=" <vcelak.jan@seznam.cz>,
	"Thomas Witt" <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andres Freund" <andres@anarazel.de>
In-Reply-To: <1227001390.4014.43.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 18, 2008 at 11:43 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-11-18 at 01:47 +0100, Johannes Berg wrote:
>
>> So I dug deeper into the DMA problems I had with iwlagn and a kind soul
>> helped me in that he said something about pci-e alignment and mentioned
>> the iwl_rx_allocate function to check for crossing 4KB boundaries. Since
>> there's 8KB A-MPDU support, crossing 4k boundaries didn't seem like
>> something the device would fail with
>
> Come to think of it, maybe it does. One common failure case seems to be
> "this goes wrong with an 11n AP, but not on a regular one", so one
> explanation for that would be that the hardware designers expect the
> driver to split up the DMA into multiple DMA descriptors at 4K
> boundaries, but iwlagn uses only one and undefined behaviour results.
> That's something you'll need to ask the HW designers though or look up
> in the datasheet.

You are off here. The constrain is just that address will fit in 32
bit register. I don't know why this constrain, but there is always a
reason.

We've assumed that allocations are on the page or cache boundaries I'm
not who already assured me that this is the case. I  actually  haven't
encountered this problem on X86_64 I even have the correct check. What
I know there is difference in memory mapping in PPC64 as it has IOMMU.
 Hope this address the wrong command queue number bug but I'm not
sure.
There are other places with alignment requirement in the driver we
probably need to address as well.

Tomas
