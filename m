Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50620 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389Ab0A2RgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 12:36:00 -0500
Subject: Re: Building of compat-wireless-old in 2.6.25 BSP kernel for      
 PowerPC architecture
From: Pavel Roskin <proski@gnu.org>
To: PAN Sunny S K <sunnypan@ust.hk>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <58444.143.89.144.207.1264747272.squirrel@sqmail.ust.hk>
References: <51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk>
	 <43e72e891001260853s4811bc39s2399d138d0a7da83@mail.gmail.com>
	 <47088.143.89.144.207.1264589300.squirrel@sqmail.ust.hk>
	 <43e72e891001271006l3422b6e2iccb89954feeaa34b@mail.gmail.com>
	 <58444.143.89.144.207.1264747272.squirrel@sqmail.ust.hk>
Content-Type: text/plain
Date: Fri, 29 Jan 2010 12:35:46 -0500
Message-Id: <1264786546.27755.9.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-01-29 at 14:41 +0800, PAN Sunny S K wrote:

> P.S. This is the message when loading the driver modules at bootup FYI
> 
> ath: Unknown symbol wiphy_apply_custom_regulatory
> ath: Unknown symbol freq_reg_info

modprobe should be able to resolve such dependencies.  If you have to
use insmod, you'll need to load the required modules first.  It may be
tricky to figure out.  You could just try loading all modules you have
in a loop until they all load.  That way you'll find the dependencies.

> ath_pci: Unknown symbol ath_config_crypto_get

ath_pci is a module from MadWifi.  Yet the only reference to
ath_config_crypto_get Google can find is your message.

My guess is that you have some proprietary Atheros driver on the system.
It shouldn't be a big deal that it fails to load, but you may want to
remove it to see error messages that really matter.

-- 
Regards,
Pavel Roskin
