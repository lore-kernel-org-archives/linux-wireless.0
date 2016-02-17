Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:34444 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965022AbcBQVms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 16:42:48 -0500
Received: by mail-ob0-f169.google.com with SMTP id wb13so36527214obb.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2016 13:42:48 -0800 (PST)
Subject: Re: Wrong wireless nick card name loaded on reboot
To: German <gentgerman@gmail.com>
References: <20160217060909.694a9aff@libertarian.asterius.net>
 <56C499E0.3070909@lwfinger.net>
 <20160217115746.6e2edbcf@libertarian.asterius.net>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56C4E955.8080008@lwfinger.net> (sfid-20160217_224253_102610_BB9FBA97)
Date: Wed, 17 Feb 2016 15:42:45 -0600
MIME-Version: 1.0
In-Reply-To: <20160217115746.6e2edbcf@libertarian.asterius.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2016 10:57 AM, German wrote:
> On Wed, 17 Feb 2016 10:03:44 -0600
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> On 02/17/2016 05:09 AM, German wrote:
>>> Hi list,
>>>
>>> A couple of days ago I asked why my pc changes the wireless card
>>> name. It switches between AR9285 ( right) and AR5008 ( wrong).
>>> Someone suggested  that this is because another kernel module is
>>> loaded by mistake. Well, it is not the case. When system identified
>>> with AR9285, it loads ath9k and I can connect to the router. When
>>> system identifies my card as AR5008, no kernel module is present at
>>> all ( lspci -k). The wrong card name occurs only when system
>>> rebooted. If I gracefully shut down the system, it always comes up
>>> with a right name for the card ( AR9285). So, how to force the
>>> system identify my card right no matter if I reboot or shut down?
>>> Thank you.
>>
>> I would like to help you, but I do not remember your earlier message.
>> Why did you not reply to the earlier one so that everything would be
>> in the same thread? That would have made searching the archives
>> easier. As a result, I may be duplicating some previous information.
>>
>> The selection of a driver for a given device comes from the PCI ID.
>> If your system is showing the wrong device, then you may have
>> hardware problems such that the PCI ID is reported incorrectly. To
>> test this, please provide the output of the command
>>
>> lspci -nn | grep Network
>>
>> for the "good" and "bad" case.
>>
>> Larry
>>
>>
>
> Larry, here is the "bad" case:
>
> lspci -nn | grep Network
> 01:00.0 Ethernet controller [0200]: Qualcomm Atheros AR5008 Wireless Network Adapter [168c:ff1c] (rev 01)
>

The kernel scans the various PCI buses to gather the ID information from the 
various cards. Sometimes your device returns [168c:ff1c] and other times it 
returns [168c:002b]. The lable, i.e. the stuff from "Qualcomm" to "Adapter" does 
not come from the card. That info is in a file on your computer, and is based on 
the PCI ID read from the card.

There is some kind of hardware problem causing two different IDs to be read. 
Assuming that everything else is working correctly, it is likely the wifi card 
at fault. If you can get to the card on your machine, I suggest reseating it in 
its socket just in case it is a contact problem. Otherwise, I have no suggestions.

Larry


I'm not

