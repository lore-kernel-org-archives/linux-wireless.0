Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58072 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1HLUCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 16:02:43 -0400
Received: by gxk21 with SMTP id 21so2203042gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 13:02:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E4556E4.3000301@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
	<1313156101-16817-3-git-send-email-arend@broadcom.com>
	<CACna6rwTHx7Fb5Gj4b3XOAzmz3_pqYf4u25naj33qD8FEG8tjQ@mail.gmail.com>
	<4E4556E4.3000301@broadcom.com>
Date: Fri, 12 Aug 2011 22:02:41 +0200
Message-ID: <CACna6rx75yeCWWvThno9jY3hG-HqDSD0U52kLzXqXLyrcSGSxw@mail.gmail.com> (sfid-20110812_220251_921568_30775866)
Subject: Re: [PATCH 02/14] staging: brcm80211: remove iovar IOV_BLOCKSIZE in brcmfmac
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 12 sierpnia 2011 18:37 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On 08/12/2011 04:12 PM, Rafał Miłecki wrote:
>>
>> 2011/8/12 Arend van Spriel<arend@broadcom.com>:
>>>
>>> @@ -273,7 +270,6 @@ extern int brcmf_sdioh_interrupt_deregister(struct
>>> sdioh_info *sd)
>>>  /* IOVar table */
>>>  enum {
>>>        IOV_MSGLEVEL = 1,
>>> -       IOV_BLOCKSIZE,
>>>        IOV_NUMINTS,
>>>        IOV_DEVREG,
>>>        IOV_HCIREGS,
>>
>> You are forcing IOV_MSGLEVEL to 1, so I expected values of IOV_* are
>> really important in some piece of code. Now you change them. AFAIU it
>> means you break something, or you can drop " = 1".
>
> IOCTL codes do have a strong ordering as user-space application and driver
> need to have the same code for the same entity. IOVs are internal numbers
> for the driver only so there is no issue in renumbering those.

Then you can note dropping " = 1" to avoid confusion for
new-code-readers :) For your TODO.

-- 
Rafał
