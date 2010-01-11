Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46006 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0AKA1v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 19:27:51 -0500
Received: by yxe17 with SMTP id 17so19887207yxe.33
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2010 16:27:50 -0800 (PST)
Message-ID: <4B4A7084.8010309@lwfinger.net>
Date: Sun, 10 Jan 2010 18:27:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/6] b43: N-PHY: add RSSI functions: poll and set 2055
 vcm
References: <op.u6b70ig59lhzdc@linux-g0th.site> <201001102332.22954.mb@bu3sch.de>
In-Reply-To: <201001102332.22954.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/10/2010 04:32 PM, Michael Buesch wrote:
> On Sunday 10 January 2010 23:13:20 Rafał Miłecki wrote:
>> +		buf[0] += (s8)(((s[0] & 0x3F) << 2) >> 2);
>> +		buf[1] += (s8)((((s[0] >> 8) & 0x3F) << 2) >> 2);
>> +		buf[2] += (s8)(((s[1] & 0x3F) << 2) >> 2);
>> +		buf[3] += (s8)((((s[1] >> 8) & 0x3F) << 2) >> 2);
> 
> I suggest buf[3] += (s8)((((s[1] >> 8) & 0x3F) << 2) >> 2) << 2) >> 2) << 2) >> 2) << 2) >> 2) << 2) >> 2) << 2) >> 2) << 2) >> 2)
> ;)
> No, seriously, why shift left and then shift right? Is this a translation error?
> I _guess_ it's some mistranslation of the sign extension going on.
> Or alternatively a compiler going insane on sign extension.
> 
> The question is: Do we want these integers to be signextended or not?
> 
> What we currently do is this:
> buf[3] += (s8)((s[1] >> 8) & 0x3F);
> 
> which will always result in a positive 8bit integer, as far as I can see.
> Which smells fishy.

We do want sign extension of the signed 6-bit quantities into an 8-bit word. The
translation is correct. Do you know of a better way to extend the signs?

Larry
