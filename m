Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:36938 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751577AbeBDSSj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Feb 2018 13:18:39 -0500
Received: by mail-ot0-f194.google.com with SMTP id e64so5117159ote.4
        for <linux-wireless@vger.kernel.org>; Sun, 04 Feb 2018 10:18:39 -0800 (PST)
Subject: Re: rtl8821ae keep alive not set, connection lost
To: Pkshih <pkshih@realtek.com>, "quozl@laptop.org" <quozl@laptop.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20170912220916.GB32211@us.netrek.org>
 <a9a1ff03-d12f-7437-e7bc-5f01b195f753@lwfinger.net>
 <20180201062202.GH917@us.netrek.org>
 <5B2DA6FDDF928F4E855344EE0A5C39D13BE7A25E@RTITMBSV07.realtek.com.tw>
 <33774f69-6fb2-6cbf-615d-9e2a836dd5de@lwfinger.net>
 <1517633110.2437.14.camel@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <6465ff7f-1656-76be-1dae-5425019c848c@lwfinger.net> (sfid-20180204_191845_405280_A67385CD)
Date: Sun, 4 Feb 2018 12:18:36 -0600
MIME-Version: 1.0
In-Reply-To: <1517633110.2437.14.camel@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/2018 10:45 PM, Pkshih wrote:
> On Fri, 2018-02-02 at 14:13 -0600, Larry Finger wrote:
>> On 02/02/2018 01:50 AM, Pkshih wrote:
>>> Hi James,
>>>   
>>> In my experiment, unaligned-word-access may get wrong values that
>>> are different from the value by byte-access. Actually, it can simply
>>> verified by using 'lspci' to check PCI configuration space.
>>>   
>>> DBI read 0x70f:
>>> _rtl8821ae_dbi_read:1127 r8 0x34f = 0x0017
>>> _rtl8821ae_dbi_read:1131 r8 0x350 = 0x000c
>>> _rtl8821ae_dbi_read:1136 r16 0x350 = 0xffff
>>>   
>>> DBI read 0x719:
>>> _rtl8821ae_dbi_read:1127 r8 0x34d = 0x0000
>>> _rtl8821ae_dbi_read:1131 r8 0x34e = 0x0002
>>> _rtl8821ae_dbi_read:1136 r16 0x34e = 0x0200
>>>   
>>>   
>>> According to the wrong and original value of 0x70f is 0xff, I think
>>> larger L1 latency 0x70f[5:3] may be helpful. Please help to try
>>> below patch. If it works, quirk table won't be necessary.
>>>   
>>> PK
>>>   
>>>   
>>> diff --git a/rtl8821ae/hw.c b/rtl8821ae/hw.c
>>> index 7d43ba002..e53af06ed 100644
>>> --- a/rtl8821ae/hw.c
>>> +++ b/rtl8821ae/hw.c
>>> @@ -1123,7 +1123,8 @@ static u8 _rtl8821ae_dbi_read(struct rtl_priv *rtlpriv, u16 addr)
>>>     	}
>>>     	if (0 == tmp) {
>>>     		read_addr = REG_DBI_RDATA + addr % 4;
>>> -		ret = rtl_read_word(rtlpriv, read_addr);
>>> +
>>> +		ret = rtl_read_byte(rtlpriv, read_addr);
>>>     	}
>>>     	return ret;
>>>     }
>>> @@ -1165,7 +1166,7 @@ static void _rtl8821ae_enable_aspm_back_door(struct ieee80211_hw *hw)
>>>     	}
>>>     
>>>     	tmp = _rtl8821ae_dbi_read(rtlpriv, 0x70f);
>>> -	_rtl8821ae_dbi_write(rtlpriv, 0x70f, tmp | BIT(7));
>>> +	_rtl8821ae_dbi_write(rtlpriv, 0x70f, tmp | BIT(7) | 0x38);
>>>     
>>>     	tmp = _rtl8821ae_dbi_read(rtlpriv, 0x719);
>>>     	_rtl8821ae_dbi_write(rtlpriv, 0x719, tmp | BIT(3) | BIT(4));
>>>   
>>
>>
>> PK,
>>
>> This patch works perfectly on my x86_64 system. With it, the interface handled a
>> 10 million count flood ping with <1000 packets dropped. It has now been running
>> for at least 11 hours. Good work.
>>
>> Can you explain that magic 0x38? I'm quite sure that Kalle will not accept the
>> patch as is. He already thinks that rtlwifi and friends already have too many
>> magic numbers.
>>
> The magic 0x38 represents L1 latency 0x70f[5:3]=b'111, and I will add definition
> or macro to describe
> 0x70f and move all ASPM code into pci.c, if the problem was
> solved. Hence, rtl8723de and rtl8723be
> will use the same values, too.
> 
> Could you also help to test L1 latency as recommended value b'100?
> (i.e. 0x20 instead)

I have run several tests with the following results:

b'010		Failed very quickly
b'100		Did not fail, but the ping test had errors
b'110		No failure and no errors

My tests seem to indicate that we should use at least 0x30 in the field, and 
perhaps we should stay at b'111 or 0x38.

To fix the current alignment errors for ARM architecture, I will push a patch 
for mainline and stable that fixes rtl8821ae. Then you can do the patch that 
moves all ASPM code into pci.c.

Larry
