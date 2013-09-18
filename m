Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45891 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab3IRN5L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 09:57:11 -0400
Message-ID: <5239B12D.3040206@hauke-m.de> (sfid-20130918_155715_034547_42FD4E4B)
Date: Wed, 18 Sep 2013 15:57:01 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Joe Perches <joe@perches.com>, brcm80211-dev-list@broadcom.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: fyi: scheduling while atomic dmesg output 3.12-rc1
References: <1379439942.2012.16.camel@joe-AO722> <52397023.2080000@broadcom.com>
In-Reply-To: <52397023.2080000@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/18/2013 11:19 AM, Arend van Spriel wrote:
> On 09/17/2013 07:45 PM, Joe Perches wrote:
>> <3>[   11.206312] BUG: scheduling while atomic:
>> NetworkManager/866/0x00000200
> 
> Thanks, Joe
> 
> I got a report on this few days ago. It was introduced by bcma API
> change and I already sent email to the committer of that change, ie.
> Hauke Mehrtens. Hope it will be settled soon how to fix this.
> 
> Gr. AvS

Hi,

I see four solutions for the problem:

1. convert the usleep_range(1000, 2000) into udelay(1000) in
drivers/bcma/driver_pci.c

2. remove the call of bcma_core_pci_power_save() from bcma_core_pci_up()
so that it does not get called by brcmsmac.

3. remove the call of bcma_core_pci_power_save() from bcma_core_pci_up()
and move the call to somewhere out of the big spin lock.

4. convert the big brmcsmac spin lock into a mutex lock and use an
additional spin lock for the parts where it is actually needed.

For 3.12 I am for solution 1 or 2 and for the long term 3.13? I am for
solution 4, but that needs bigger changes.

Hauke
