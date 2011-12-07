Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2828 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab1LGOBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 09:01:53 -0500
Message-ID: <4EDF71C6.9050800@broadcom.com> (sfid-20111207_150156_694395_BD3AB50E)
Date: Wed, 7 Dec 2011 15:01:42 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcma usage in isr context
References: <4ED77C85.1050705@broadcom.com>
 <CACna6rznu8d1BjG0EWjP1VRCPdYAGJv1q+fi1X+XF_Bf-Cx+Mg@mail.gmail.com>
 <4EDCE2CC.3060500@broadcom.com>
 <CACna6rwVRrm8YgvoYAmswru8nHXgytuiDRO2F2TQVZyxnfaV9w@mail.gmail.com>
In-Reply-To: <CACna6rwVRrm8YgvoYAmswru8nHXgytuiDRO2F2TQVZyxnfaV9w@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2011 01:52 PM, Rafał Miłecki wrote:
> W dniu 5 grudnia 2011 16:27 użytkownik Arend van Spriel
> <arend@broadcom.com> napisał:
>>> You're right, we don't handle this properly. I'll try to send patch
>>> today to make use of fixed windows. I've it here for some time
>>> already, just didn't clean it enough.
>>>
>>
>> Ok. For now I have a patch in the bcma read/write host_pci functions
>> that solves it, but fixed bar windows are preferable.
> 
> Have you tested my patch? Does it solver your issue? I can't wait to
> see bcma patches for brcmsmac :)
> 

Not yet. I had a patch in which each read/write used a
spin_lock_irqsave/spin_unlock_irqrestore. Did not cause to much latency.
I intend to rebase my changes using your patch later today.

Your patch only works if all cores fit in the window. This is the case
for the current pci-based broadcom chipsets so the patch is fine. I will
let you know the results. I also intend to do some suspend/resume
testing. I believe there was some issue mentioned on wireless mailing
list with bcma/b43.

Gr. AvS

