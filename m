Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:32192 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3LRLB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 06:01:27 -0500
Message-ID: <52B18080.7070709@broadcom.com> (sfid-20131218_120145_824761_BE883E8C)
Date: Wed, 18 Dec 2013 12:01:20 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Ujjal Roy <royujjal@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Kernel <linux-wireless@vger.kernel.org>
Subject: Re: P2P_DEVICE support in driver
References: <CAE2MWkn5KT7nM+RgPptbfUDVEz5KThytpNmMUzhQeP30ZSocEg@mail.gmail.com>
In-Reply-To: <CAE2MWkn5KT7nM+RgPptbfUDVEz5KThytpNmMUzhQeP30ZSocEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/18/2013 11:29 AM, Ujjal Roy wrote:
> Hi Johannes,
> 
> I want to add P2P_DEVICE support in a driver. And it's not described
> in the P2P spec. So, please tell me the following points -
> 1> what do the driver do?
> 2> register_netdevice() should not be called from driver for the
> P2P_DEVICE interface. Then what are the procedures (network stacks) to
> add a P2P device from driver's point of view?
> 3> How the supplicant will communicate with this type of interface?
> 

Hi Ujjal,

P2P_DEVICE interface is meant for the P2P discovery phase, which is in
the P2P spec. It is also depending on the driver/firmware whether it
needs this to distinguish between a regular scan and P2P scan. Some
vendors who did have that need created a 'dummy' netdev for that purpose
although it is only used for scanning/listening, ie. no network traffic.
To avoid that waste the P2P_DEVICE interface was cooked up. The
P2P_DEVICE interface is created through nl80211 by recent wpa_supplicant
when driver indicates support.

Regards,
Arend
