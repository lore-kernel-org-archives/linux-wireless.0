Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from void.printf.net ([89.145.121.20]:45043 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab1CYRwx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 13:52:53 -0400
From: Chris Ball <cjb@laptop.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Wilson Loi <wlsloi@gmail.com>, Ohad Ben-Cohen <ohad@wizery.com>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Gao Yunpeng <yunpeng.gao@intel.com>
Subject: Re: [PATCH v1 2/2] sdio: add power_restore support with MMC_PM_KEEP_POWER mode
References: <AANLkTi=CSK8nRF7CTzsq06Bk8Cr74ZcwJBf53_wWbpnv@mail.gmail.com>
	<AANLkTimvLzgO1VHAbYz0uh-TVBGdLr-aDcyaGyzS2QMi@mail.gmail.com>
	<AANLkTimevrNU+JC=KvMzpGfip7cimPMo2cmBzvPiMb9R@mail.gmail.com>
	<AANLkTi=Zh2mY8SDRR6431=ykGOLAZJfmgAoDp09aV+O_@mail.gmail.com>
	<alpine.LFD.2.00.1103251315080.11889@xanadu.home>
Date: Fri, 25 Mar 2011 13:48:53 -0400
In-Reply-To: <alpine.LFD.2.00.1103251315080.11889@xanadu.home> (Nicolas
	Pitre's message of "Fri, 25 Mar 2011 13:17:34 -0400 (EDT)")
Message-ID: <m3ei5vks56.fsf@pullcord.laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Mar 25 2011, Nicolas Pitre wrote:
> On Sat, 26 Mar 2011, Wilson Loi wrote:
>
>> Sorry, this is the first time I sent a patch.
>> 
>> There are two case for the WLAN SDIO card to do power saving.
>> 1. Totally cut off the power of WLAN network interface.
>> 2. offload the network state to WLAN SDIO firmware.
>
> Case #2 is already supported with current code.  Patches for the 
> libertas driver are in the OLPC repository (no idea if they were 
> submitted upstream yet).

Yes, they're upstream now.  libertas/if_sdio.c:if_sdio_suspend() sets
MMC_PM_KEEP_POWER if a wakeup source has been set with "ethtool wol".

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
