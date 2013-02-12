Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:59464 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3BLUSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 15:18:32 -0500
Received: by mail-oa0-f54.google.com with SMTP id n12so532314oag.13
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2013 12:18:32 -0800 (PST)
Message-ID: <511AA395.8000802@lwfinger.net> (sfid-20130212_211836_650641_1CF5DDB0)
Date: Tue, 12 Feb 2013 14:18:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Rework Kconfig
References: <511a9bda.qSVbJjBneEGprv+8%Larry.Finger@lwfinger.net> <1360698872.17456.11.camel@joe-AO722>
In-Reply-To: <1360698872.17456.11.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2013 01:54 PM, Joe Perches wrote:
> On Tue, 2013-02-12 at 13:45 -0600, Larry Finger wrote:
>> As the number of drivers in the rtlwifi family has grown, the Kconfig
>> section for them has grown unwieldy. This change has two effects: (1)
>> Variable RTLWIFI_DEBUG is documented, and (2) the entries for the
>> drivers that depend on RTLWIFI and indented.
>
> trivial note below:
>
>> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/Kconfig
>> @@ -1,8 +1,26 @@
> []
>> +config RTLWIFI_DEBUG
>> +	bool "Debugging output for rtlwifi driver family"
>> +	depends on RTLWIFI
>> +	default y
>> +	---help---
>> +	This option is needed for the "debug=n" module option to produce any
>> +	output. For embedded or other memory-limited systems, choose "N".
>> +	For all other systems, or if in doubt, use "Y".
>
> using "debug=n" here can be a bit confusing given the
> "N" and "Y" that follow it.
>
> maybe debug=<0x...> module parameter to control debug
> message level output.

How about the following:

         This option must be "Y" for the module option for dynamic debugging
         to produce any output. For embedded or other memory-limited systems,
         choose "N". If in doubt, choose "Y".

Larry


