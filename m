Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3996 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab2DWRpY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 13:45:24 -0400
Message-ID: <4F95952A.7020001@broadcom.com> (sfid-20120423_194528_229027_F2FF360E)
Date: Mon, 23 Apr 2012 10:45:14 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Florian Fainelli" <florian@openwrt.org>, linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.4 1/2] brcm80211: fmac: fix SDIO function 0
 register r/w issue
References: <1334957269-27416-1-git-send-email-frankyl@broadcom.com>
 <1334957269-27416-2-git-send-email-frankyl@broadcom.com>
 <4F9516B5.3000509@openwrt.org> (sfid-20120423_104718_390173_B2BFC4D3)
 <1335171007.3928.9.camel@jlt3.sipsolutions.net>
In-Reply-To: <1335171007.3928.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/23/2012 01:50 AM, Johannes Berg wrote:
> On Mon, 2012-04-23 at 10:45 +0200, Florian Fainelli wrote:
>
>>>    	} else if (regaddr == SDIO_CCCR_ABORT) {
>>> +		sdfunc = kzalloc(sizeof(struct sdio_func), GFP_KERNEL);
>>
>> You are not catching a kzalloc() possible failure here.
>>
>>> +		memcpy(sdfunc, sdiodev->func[0], sizeof(struct sdio_func));
>
> and it should probably be kmemdup anyway?
>
> johannes
>

Thx Florian and Johannes, I will send out a V2.

Franky


