Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50011 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaLXHt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 02:49:57 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so12866320wiw.15
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 23:49:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54981C1C.2020904@broadcom.com>
References: <20120313125702.703540202@sipsolutions.net> <20120313125919.370791280@sipsolutions.net>
 <1419253089.1890.13.camel@sipsolutions.net> <549818FE.1090707@broadcom.com>
 <1419254074.1890.18.camel@sipsolutions.net> <54981C1C.2020904@broadcom.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 24 Dec 2014 09:49:40 +0200
Message-ID: <CA+XVXfdcPyGgteKxWU3k0prCfr7sVHriDyZSgTxOhPVGuRr7qw@mail.gmail.com> (sfid-20141224_085000_775613_7855CAA4)
Subject: Re: [PATCH 1/2] brmc80211: dont use jiffies for BSS TSF
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Franky Lin <frankyl@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 22, 2014 at 3:26 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 12/22/14 14:14, Johannes Berg wrote:
>>
>> On Mon, 2014-12-22 at 14:13 +0100, Arend van Spriel wrote:
>>>
>>> On 12/22/14 13:58, Johannes Berg wrote:
>>>>
>>>> By the way - I know now that the proprietary Broadcom driver has the
>>>> same bug, to the point where this is apparently getting encoded into the
>>>> Android framework.
>>>>
>>>> I urge you to fix this issue there as well. If an absolute "last
>>>> updated" timestamp is needed (and "last seen [ms] ago" isn't sufficient)
>>>> then new API will be needed.
>>>
>>>
>>> Sorry, seem to have missed the original patches somehow. Guess because
>>> it says *brmc*80211.
>>
>>
>> No no - it's a looong time ago and was also applied a long time ago. It
>> just reared it's head again in another place.
>
>
> Found the commit in git log. So you mean the proprietary DHD driver or
> Android bcmdhd still uses host timestamp. I agree it should be fixed, but I
> may need some good arguments to convince my co-workers. So what kind of
> issues are rearing their (ugly) heads? supplicant issues?

Basically the Android framework is using the TSF from the scan results
as a timestamp for when the BSS was seen. In Android LL a new CTS test
was added to verify these values.
This of course means the CTS test fails for every vendor besides BRCM :)

It seems the framework knows it's a driver bug, since in the java code
they explicitly name the variable "tsf", before assigning it to the
scan result timestamp..

Arik
