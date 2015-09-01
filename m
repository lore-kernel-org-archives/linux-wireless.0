Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34744 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbbIAFRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 01:17:32 -0400
Received: by oiex83 with SMTP id x83so77553570oie.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 22:17:32 -0700 (PDT)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
To: Jes Sorensen <Jes.Sorensen@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
 <55E289A3.6030001@lwfinger.net> <wrfjegik8vqy.fsf@redhat.com>
 <55E39707.60101@lwfinger.net> <wrfjy4gs5ggd.fsf@redhat.com>
 <55E476A0.4080601@lwfinger.net> <wrfjio7v3txe.fsf@redhat.com>
 <55E4EE6F.2010008@lwfinger.net> <wrfjwpwa3fkc.fsf@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	johannes@sipsolutions.net
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55E534EA.9090605@lwfinger.net> (sfid-20150901_071738_250339_A40B518B)
Date: Tue, 1 Sep 2015 00:17:30 -0500
MIME-Version: 1.0
In-Reply-To: <wrfjwpwa3fkc.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2015 11:54 PM, Jes Sorensen wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>> On 08/31/2015 06:43 PM, Jes Sorensen wrote:
>>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>>> On 08/30/2015 09:39 PM, Jes Sorensen wrote:
>>>>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>>>>> On 08/30/2015 01:41 PM, Jes Sorensen wrote:
>>>>>>>>> +{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x817e, 0xff,
>>>>>>>> 0xff, 0xff),
>>>>>>>>> +	.driver_info = (unsigned long)&rtl8192cu_fops},
>>>>>>>>
>>>>>>>> I have tested a device with USB ID 0x0bda (USB_VENDOR_ID_REALTEK):0x817e.
>>>>>>>
>>>>>>> Were you happy with the results, or did it cause problems? Ie. did you
>>>>>>> try on x86 or on PPC32?
>>>>>>
>>>>>> As covered in the other mail, it works very well at G rates.
>>>>>
>>>>> I see - I am a little confused, it works well on G rates but not on N
>>>>> rates, or was this due to the AP used?
>>>>
>>>> The AP is AC1200. It supports full N rates on other devices.
>>>
>>> You only manage to make it work on G rates against this AP? Urgh, I
>>> don't like that at all.
>>>
>>> I thought you reported 30+Mbps performances though?, thats more than you
>>> get on G.
>>
>> OK, I get a bit better than the top G rate of 27 Mbps, but the
>> connection reports a 54 Mbps raw rate. My Intel 7260 gets RX of 95 and
>> TX of 53 Mbps from the same location relative to the AP. For the
>> Intel, the listed raw rate is 300 Mbps.
>
> It's possible the connection reporting I am doing is wrong. I haven't
> figured out how to report the actual transmission speed, which is what
> the mac80211 stack wants. Some of the other drivers fake it or repor RX
> speeds, but that isn't what one is meant to report.
>
>>>> A full debug=0x3fff showed me one problem on the PPC. I will be
>>>> testing a patch later today.
>>>
>>> Interesting, let me know what you find.
>>
>> Thanks for the fixes. I'm still getting the sleeping while atomic BUG
>> splat from rtl8723a_h2c_cmd+0x48. Today I know that is not a lock
>> dependency issue. I have one in VirtualBox that fires and disables
>> further checking, but that driver is not loading now.
>
> This is bothersome, I'll have to dig futher into this.
>
>> I have made some progress on the big-endian issues. When the firmware
>> file is read from disk, the first byte read must be the first byte
>> written to the device. In the slow write N routine, four bytes are
>> picked and written using the write32 routine, which does a cpu_to_32()
>> byte swap. As a result, the order of bytes to the device is 03, 02,
>> 01, 00! Rather than byte swap twice, I am calling the regular writeN
>> routine with each hunk. After a bit of thinking about the best
>> blocksize to use, I settled on 64. That reduces the number of
>> full-size hunks that are written without unduly increasing the
>> worst-case number of writes needed for the remainder.
>>
>> On PPC, I now get a device registered; however, the scan data are
>> garbled. That shouldn't be too difficult to debug, but just in case, I
>> have attached the patch for rtl8xxxu_slow_writeN().
>
> As I mentioned in a direct email - calling writeN from slow_writeN is
> not a solution. I found some devices fail if you try to use the fast
> writeN routine. Maybe rtl8xxxu_raw_write32() - without the byteswap
> would be a better approach, or simply putting the relevant code into the
> slow_writeN function.
>
> I am flying back to New York tomorrow, and I'll have some time on the
> plane, so I'll try to have a look at that.

I also found that trying to write all N bytes at once failed, but writing 64 at 
a time is OK. I will add the USB calls to slow_writeN.

Larry


