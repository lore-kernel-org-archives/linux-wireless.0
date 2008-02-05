Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:41732 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbYBEKFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 05:05:36 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2168600fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2008 02:05:34 -0800 (PST)
Message-ID: <47A834EC.1070503@gmail.com> (sfid-20080205_100540_444080_E4CF26F7)
Date: Tue, 05 Feb 2008 11:05:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: bruno randolf <bruno@thinktube.com>
CC: ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [ath5k-devel] [PATCH 5/7] ath5k: Port debug.c over to the new
 band API and enable as build option
References: <48232833e8885012a94d1e4afeabfd1deca9f70f.1202092325.git.mcgrof@winlab.rutgers.edu> <200802051901.23454.bruno@thinktube.com>
In-Reply-To: <200802051901.23454.bruno@thinktube.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2008 11:01 AM, bruno randolf wrote:
> On Tuesday 05 February 2008 00:03:54 Luis R. Rodriguez wrote:
>> diff --git a/drivers/net/wireless/ath5k/Kconfig
>> b/drivers/net/wireless/ath5k/Kconfig index af1b6b8..31d570e 100644
>> --- a/drivers/net/wireless/ath5k/Kconfig
>> +++ b/drivers/net/wireless/ath5k/Kconfig
>> @@ -14,3 +14,24 @@ config ATH5K
>>
>>  	  If you choose to build a module, it'll be called ath5k. Say M if
>>  	  unsure.
>> +
>> +config ATH5K_DEBUG
>> +	bool "Atheros 5xxx debugging"
>> +	depends on ATH5K

To avoid this for each config option, it can be closed in

if ATH5K

config ATH5K_DEBUG
...

endif

block

>> +	---help---
>> +	  Atheros 5xxx debugging messages.
>> +
>> +	  Say Y, if and you will get debug options for ath5k.
>> +	  To use this, you need to mount debugfs:
>> +
>> +	  mkdir /debug/
>> +	  mount -t debugfs debug /debug/
>> +
>> +	  You will get access to files under:
>> +	  /debug/ath5k/phy0/
>> +
>> +	  To enable debug, pass the debug level to the debug module
>> +	  parameter. For example:
>> +

