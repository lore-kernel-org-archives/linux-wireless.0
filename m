Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:1032 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755467Ab2ICBXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 21:23:51 -0400
Message-ID: <504406A2.7000303@gmail.com> (sfid-20120903_032417_129467_74B68891)
Date: Mon, 03 Sep 2012 03:23:46 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH v2 6/6] rt2x00: rt2800 - Make probe_hw function common
 between PCI and USB.
References: <1346433734-3337-1-git-send-email-gwingerde@gmail.com> <1346433734-3337-2-git-send-email-gwingerde@gmail.com> <1346433734-3337-3-git-send-email-gwingerde@gmail.com> <1346433734-3337-4-git-send-email-gwingerde@gmail.com> <1346433734-3337-5-git-send-email-gwingerde@gmail.com> <1346433734-3337-6-git-send-email-gwingerde@gmail.com> <1346433734-3337-7-git-send-email-gwingerde@gmail.com> <CAOZOX0UvKHoPrcQ8C15eeogknFexBmb1qeiGb0PC52nKMri=JQ@mail.gmail.com>
In-Reply-To: <CAOZOX0UvKHoPrcQ8C15eeogknFexBmb1qeiGb0PC52nKMri=JQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/02/12 22:44, Ivo Van Doorn wrote:
> Hi,
> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index c3cae1d..2ad3b7a 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -44,6 +44,13 @@
>>  #include "rt2800.h"
>>
>>  /*
>> + * Allow hardware encryption to be disabled.
>> + */
>> +static bool modparam_nohwcrypt = false;
>> +module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
>> +MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
> 
> I am not particularly fond of this change, I would like to have the
> module parameters inside the actual drivers instead of inside one of
> the
> library modules. I don't know if there is a policy for modules which
> says something about these situations, but my preference would be
> that the module parameters are inside rt2800pci and rt2800usb, and
> that the value would be passed to rt2800lib.
> 
> If there is isn't a simple and clean way to do that, then we can take
> this patch though...
> 

Yeah, I wasn't a big fan of that part as well, but at the time couldn't
find a better solution. I do have a better solution now, though.
v3 of this patch will be posted soon.

---
Gertjan
