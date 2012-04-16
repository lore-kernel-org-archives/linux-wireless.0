Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47869 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab2DPPv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 11:51:29 -0400
Message-ID: <4F8C3FFD.6030602@lwfinger.net> (sfid-20120416_175145_827938_34C44E0F)
Date: Mon, 16 Apr 2012 10:51:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: LKML <linux-kernel@vger.kernel.org>,
	driverdevel <devel@driverdev.osuosl.org>,
	wireless <linux-wireless@vger.kernel.org>,
	Jan Simonson <jan@simonson.se>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Problem with crypto when initializing TKIP
References: <4F8BAE2F.5090200@lwfinger.net> <20120416124839.GA5985@gondor.apana.org.au>
In-Reply-To: <20120416124839.GA5985@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 07:48 AM, Herbert Xu wrote:
> On Mon, Apr 16, 2012 at 12:29:19AM -0500, Larry Finger wrote:
>>
>> The value of ok is NOTIFY_OK, which leads to a return of -ENOENT and
>> a failure of the initialization.
>
> NOTIFY_OK means that we have no notifiers installed.  Did you
> compile/load CRYPTO_MANAGER?

Thanks for responding. The CRYPTO_MANAGER is built in, but your suggestion got 
me into the correct area. For some unknown reason, CONFIG_MICHAEL_MIC was 
dropped from my configuration. When I added it, everything works.

I will improve the error message in the driver.

Thanks again,

Larry
