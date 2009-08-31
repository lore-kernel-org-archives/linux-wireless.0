Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55719 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZHaTXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 15:23:48 -0400
Received: by bwz19 with SMTP id 19so2998337bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 12:23:49 -0700 (PDT)
Message-ID: <4A9C2340.7060604@lwfinger.net>
Date: Mon, 31 Aug 2009 14:23:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	=?ISO-8859-1?Q?G=E1bor_?= =?ISO-8859-1?Q?Stefanik?=
	<netrolller.3d@gmail.com>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] b43: LP-PHY: Begin implementing calibration & software
 RFKILL support
References: <4A99C4BB.7080806@gmail.com> <200908301755.40557.mb@bu3sch.de> <20090831175331.GB5631@tuxdriver.com> <200908312117.26915.mb@bu3sch.de>
In-Reply-To: <200908312117.26915.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Monday 31 August 2009 19:53:31 John W. Linville wrote:
>> On Sun, Aug 30, 2009 at 05:55:40PM +0200, Michael Buesch wrote:
>>> On Sunday 30 August 2009 17:10:23 Larry Finger wrote:
>>>> Michael Buesch wrote:
>>>>> On Sunday 30 August 2009 02:15:55 Gábor Stefanik wrote:
>>>>>>  static void lpphy_pr41573_workaround(struct b43_wldev *dev)
>>>>>>  {
>>>>>>  	struct b43_phy_lp *lpphy = dev->phy.lp;
>>>>>> @@ -1357,28 +1488,440 @@ static void lpphy_pr41573_workaround(struct b43_wldev *dev)
>>>>>>  		b43_lptab_read_bulk(dev, B43_LPTAB32(7, 0x140),
>>>>>>  				    saved_tab_size, saved_tab);
>>>>>>  	}
>>>>>> +	b43_put_phy_into_reset(dev);
>>>>> Are you sure you really want this?
>>>>> This function completely disables the PHY on the backplane and keeps the physical
>>>>> PHY reset pin asserted (even after return from the function).
>>>>> So the PHY will physically be powered down from this point on. The following
>>>>> PHY accesses could even hang the machine, because the PHY won't respond to
>>>>> register accesses anymore.
>>>>>
>>>>> We currently only use this function on A/G Multi-PHY devices to permanently
>>>>> hard-disable the PHY that's not used.
>>>> The PHY reset routine in
>>>> http://bcm-v4.sipsolutions.net/802.11/PHY/Reset, which I just updated
>>>> for the latest N PHY changes, appears to be a different routine than
>>>> b43_put_phy_into_reset(). The names are confusing.
>>> b43_put_phy_into_reset() is opencoded in the specifications in various init
>>> routines. There's no separate specs page for that function.
>>> But I think the code is straightforward and easy to understand.
>> So is this patch right or not?  Should I hold onto it for 2.6.33
>> (i.e. after the 2.6.32 merge window)?
> 
> I'm pretty sure it's incorrect.

I agree.

Larry
