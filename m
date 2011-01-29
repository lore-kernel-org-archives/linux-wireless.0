Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50132 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1A2GbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jan 2011 01:31:08 -0500
Received: by qyj19 with SMTP id 19so1650316qyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 22:31:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D438320.1000800@lockie.ca>
References: <4D41DAF1.6080204@lockie.ca>
	<4D41ED24.9010005@hauke-m.de>
	<4D41FDF7.3040805@lockie.ca>
	<AANLkTi=4rvKYSDiHNoM0YHMAd=nSmi=DELOp+9nxCwAM@mail.gmail.com>
	<4D438320.1000800@lockie.ca>
Date: Sat, 29 Jan 2011 01:31:06 -0500
Message-ID: <AANLkTimWKr_Dwxe0dSAnL6O1Z7GnxChZk6k1aoThdAWV@mail.gmail.com>
Subject: Re: did compat-wireless-2011-01-27 crash dhcpcd?
From: Brian Prodoehl <bprodoehl@gmail.com>
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 28, 2011 at 10:01 PM, James <bjlockie@lockie.ca> wrote:
> On 01/28/11 11:12, Brian Prodoehl wrote:
>> On Thu, Jan 27, 2011 at 6:21 PM, James <bjlockie@lockie.ca> wrote:
>>> On 01/27/11 17:09, Hauke Mehrtens wrote:
>>>> On 01/27/2011 09:52 PM, James wrote:
>>>>> cfg80211: Calling CRDA to update world regulatory domain
>>>>> Compat-wireless backport release: compat-wireless-2011-01-06-3-g8db1608
>>>>> Backport based on linux-next.git next-20110121
>>>>> ath9k 0000:02:09.0: PCI INT A -> Link[LNKB] -> GSI 17 (level, low) -> IRQ 17
>>>>> ath: EEPROM regdomain: 0x10
>>>>> ath: EEPROM indicates we should expect a direct regpair map
>>>>> ath: Country alpha2 being used: CO
>>>>> ath: Regpair used: 0x10
>>>>> ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
>>>>> cfg80211: wext will not work because kernel was compiled with
>>>>> CONFIG_WIRELESS_EXT=n. Tools using wext interface, like iwconfig will
>>>>> not work.
>>>> WEXT is deactivated in compat-wireless because CONFIG_WIRELESS_EXT=y was
>>>> not set in your kernel config and iwconfig does not work without wext.
>>>>
>>>> See: http://www.spinics.net/lists/linux-wireless/msg63449.html
>>>>
>>>> Hauke
>>>> --
>>> I'm not using any tools.
>>> The call trace happens after I do a modprobe.
>>> I'm guessing it doesn't like dhcpcd.
>>>
>>> Do I really need CONFIG_WIRELESS_EXT?
>> This still doesn't feel like the entire story.  Do you have
>> NetworkManager running, by chance?
>>
>> -Brian
>>
> No Network Manager, I use Gentoo.
> dhcpcd is running
> I disabled wpa_suppliucant from auto starting.
>
> Any ideas of what other processes to check for?

I dug through the source of dhcpcd a bit, and it uses wext to fetch
the SSID.  So, maybe that does explain it.  I guess the real fix is
for dhcpcd to get updated to use nl80211.
