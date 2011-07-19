Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49821 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1GSRpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 13:45:24 -0400
Received: by ywe9 with SMTP id 9so1887958ywe.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 10:45:23 -0700 (PDT)
Message-ID: <4E25C2B1.2090804@lwfinger.net> (sfid-20110719_194527_917473_8FE95BC8)
Date: Tue, 19 Jul 2011 12:45:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stefan Assmann <sassmann@redhat.com>
CC: ali@internetdog.org, wireless <linux-wireless@vger.kernel.org>
Subject: Re: r8712u issue
References: <4E23E56C.9000202@redhat.com> <20110718082709.GA8390@internetdog.org> <4E23F2E0.3050200@redhat.com> <4E2448D2.50502@lwfinger.net> <4E244AC6.2030306@redhat.com> <4E2454EC.1050900@lwfinger.net> <4E25858D.9010407@redhat.com> <4E25AB9F.8010607@lwfinger.net> <20110719161656.GA7099@internetdog.org> <4E25BBF4.1010003@redhat.com> <20110719173203.GA7406@internetdog.org> <4E25C12F.3080804@redhat.com>
In-Reply-To: <4E25C12F.3080804@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2011 12:38 PM, Stefan Assmann wrote:
> On 19.07.2011 19:32, Ali Bahar wrote:
>> On Tue, Jul 19, 2011 at 07:16:36PM +0200, Stefan Assmann wrote:
>>> On 19.07.2011 18:16, Ali Bahar wrote:
>>>> On Tue, Jul 19, 2011 at 11:06:55AM -0500, Larry Finger wrote:
>>>>> On 07/19/2011 08:24 AM, Stefan Assmann wrote:
>>>>>>
>>>>>> So far I can say that with scan_ssid=1 after rebooting the AP the
>>>>>> connection is properly re-established. Looks promising.
>>>>>
>>>>> Your results make sense. The driver is fairly passive in all this.
>>>>> It gets TX requests from the MAC layer, and passes received data
>>>>> back up to that layer. It seems likely that the MAC layer built into
>>>>> r8712u is not keeping track of missing responses, or it is not
>>>>> probing the AP. In either case, it would not be productive to devote
>>>>> any effort to fixing that part when either using NetworkManager or
>>>>> setting scan_ssid for wpa_supplicant establishes periodic scans.
>>>>> When these fail to get response from the AP, the softmac code will
>>>>> respond, as you see.
>>>>>
>>>>> The ultimate fix will be to convert to the driver to use mac80211,
>>>>
>>>> Just what I've been thinking lately. I didn't think it very worthwhile
>>>> to invest too much into fixing the miscellany.
>>>
>>> Agreed! Maybe we could add a note to the documentation to make the
>>> behaviour more obvious.
>>
>> There's documentation?! ;-|
>>
>> ... The following could be an option:
>> http://linuxwireless.org/en/users/Drivers/rtl819x
>
> Good idea!
>
>>
>> Larry's the author, and so it's _his_ call. _I_ am just tackling
>> whatever problems I run into; at the moment, that happens to be the
>> r8712u driver.
>
> Right, my statement wasn't directed strictly to you, I was just
> thinking of how to improve the situation. :)

The wpa_supplicant documentation is what should be changed to note that 
scan_ssid is useful for more than hidden ESSIDs. On the other hand, EVERY 
wireless example in 'man wpa_supplicant.conf' shows "scan_ssid=1".

Larry
