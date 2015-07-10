Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:38544 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbbGJKR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 06:17:27 -0400
Received: by igrv9 with SMTP id v9so9616653igr.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2015 03:17:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <559F7E1F.7070407@atmel.com>
References: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com>
 <1436507759-4546-3-git-send-email-johnny.kim@atmel.com> <CAGRGNgVwVKq2JQ5FypdAZvLUoYPEL+MQ=yPsMJo3onOfWin7vQ@mail.gmail.com>
 <559F7E1F.7070407@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 10 Jul 2015 20:17:07 +1000
Message-ID: <CAGRGNgUcrdMg6MGEJxzt7+LLQV2GC-fLbyLkKdE1p4oj3wsXyg@mail.gmail.com> (sfid-20150710_121730_625767_0CEF815D)
Subject: Re: [PATCH 2/3] staging: wilc1000: wilc_wlan_cfg_get(): replace
 integer with void pointer
To: Johnny Kim <johnny.kim@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Chris Park <chris.park@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>, tony.cho@atmel.com,
	Nicolas.FERRE@atmel.com, Dean Lee <dean.lee@atmel.com>,
	austin.shin@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johnny,

On Fri, Jul 10, 2015 at 6:11 PM, Johnny Kim <johnny.kim@atmel.com> wrote:
>
> On 2015년 07월 10일 15:25, Julian Calaby wrote:
>>
>> Hi Johnny,
>>
>> On Fri, Jul 10, 2015 at 3:55 PM, Johnny Kim <johnny.kim@atmel.com> wrote:
>>>
>>> Last argument of wilc_wlan_cfg_get function is actually structure's
>>> address.
>>> This should be changed to be compatible with 64bit machine.
>>> Because wilc_wlan_cfg_get function is mapped by function pointer later,
>>> wilc_wlan_oup_t.wlan_cfg_get should be changed together.
>>>
>>> tstrWILC_WFIDrv structure is defined after wilc_wlan_oup_t.wlan_cfg_get
>>> is defined. So, this patch changes the argument to void type pointer.
>>
>> Why not add a patch moving the structure definition before
>> wilc_wlan_oup_t.wlan_cfg_get is defined?
>
> Current patch focus on accessing 64bit address rightly.
> The define order you and I mentioned should be repaired with another subject
> because of complexity among files.

I'm not saying it should be part of this patch, I'm saying that it
should be a patch in this series. Some of the changes you're making
look like you're fixing one bug only to replace it with another
different one.

But back to the whole issue of order:

tstrWILC_WFIDrv is defined in host_interface.h

wlan_cfg_get is defined in wilc_wlan_if.h

A patch ensuring that host_interface.h is included before
wilc_wlan_if.h in all files should be pretty easy to produce, assuming
that host_interface.h doesn't use anything in wilc_wlan_if.h.

If you include this patch, you can avoid patches later to change the
void pointers to typed pointers.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
