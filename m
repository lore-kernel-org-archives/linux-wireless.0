Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1439 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1IXMeN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Sep 2011 08:34:13 -0400
Message-ID: <4E7DCE39.1010406@broadcom.com> (sfid-20110924_143419_206933_FEF41474)
Date: Sat, 24 Sep 2011 14:34:01 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/20] staging: brcm80211: use endian annotated
 structures in brcmsmac
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
 <1316830148-28661-10-git-send-email-frankyl@broadcom.com> (
 sfid-20110924_040943_301385_9930B29B)
 <1316860721.3952.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1316860721.3952.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2011 12:38 PM, Johannes Berg wrote:
> On Fri, 2011-09-23 at 19:08 -0700, Franky Lin wrote:
>>   struct d11rxhdr {
>>   	u16 RxFrameSize;
>>   	u16 PAD;
>> +	union {
>> +		struct d11rxhdr_le rxh_le;
>> +		struct d11rxhdr rxh_cpu;
>> +	};
> This seems a little strange. Why would it be both in LE and CPU byte
> order?

Indeed. When we receive it from the device it is in LE and we convert it 
to CPU order for further processing using rxh_cpu.

> johannes

Gr. AvS


