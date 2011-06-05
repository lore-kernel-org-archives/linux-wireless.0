Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2385 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab1FEIgZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 04:36:25 -0400
Message-ID: <4DEB3FF3.8090904@broadcom.com> (sfid-20110605_103629_126360_73D0E5D3)
Date: Sun, 5 Jun 2011 10:36:03 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 44/83] staging: brcm80211: replaced typedef si_t
 with struct si_pub
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-44-git-send-email-rvossen@broadcom.com>
 <BANLkTin1hT2WT40_uozZvtX-PH5aZHqfZg@mail.gmail.com>
 <4DE90DCE.6060207@broadcom.com>
 <BANLkTimQacOURw4wQzkyNizksZZj=nhvfQ@mail.gmail.com>
In-Reply-To: <BANLkTimQacOURw4wQzkyNizksZZj=nhvfQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

> On Sat, Jun 4, 2011 at 02:37, Roland Vossen<rvossen@broadcom.com>  wrote:
>> Hello Julian,
>>
>> the structure definition itself is already in a header file (aiutils.h).
>> Probably you are referring to the forward declaration used in the patch?
>
> Exactly, it probably shouldn't be here as the header file that
> includes the structure should arguably already be included.

I am afraid I have to disagree with you, for the reason that by 
including the header file you introduce unnecessary coupling. Let me 
elaborate. If a .c file does not need to know the contents of a struct, 
but it only needs to know that a pointer to an opaque struct, then one 
should not provide the C file with knowledge on the internals of the 
struct (hence not include the .h file).

Bye, Roland.

