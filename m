Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52230 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab2CELox convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 06:44:53 -0500
Received: by iagz16 with SMTP id z16so5421279iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2012 03:44:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F5487DA.2010805@broadcom.com>
References: <1330725351-3803-1-git-send-email-arend@broadcom.com>
 <1330725351-3803-5-git-send-email-arend@broadcom.com> <CAGRGNgXbkV-OkB5XG8+HqmmxG6f3RfgAkfnb_XxhXYU5+yN6Ug@mail.gmail.com>
 <4F5487DA.2010805@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 5 Mar 2012 22:44:32 +1100
Message-ID: <CAGRGNgW4ZqK62LRGJhppDvnaOJLJT1JKiJOK10O5MOc9UhAJXQ@mail.gmail.com> (sfid-20120305_124458_200393_B5E75C71)
Subject: Re: [PATCH 4/7] brcm80211: fmac: initialize host interface drivers
 regardless result
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Mon, Mar 5, 2012 at 20:31, Arend van Spriel <arend@broadcom.com> wrote:
> On 03/04/2012 11:49 PM, Julian Calaby wrote:
>>
>> Hi Arend,
>>
>> On Sat, Mar 3, 2012 at 08:55, Arend van Spriel<arend@broadcom.com>  wrote:
>>>
>>> The module init function of brcmfmac calls init functions for SDIO and
>>> USB doing driver registration. This patch removes terminating the module
>>> init when a driver registration for one host interface fails.
>>
>>
>> Would it be better to fail the module load if *none* of them succeed -
>> there's probably no point in having the module loaded if it's not
>> actually hooked up to anything.
>>
>
> Thanks, Julian
>
> However, the next patch in this series would undo the init code behaviour
> you are proposing. The brcmf_sdio_init() already logs the failed driver
> registration. I will add the same to brcmf_usb_init() in a separate patch.
> Is that ok with you?

I only skimmed the patch set and this is one of the bits that stuck
out, I didn't really read what happened in the next patch.

I didn't really care about the actual logging of failure - my point
was more that if both fail then the module's still loaded, rather than
failing and unloading - however, with the firmware loading being moved
out of the module init path, there's no way to detect this anymore, so
I suppose it doesn't matter.

And yes, logging the probe error for USB would be a good thing.

Thanks anyway,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
