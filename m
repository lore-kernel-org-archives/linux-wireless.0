Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:36187 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030198AbbEVUVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 16:21:52 -0400
Received: by obbea2 with SMTP id ea2so20875884obb.3
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2015 13:21:52 -0700 (PDT)
Message-ID: <555F8FDC.3040609@lwfinger.net> (sfid-20150522_222156_210921_EF51DE78)
Date: Fri, 22 May 2015 15:21:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Fix EFUSE_ANA8M map value
References: <20150521214421.15983b0a@milhouse> <555E5433.7000904@lwfinger.net> <20150522070035.711c6195@wiggum>
In-Reply-To: <20150522070035.711c6195@wiggum>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2015 12:00 AM, Michael Büsch wrote:
> On Thu, 21 May 2015 16:54:59 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>
>> I think the patch is correct. Certainly loading an array entry with the offset
>> of the array makes little sense. This change makes the older drivers
>> (rtl8192c{e,u} and rtl8192se match the newer ones.
>>
>> Once I test the patch, I will send it on to Kalle with my S-o-b.
>
>
> Thanks. I did this, because I have an rtl8192cu device that does not work (even with this patch).
> It doesn't return any scan results. I'll have to debug this further. Any suggestions?

What does lsusb say about your device?

The latest Realtek driver that I have can be gotten from 
http://github.com/lwfinger/rtl8192cu.git. That one works pretty well with device 
7392:7811, which is an Edimax EW-7811Un, but does not work with device 
2357:0100, which is a TP-Link WN8200ND.

The GitHub repo needs a bit of work as it tends to spam the logs a lot, but it 
might work for your device.

Larry

