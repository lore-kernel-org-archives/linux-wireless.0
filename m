Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:41307 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbbARVqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 16:46:42 -0500
Received: by mail-lb0-f177.google.com with SMTP id p9so2108291lbv.8
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2015 13:46:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54BBFACA.9010609@hauke-m.de>
References: <1421444828-32616-1-git-send-email-zajec5@gmail.com>
	<54BBFACA.9010609@hauke-m.de>
Date: Sun, 18 Jan 2015 22:46:40 +0100
Message-ID: <CACna6rzNF9cLErWTBJa+-Zf7jOqUa2AhTdASAnNnGehJ1KYYyg@mail.gmail.com> (sfid-20150118_224824_455943_AF6647EC)
Subject: Re: [PATCH RFC] bcma: simplify freeing cores (internal devices structs)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Saul St. John" <saul.stjohn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 January 2015 at 19:26, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 01/16/2015 10:47 PM, Rafał Miłecki wrote:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> This code was introduced by Saul in
>> ee91592711ed90a1abfbb1b2ceadded11d685164
>> bcma: don't leak memory for PCIE, MIPS, GBIT cores
>>
>> I don't really see reason for making it in so complicated way.
>> I tested my patch for crashes, but didn't really try kmemleak.
>> Is my simple solution OK? Or am I missing something? Anyone?
>
> Are you sure no device driver accesses the chipcommon, pcie or mips core
> in the unregister part? If some device driver does something in his
> remove function with e.g. chipcommon it will cause problems when the
> chipcommon core was already freed.

It didn't crash anything for me, but your point is correct. I'll
change the logic to first unregister and then free cores.

-- 
Rafał
