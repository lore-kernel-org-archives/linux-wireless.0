Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35453 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab2EMEbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2012 00:31:32 -0400
Date: Sun, 13 May 2012 07:31:21 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Gustavo Padovan <gustavo@padovan.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: bluetooth 2012-05-04
Message-ID: <20120513043121.GA22845@x220.P-661HNU-F1> (sfid-20120513_063241_198416_D5186A29)
References: <20120505001243.GC23728@joana>
 <20120508070211.GB11843@joana>
 <20120511201620.GD7620@joana>
 <20120512182227.GA30574@tuxdriver.com>
 <20120512190900.GA15956@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120512190900.GA15956@joana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, May 12, 2012, Gustavo Padovan wrote:
> In my point of view there are two commits there that are really necessary:
> 
> Gustavo Padovan (2):
>       Bluetooth: report the right security level in getsockopt
> 
> Johan Hedberg (2):
>       Bluetooth: mgmt: Fix device_connected sending order
> 
> They fix a userspace breakage caused by:
> 
> Author: Marcel Holtmann <marcel@holtmann.org>
> Date:   Mon Feb 20 21:24:37 2012 +0100
> 
>     Bluetooth: Always enable management interface
>     
>     The management interface API has reached stable version 1.0 and thus
>     it can now be always enabled. All future changes will be made backwards
>     compatible.
>     
>     Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
>     Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
> 
> 
> This cause no crash, but it make bluetooth keyboards stop to work with Linux.
> This a serious breakage IMO. I really would like to see at least these two
> patches in. The other fixes can wait.

I'd just like to add some further background since I don't think it's
that obvious how these are regression fixes:

The device_connected fix should be quite self-explanatory, but it's
actually a wider issue than just for keyboards. All profiles that do
incoming connection authorization (e.g. headsets) will break without it
with specific hardware. The reason it wasn't caught earlier is that it
only occurs with specific Bluetooth adapters.

As for the security level patch, this fixes L2CAP socket based security
level elevation during a connection. The HID profile needs this (for
keyboards) and it is the only way to achieve the security level
elevation when using the management interface to talk to the kernel
(hence the management enabling patch being the one that exposes this
issue).

Johan
