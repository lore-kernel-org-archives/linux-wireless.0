Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34721 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZGMSna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 14:43:30 -0400
Received: by fxm18 with SMTP id 18so2376369fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 11:43:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247499979.17896.1556.camel@rc-desk>
References: <1247174482.17896.1304.camel@rc-desk>
	 <200907121445.42289.helmut.schaa@gmail.com>
	 <1247499979.17896.1556.camel@rc-desk>
Date: Mon, 13 Jul 2009 11:43:28 -0700
Message-ID: <bcd1ba70907131143m2940444ch372ae0bc01417bc4@mail.gmail.com>
Subject: Re: [ipw3945-devel] iwlwifi 4965 uCode available
From: John Ranson <ranson@analager.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am also seeing frequent loss of association and firmware restarts
with the new firmware.  On occasion, I can't recover even when I
reload the driver. Admittedly, I am using an old driver right now
(2.6.29, I think).

I'm going to upgrade to 2.6.30.1 with the latest compat-wireless. I'll
file a bug if things continue as they are.

Thank you very much for getting the new firmware out!

Cheers,

John

On Mon, Jul 13, 2009 at 8:46 AM, reinette
chatre<reinette.chatre@intel.com> wrote:
> Hi Helmut,
>
> On Sun, 2009-07-12 at 05:45 -0700, Helmut Schaa wrote:
>> Am Donnerstag, 9. Juli 2009 schrieb reinette chatre:
>> > Version 228.61.2.24 of uCode for Intel Wireless WiFi Link 4965AGN is now
>> > available for download from
>> > http://intellinuxwireless.org/?n=Downloads
>>
>> The new ucode seems to cause fw restarts every now and then (together
>> with wireless-testing).
>
> oh no ...
>
>>
>> iwlagn 0000:10:00.0: Microcode SW error detected.  Restarting 0x82000000.
>
> What is the status when such an error occurs? Can it recover on its own
> or do you need to take action? What action is needed?
>
>>
>> I couldn't figure out how to reproduce this but it happened a few times
>> now since I switched to the new ucode.
>>
>> Should I load iwlagn with some special debug flags?
>
> If your driver is compiled with CONFIG_IWLWIFI_DEBUG then you can pass a
> debug flag to the module that will print a ucode event log when it
> encounters a problem like this. As it will only print out the event log
> when this error occurs you can safely turn this debugging on permanently
> without risking a clutter of your logs. Later, if you know how to
> reproduce is you can increase debugging to get more details about what
> the driver is actually doing. The debug flag for _just_ the ucode event
> log is 0x40000 (like "modprobe iwlagn debug=0x40000"). The 0x43fff is a
> more general debug flag that helps with obtaining more information.
>
> When you have this data - could you please submit a bug at
> intellinuxwireless.org/bugzilla for us to be able to track it?
>
> Thank you very much
>
> Reinette
>
>
>
> ------------------------------------------------------------------------------
> Enter the BlackBerry Developer Challenge
> This is your chance to win up to $100,000 in prizes! For a limited time,
> vendors submitting new applications to BlackBerry App World(TM) will have
> the opportunity to enter the BlackBerry Developer Challenge. See full prize
> details at: http://p.sf.net/sfu/Challenge
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
