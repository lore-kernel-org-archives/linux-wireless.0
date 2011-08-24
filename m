Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:48492 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1HXXJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 19:09:34 -0400
In-Reply-To: <20110824222801.GA5280@broadcom.com>
References: <20110707002034.GA17885@broadcom.com> <20110824222801.GA5280@broadcom.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <C7234C0A-9839-4150-8B25-F6A6771377A1@iki.fi> (sfid-20110825_010937_265889_8324462C)
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Date: Thu, 25 Aug 2011 02:10:31 +0300
To: Henry Ptasinski <henryp@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 25.8.2011, at 1.28, Henry Ptasinski wrote:
> The brcmsmac driver has been verified to work on x86 (both 32- and  
> 64-bit), PPC
> (64-bit), SPARC, MIPS BE, and ARM.  The brcmfmac driver has been  
> verified to
> work on x86 32-bit and ARM (additional testing is in progress, but  
> getting a
> working sdio controller on some of the other platforms has been  
> challenging).
>
> The drivers compile cleanly for x86 (32- and 64-bit), PPC (32- and  
> 64-bit),
> SPAR, MIPS BE, MIPS LE, and ARM.

Are you sure the compilation is even enabled on all of those platforms?

E.g.:

 > +config BRCMSMAC
 > +       tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
 > +       default n
 > +       depends on PCI
 > +       depends on WLAN && MAC80211
 > +       depends on X86 || MIPS
           ^^^^^^^^^^^^^^^^^^^^^^

Why this?

A.

