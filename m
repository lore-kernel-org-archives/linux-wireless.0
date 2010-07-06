Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45806 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab0GFFPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 01:15:37 -0400
Message-ID: <4C32BBF4.9090907@candelatech.com>
Date: Mon, 05 Jul 2010 22:15:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@Atheros.com>
CC: "greearb@gmail.com" <greearb@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k] ath9k:  Expose virtual wiphy indexes to debugfs.
References: <1278359545-29013-1-git-send-email-greearb@candelatech.com> <20100706045945.GF5053@vasanth-laptop>
In-Reply-To: <20100706045945.GF5053@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/05/2010 09:59 PM, Vasanthakumar Thiagarajan wrote:
> On Tue, Jul 06, 2010 at 01:22:25AM +0530, greearb@gmail.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> It is very difficult to map phyX devices to real/virtual
>> entities because the phyX devices change on module
>> reload.  This patch makes it slightly easier to
>> associate virtual phy devices with phyX entities.
>>
>
> It does not make much sense to give an index while creating a new
> virtual wiphy interface. This is unncessary, only wiphy name
> matters.

Will the underlying code allow you to specify a phy name though?  It
seems to me that once a phyX is used, you cannot have a new phy
with that name again, even if the old one has been unloaded:

modprobe ath9k
rmmod ath9k
modprobe ath9k, and the now it's using phy1 instead of phy0,
and you cannot even rename the phy1 to phy0 with 'iw'.

It would be great if phy names were reusable like network
device names, but I'm guessing that must be difficult or
it would already be like that.

For virtual PHYs at least, the parent phy and index is a unique
identifier, so it sort of helps work around the phy naming
issues.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
