Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1607 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab1DTHlJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 03:41:09 -0400
Message-ID: <4DAE8E00.8040603@broadcom.com>
Date: Wed, 20 Apr 2011 09:40:48 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] staging: brcm80211: removed #ifdef __mips__
References: <1303197225-4263-1-git-send-email-rvossen@broadcom.com>
 <1303197225-4263-2-git-send-email-rvossen@broadcom.com>
 <1303215002.27432.5.camel@maggie> <4DAD920A.9080500@broadcom.com>
 <1303220960.27432.11.camel@maggie>
 <1303221437.3603.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1303221437.3603.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/19/2011 03:57 PM, Johannes Berg wrote:
> I don't see how write flushing would be MIPS specific anyway? It's a
> function of the bus (PCI), not the host architecture, no?

Since I am not the original author of that piece of code, I had to make 
some inquiries, hence my non immediate response.

It turns out that the read-after-write construct was introduced in the 
code to ensure write order for certain Broadcom chips. Those chips are: 
bcm4706, bcm4716, bcm4717, bcm4718. All these chips contain a MIPS 
processor.

The #ifdef __mips__ in the code is broader than just those chips. The 
side effect is that other broadcom chips with a mips processor also 
execute the extra read, leading to some I/O overhead, which is acceptable.

Bye, Roland.

