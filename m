Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:3366 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838Ab0EDDbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 23:31:11 -0400
Message-ID: <4BDF94FD.7050606@gmail.com>
Date: Tue, 04 May 2010 05:31:09 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 2/4] rt2x00: Enable RT30xx by default.
References: <1272919385-18004-1-git-send-email-gwingerde@gmail.com>	 <1272919385-18004-3-git-send-email-gwingerde@gmail.com>	 <1272920358.4907.3.camel@mj>  <201005040008.36956.s.L-H@gmx.de> <1272926643.6239.1.camel@mj>
In-Reply-To: <1272926643.6239.1.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/04/10 00:44, Pavel Roskin wrote:
> On Tue, 2010-05-04 at 00:08 +0200, Stefan Lippers-Hollmann wrote:
> 
>> RT2800PCI_RT30XX is not a new/ separate module, its only function is to 
>> limit the PCI ID space (to not claim PCI IDs for chipset generations not
>> yet debugged properly) of rt2800pci.ko; this symbol isn't even used 
>> anywhere else than within the PCI table.
> 
> I realize that.  Still, somebody upstream can object.
> 
>>  A 100% equivalent patch would be 
>> to just drop the config option completely. I doubt that doing that would 
>> meet resistance, as it merely adds previously 'unknown' (to be supported) 
>> PCI IDs.
> 
> That's what I would do.
> 

To be honest, at the moment I would just change the default from 'n' to 'y'
for one kernel cycle, and then remove the entire option in the next kernel
release.
This is just to make it easier to revert back if for some reasons problems
arise with the rt30xx support.
The overall goal is to get rid of all these of the RT2800PCI_yyy and RT2800USB_zzz
symbols, but that can only happen if the devices denoted by these symbols
are properly supported.

John, I leave it up to you, but for me my original patch should be merged, and
I'll send an equivalent patch for Stefan's one for the next kernel release.

---
Gertjan.
