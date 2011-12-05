Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1508 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932314Ab1LEP11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 10:27:27 -0500
Message-ID: <4EDCE2CC.3060500@broadcom.com> (sfid-20111205_162742_906340_611C6253)
Date: Mon, 5 Dec 2011 16:27:08 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcma usage in isr context
References: <4ED77C85.1050705@broadcom.com>
 <CACna6rznu8d1BjG0EWjP1VRCPdYAGJv1q+fi1X+XF_Bf-Cx+Mg@mail.gmail.com>
In-Reply-To: <CACna6rznu8d1BjG0EWjP1VRCPdYAGJv1q+fi1X+XF_Bf-Cx+Mg@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2011 12:30 PM, Rafał Miłecki wrote:
> Hi,
> 
> Sorry for late reply, I was a little busy recently...
> 
> W dniu 1 grudnia 2011 14:09 użytkownik Arend van Spriel
> <arend@broadcom.com> napisał:
>> I am doing some final testing on our brcmsmac driver, which I tinkered
>> to become a bcma device driver. During testing an issue popped up in the
>> ISR code.
> 
> Do you mean interrupts code?

Yep. ISR stands for 'interrupt service routine'.

>> Looking into the bcma read/write functions in host_pci.c I conclude that
>> bcma itself does not provide protection for concurrency. Am I correct in
>> that? How is this solved in b43?
> 
> I think I mean the fact that core driver can switch BCMA to
> ChipCommon, while interrupt handler will try to access 80211 core?

That is indeed what I mean.

> You're right, we don't handle this properly. I'll try to send patch
> today to make use of fixed windows. I've it here for some time
> already, just didn't clean it enough.
> 

Ok. For now I have a patch in the bcma read/write host_pci functions
that solves it, but fixed bar windows are preferable.

Gr. AvS

