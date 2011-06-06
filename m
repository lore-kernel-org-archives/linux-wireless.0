Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1615 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab1FFHb7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 03:31:59 -0400
Message-ID: <4DEC825A.2020404@broadcom.com> (sfid-20110606_093202_193462_3587BF33)
Date: Mon, 6 Jun 2011 09:31:38 +0200
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
 <4DEB3FF3.8090904@broadcom.com>
 <BANLkTi=HrP5pSi0t-18N2yGpBueeL2qMSg@mail.gmail.com>
In-Reply-To: <BANLkTi=HrP5pSi0t-18N2yGpBueeL2qMSg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

>> I am afraid I have to disagree with you, for the reason that by including
>> the header file you introduce unnecessary coupling. Let me elaborate. If a
>> .c file does not need to know the contents of a struct, but it only needs to
>> know that a pointer to an opaque struct, then one should not provide the C
>> file with knowledge on the internals of the struct (hence not include the .h
>> file).
>
> Fair enough. I guess I just don't like void pointers.

Well, what I mean is this: suppose you have a function that gets a 
pointer to a struct as one of its parameters. This function calls 
another function with this parameter:

void foo(struct *bar) {
	some_other_fnct(bar);
}

Then foo() simply passes the pointer on to some_other_fnct(), and foo() 
does not need to know about the members inside struct bar. So I am not 
talking about void pointers here as the alternative.

Bye, Roland.

