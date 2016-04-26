Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39058 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752872AbcDZSbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 14:31:14 -0400
Message-ID: <1461695468.13240.58.camel@coelho.fi> (sfid-20160426_203132_746352_0B1195A6)
From: Luca Coelho <luca@coelho.fi>
To: Mitchel Humpherys <mitch.special@gmail.com>,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 26 Apr 2016 21:31:08 +0300
In-Reply-To: <87d1pcthr0.fsf@gmail.com>
References: <87d1pcthr0.fsf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Intel WiFi regression on linux-next
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-04-26 at 10:14 -0700, Mitchel Humpherys wrote:
> Hello,

Hello Mitchel,


> WiFi on my Acer Aspire 5739G is currently broken on linux-next.  I
> bisected it to the following commit:
> 
>     commit 97f95c93c8ed5177371e75275f236513152fa308
>     Author: Sara Sharon <sara.sharon@intel.com>
>     Date:   Mon Mar 7 16:55:20 2016 +0200
>     
>         iwlwifi: remove support for fw older than -16.ucode
> 
> This issue was already reported here [1].  I'm just adding some more
> hardware details (and am not subscribed to linux-wireless so I can't
> reply over there).
> 
> It's failing with:
> 
>     iwlwifi 0000:05:00.0: enabling device (0000 -> 0002)
>     iwlwifi 0000:05:00.0: can't disable ASPM; OS doesn't have ASPM
> control
>     iwlwifi 0000:05:00.0: Driver unable to support your firmware API.
> Driver supports v5, firmware is v139658497.
>     iwlwifi 0000:05:00.0: Direct firmware load for iwlwifi-5000-
> 4.ucode failed with error -2
>     iwlwifi 0000:05:00.0: request for firmware file 'iwlwifi-5000-
> 4.ucode' failed.
>     iwlwifi 0000:05:00.0: Direct firmware load for iwlwifi-5000-
> 3.ucode failed with error -2
>     iwlwifi 0000:05:00.0: request for firmware file 'iwlwifi-5000-
> 3.ucode' failed.
>     iwlwifi 0000:05:00.0: Driver unable to support your firmware API.
> Driver supports v5, firmware is v135791116.
>     iwlwifi 0000:05:00.0: Driver unable to support your firmware API.
> Driver supports v5, firmware is v84148496.
>     iwlwifi 0000:05:00.0: no suitable firmware found!

This was fixed in a patch I sent to Kalle yesterday and he merged
today:

http://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next
.git/commit/?id=f0d8f38cd909e072833a06b79939256c4aebe3a0

HTH.

--
Cheers,
Luca.
