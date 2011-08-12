Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2538 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab1HLQiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 12:38:13 -0400
Message-ID: <4E4556E4.3000301@broadcom.com> (sfid-20110812_183815_864872_54F64E32)
Date: Fri, 12 Aug 2011 18:37:56 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: [PATCH 02/14] staging: brcm80211: remove iovar
 IOV_BLOCKSIZE in brcmfmac
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
 <1313156101-16817-3-git-send-email-arend@broadcom.com>
 <CACna6rwTHx7Fb5Gj4b3XOAzmz3_pqYf4u25naj33qD8FEG8tjQ@mail.gmail.com>
In-Reply-To: <CACna6rwTHx7Fb5Gj4b3XOAzmz3_pqYf4u25naj33qD8FEG8tjQ@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 04:12 PM, Rafał Miłecki wrote:
> 2011/8/12 Arend van Spriel<arend@broadcom.com>:
>> @@ -273,7 +270,6 @@ extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
>>   /* IOVar table */
>>   enum {
>>         IOV_MSGLEVEL = 1,
>> -       IOV_BLOCKSIZE,
>>         IOV_NUMINTS,
>>         IOV_DEVREG,
>>         IOV_HCIREGS,
> You are forcing IOV_MSGLEVEL to 1, so I expected values of IOV_* are
> really important in some piece of code. Now you change them. AFAIU it
> means you break something, or you can drop " = 1".

IOCTL codes do have a strong ordering as user-space application and 
driver need to have the same code for the same entity. IOVs are internal 
numbers for the driver only so there is no issue in renumbering those.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


