Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2583 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab1IXOt2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Sep 2011 10:49:28 -0400
Message-ID: <4E7DEDE9.9010102@broadcom.com> (sfid-20110924_164932_009799_0136B2A6)
Date: Sat, 24 Sep 2011 16:49:13 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 14/20] staging: brcm80211: remove dongle firmware
 related debug code
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
 <1316830148-28661-15-git-send-email-frankyl@broadcom.com> (
 sfid-20110924_041001_582824_018BAB77)
 <1316860785.3952.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1316860785.3952.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2011 12:39 PM, Johannes Berg wrote:
> On Fri, 2011-09-23 at 19:09 -0700, Franky Lin wrote:
>> From: Arend van Spriel<arend@broadcom.com>
>>
>> When the device dies the driver could extract cpu registers on
>> the device to analyze the trap handling on the dongle. As the
>> firmware with this driver is stable this code does not belong
>> in the brcmfmac driver.
>>
>> Reported-by: Johannes Berg<johannes@sipsolutions.net>
> FWIW, when I said this looked strange I might have thought that it was
> actually accessing the *host* registers. I don't remember exactly what I
> said. If this is debug code for the dongle, then maybe it makes sense to
> keep it, maybe optionally. I don't think you'll want to support a
> separate driver just for debug. You could even use nl80211 testmode to
> export it to userspace for your tools.

Thanks, Johannes

Your comment was understood and merely a trigger for us to reconsider 
whether we would need it in this driver. As the mechanism has also not 
been tested in the brcmfmac driver and we consider the firmware stable, 
we decided to remove it.

Gr. AvS

