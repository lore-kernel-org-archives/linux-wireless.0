Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33240 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbbBTLou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 06:44:50 -0500
Received: by mail-oi0-f46.google.com with SMTP id x69so2114546oia.5
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2015 03:44:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54E503B0.8020904@lwfinger.net>
References: <loom.20150213T114021-973@post.gmane.org>
	<54E503B0.8020904@lwfinger.net>
Date: Fri, 20 Feb 2015 11:44:49 +0000
Message-ID: <CALA4C6V+zzMBMZy8_AbMt7-aqm27_EgJ5GHgCF8xGXhV2V6RMg@mail.gmail.com> (sfid-20150220_124455_183629_27F54933)
Subject: Re: rtl8192cu beacon fix unreliable
From: Mike Turner <miketurner.forum@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2015 at 9:27 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 02/13/2015 04:48 AM, Mike Turner wrote:
>>
>> When using hostapd and an rtl8192cu Wireless USB adaptor the beacon
>> doesn't start sometimes. This was tested with the
>>
>> kernel/git/davem/net-next.git repository
>>
>> and
>>
>> 3423eb92315865d76cb8d488513bfef6ab9251d0
>>
>> This behaviour is apparently random. If the beacon starts OK then it
>> continues. If a beacon isn't generated then it never starts. Repeating
>> cycles of hostapd stop/start may or may not generate a beacon. There are
>> no specific error messages displayed either on console or in syslog. I
>> have repeated hostapd stop/start a number of consecutive times and
>> received a beacon each time, however I have also done this a number of
>> times and never generated a beacon.
>>
>> We have succesfully used the pvaret-rtl8192cu driver which is based on the
>> vendor driver and used that in conjunction with the modified hostapd code
>> that requires use of the rtl871xdrv driver interface and as far as we have
>> seen it always generates a beacon.
>>
>> Platform is a custom designed Atmel-ARM CPU (AT91SAM9G25) with a D-Link
>> DWA-121.
>
>
> Is send_beacon_frame() being called even when the beacon fails to start?
> Adding a pr_info() at the start of the routine should answer that question.
>
> Larry
>
>

Just tried your patch, however it failed on the 3rd restart - this is
a resend as it bounced from linux-wireless previously due to content
type.
