Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4362 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab2FMNfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 09:35:38 -0400
Message-ID: <4FD89720.1020903@broadcom.com> (sfid-20120613_153541_920699_C7B5623B)
Date: Wed, 13 Jun 2012 15:35:28 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/5] brcmfmac: introduce checkdied debugfs
 functionality
References: <1339275105-3593-1-git-send-email-arend@broadcom.com>
 <1339275105-3593-6-git-send-email-arend@broadcom.com>
 <CA+XFjioPG4aT-umi1BD+RH0q0a3AEY=QXTAFapGhz3x25cLdSw@mail.gmail.com>
 <4FD42939.2020404@broadcom.com> <20120611184330.GC30086@tuxdriver.com>
In-Reply-To: <20120611184330.GC30086@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2012 08:43 PM, John W. Linville wrote:
> On Sun, Jun 10, 2012 at 06:57:29AM +0200, Arend van Spriel wrote:
>> On 06/10/2012 04:13 AM, Gábor Stefanik wrote:
>>> On Sat, Jun 9, 2012 at 10:51 PM, Arend van Spriel <arend@broadcom.com> wrote:
>>>> The checkdied functionality provides useful information for analyzing
>>>> firmware crashes. By exposing this information to a debugfs file users
>>>> can easily provide its content in bug reports. The functionality is
>>>> available only when CONFIG_BRCMDBG is selected.
>>>>
>>>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>>>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>>> ---

>>>> +       /* allocate buffer for console data */
>>>> +       if (console_size <= CONSOLE_BUFFER_MAX)
>>>> +               conbuf = kzalloc(console_size+1, GFP_ATOMIC);
>>>> +
>>>> +       if (!conbuf)
>>>> +               return -ENOMEM;
>>
>> Probably would be better to use vmalloc() here or at least use
>> GFP_KERNEL here.
>>
>> John, any recommendations?
> 
> vmalloc seems reasonable...
> 

Thanks, John

Can you take the first four patches? I will make a v2 for this one. Let
me know if that is ok with you.

Gr. AvS

