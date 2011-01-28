Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59029 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab1A1QM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:12:27 -0500
Received: by qwa26 with SMTP id 26so3457269qwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 Jan 2011 08:12:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D41FDF7.3040805@lockie.ca>
References: <4D41DAF1.6080204@lockie.ca>
	<4D41ED24.9010005@hauke-m.de>
	<4D41FDF7.3040805@lockie.ca>
Date: Fri, 28 Jan 2011 11:12:26 -0500
Message-ID: <AANLkTi=4rvKYSDiHNoM0YHMAd=nSmi=DELOp+9nxCwAM@mail.gmail.com>
Subject: Re: did compat-wireless-2011-01-27 crash dhcpcd?
From: Brian Prodoehl <bprodoehl@gmail.com>
To: James <bjlockie@lockie.ca>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 27, 2011 at 6:21 PM, James <bjlockie@lockie.ca> wrote:
> On 01/27/11 17:09, Hauke Mehrtens wrote:
>> On 01/27/2011 09:52 PM, James wrote:
>>> cfg80211: Calling CRDA to update world regulatory domain
>>> Compat-wireless backport release: compat-wireless-2011-01-06-3-g8db1608
>>> Backport based on linux-next.git next-20110121
>>> ath9k 0000:02:09.0: PCI INT A -> Link[LNKB] -> GSI 17 (level, low) -> IRQ 17
>>> ath: EEPROM regdomain: 0x10
>>> ath: EEPROM indicates we should expect a direct regpair map
>>> ath: Country alpha2 being used: CO
>>> ath: Regpair used: 0x10
>>> ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
>>
>>> cfg80211: wext will not work because kernel was compiled with
>>> CONFIG_WIRELESS_EXT=n. Tools using wext interface, like iwconfig will
>>> not work.
>> WEXT is deactivated in compat-wireless because CONFIG_WIRELESS_EXT=y was
>> not set in your kernel config and iwconfig does not work without wext.
>>
>> See: http://www.spinics.net/lists/linux-wireless/msg63449.html
>>
>> Hauke
>> --
>
> I'm not using any tools.
> The call trace happens after I do a modprobe.
> I'm guessing it doesn't like dhcpcd.
>
> Do I really need CONFIG_WIRELESS_EXT?

This still doesn't feel like the entire story.  Do you have
NetworkManager running, by chance?

-Brian
