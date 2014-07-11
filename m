Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:55249 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbaGKHq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 03:46:27 -0400
Message-ID: <53BF961E.10406@broadcom.com> (sfid-20140711_094650_294782_570B07D0)
Date: Fri, 11 Jul 2014 09:45:34 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Tom Gundersen <teg@jklm.no>
CC: netdev <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	David Herrmann <dh.herrmann@gmail.com>,
	Kay Sievers <kay@vrfy.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	John Linville <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH v7 29/33] net: brcmfmac - set name assign type
References: <1404980258-30853-1-git-send-email-teg@jklm.no> <1404980258-30853-30-git-send-email-teg@jklm.no> <53BEF2A6.6050103@broadcom.com> <CAG-2HqVnUwPpRwRwNpMXVN4zP4k3zUvJX5E4p-roi6BKpHTgNQ@mail.gmail.com>
In-Reply-To: <CAG-2HqVnUwPpRwRwNpMXVN4zP4k3zUvJX5E4p-roi6BKpHTgNQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-07-14 22:24, Tom Gundersen wrote:
> On Thu, Jul 10, 2014 at 10:08 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 10-07-14 10:17, Tom Gundersen wrote:
>>> The name is given by the firmware, so we assume it is predictable.
>>
>> How about the scenario where one would have multiple broadcom wifi
>> devices in the system. Both driver instances would alloc_netdev with
>> predictable but also the same ifname. Wondering whether we should ignore
>> the firmware ifname altogether.
> 
> Hm, that would just fail irrespective of this patch, right? Sounds
> like ignoring the firmware names is the right thing to do.

True. I realized that when starting to type my reply. I think at the
moment we never run into the scenario that trigger this code path. Will
make a separate patch for that. Probably on top of your changes.

Regards,
Arend

> Cheers,
> 
> Tom
> 

