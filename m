Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:36244 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbZBHT70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 14:59:26 -0500
Received: by fg-out-1718.google.com with SMTP id 16so929766fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2009 11:59:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090208192343.106487dmjra19g6o@neo.wg.de>
References: <20090206233134.11116cap9kcroxgc@neo.wg.de>
	 <1233960318.11530.114.camel@rc-desk>
	 <20090208192343.106487dmjra19g6o@neo.wg.de>
Date: Sun, 8 Feb 2009 20:59:25 +0100
Message-ID: <69e28c910902081159v1371ee70nb5e70ebdc648b54a@mail.gmail.com> (sfid-20090208_205929_584469_5786810B)
Subject: Re: iwlagn: Microcode SW error detected.
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: Jan Schneider <jan@horde.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 8, 2009 at 7:23 PM, Jan Schneider <jan@horde.org> wrote:
> Zitat von reinette chatre <reinette.chatre@intel.com>:
>
>> On Fri, 2009-02-06 at 14:31 -0800, Jan Schneider wrote:
>>>
>>> I've seen in a post from January that someone already had this problem
>>> but couldn't reproduce it.
>>> I can't reliably reproduce, but I see this more often than I like.
>>> When this happens, it usually doesn't help to reload the kernel
>>> module. Sometimes it helps to use the rfkill switch though.
>>>
>>> Here's a log with debug=0x43fff:
>>
>> It does not seem as though your driver is compiled with debug support.
>> You can confirm that by looking at the version number of the driver
>> printed when it loads ... it should have a "d" in it like "1.2.26kds".
>> Could you please recompile the driver with debug support (IWLWIFI_DEBUG)
>> and rerun your test?  This will provide us with a complete event log of
>> the uCode error.
>
> Enabling debug didn't help:
>
> Feb  7 00:04:40 tank kernel: [ 2769.084395] iwlagn: Intel(R) Wireless WiFi
> Link
> AGN driver for Linux, 1.3.27kds
>
>
> /etc/modprobe.d/iwlagn:
>
> options iwlagn debug=0x43fff
>
>
> I still get:
>
> Feb  8 18:40:53 tank kernel: [77584.979829] iwlagn 0000:0c:00.0: Microcode
> SW er
> ror detected.  Restarting 0x2000000.
> Feb  8 18:40:53 tank kernel: [77585.029747] Registered led device:
> iwl-phy0::rad
> io
> Feb  8 18:40:53 tank kernel: [77585.030765] Registered led device:
> iwl-phy0::ass
> oc
> Feb  8 18:40:53 tank kernel: [77585.031602] Registered led device:
> iwl-phy0::RX
> Feb  8 18:40:53 tank kernel: [77585.032467] Registered led device:
> iwl-phy0::TX
>
> Jan.
>
> --
> Do you need professional PHP or Horde consulting?
> http://horde.org/consulting/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

No - enable IWLWIFI_DEBUG in your kernel config, then rebuild the
kernel (or at least the iwlwifi modules).

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
