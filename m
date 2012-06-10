Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49730 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab2FJNKa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 09:10:30 -0400
Message-ID: <4FD49CC1.6030704@hauke-m.de> (sfid-20120610_151055_442504_96D321BE)
Date: Sun, 10 Jun 2012 15:10:25 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 14/18] brcmsmac: extend xmtfifo_sz array
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-15-git-send-email-hauke@hauke-m.de> <4FCF2FD4.6010103@broadcom.com> <4FD0AD96.1050500@hauke-m.de> <4FD0FF3D.2060805@broadcom.com>
In-Reply-To: <4FD0FF3D.2060805@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2012 09:21 PM, Arend van Spriel wrote:
> On 06/07/2012 03:33 PM, Hauke Mehrtens wrote:
>> On 06/06/2012 12:24 PM, Arend van Spriel wrote:
>>> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>>>> The xmtfifo_sz array contains the queue sizes for the different chip
>>>> revs. This array missed the sizes for the core rev 17 and 28. This
>>>
>>> Should probably use core revs instead of chip revs and I think we are
>>> talking about the 80211 core rev here.
>> Yes I will change this comment.
>>
>> Are there any devices with the same phy type using different fifo sizes?
>> If this is not the case I think it is better to do this based on the phy
>> type.
> 
> I dived into this and basically there is no correlation to the phy type.
> There are chips with same 80211 core rev and different phy type as there
> are chips with different 80211 core rev and the same phy type.
> 
> Gr. AvS

Hi Arend,

Ok, then I will leave it based on the core rev like it is now. Are the
values I added there for core rev 17 and 28 correct? They are just
copied from the other phy-n device which has the same values set after
powering up and before they are explicitly set. The core rev 17 device
is working for me, but the core rev 28 is not, but I do not know why. I
was unable to find these values in b43 or the spec b43 is based on.

Hauke
