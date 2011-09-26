Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2245 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1IZTSE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 15:18:04 -0400
Message-ID: <4E80CFE1.506@broadcom.com> (sfid-20110926_211808_358950_D4315725)
Date: Mon, 26 Sep 2011 12:17:53 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Arend van Spriel" <arend@broadcom.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/20] staging: brcm80211: use endian annotated
 structures in brcmsmac
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
 <1316830148-28661-10-git-send-email-frankyl@broadcom.com> (
 sfid-20110924_040943_301385_9930B29B)
 <1316860721.3952.5.camel@jlt3.sipsolutions.net>
 <4E7DCE39.1010406@broadcom.com>
 <1317029844.4117.31.camel@jlt3.sipsolutions.net>
 <4E80C3CE.9010001@broadcom.com>
In-Reply-To: <4E80C3CE.9010001@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/26/2011 11:26 AM, Arend van Spriel wrote:
> On 09/26/2011 11:37 AM, Johannes Berg wrote:
>> On Sat, 2011-09-24 at 14:34 +0200, Arend van Spriel wrote:
>>> On 09/24/2011 12:38 PM, Johannes Berg wrote:
>>>> On Fri, 2011-09-23 at 19:08 -0700, Franky Lin wrote:
>>>>>     struct d11rxhdr {
>>>>>     	u16 RxFrameSize;
>>>>>     	u16 PAD;
>>>>> +	union {
>>>>> +		struct d11rxhdr_le rxh_le;
>>>>> +		struct d11rxhdr rxh_cpu;
>>>>> +	};
>>>> This seems a little strange. Why would it be both in LE and CPU byte
>>>> order?
>>> Indeed. When we receive it from the device it is in LE and we convert it
>>> to CPU order for further processing using rxh_cpu.
>> That seems a confusing and error-prone -- you'll have to remember
>> whether you're before or after conversion. Would it be possible to have
>> two versions of the outer structure and change the pointer type at that
>> point?
>>
>> johannes
>
> For me knowing the driver design (a little ;-) it is not difficult to
> remember. Your feedback has valid arguments so I will reconsider. Franky
> is looking whether dropping it will affect the other patches submitted
> to Greg.
>
> Gr. AvS

Dropping this one will affect some following patches in the series. 
Since it's not a bug, shall we keep this one and change it as Johannes 
suggested in future commit?

Franky

