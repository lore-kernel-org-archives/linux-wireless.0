Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43712 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbbBRV1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2015 16:27:14 -0500
Received: by mail-ob0-f174.google.com with SMTP id wo20so7189777obc.5
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2015 13:27:14 -0800 (PST)
Message-ID: <54E503B0.8020904@lwfinger.net> (sfid-20150218_222717_743532_A3C902A5)
Date: Wed, 18 Feb 2015 15:27:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike Turner <miketurner.forum@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192cu beacon fix unreliable
References: <loom.20150213T114021-973@post.gmane.org>
In-Reply-To: <loom.20150213T114021-973@post.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2015 04:48 AM, Mike Turner wrote:
> When using hostapd and an rtl8192cu Wireless USB adaptor the beacon
> doesn't start sometimes. This was tested with the
>
> kernel/git/davem/net-next.git repository
>
> and
>
> 3423eb92315865d76cb8d488513bfef6ab9251d0
>
> This behaviour is apparently random. If the beacon starts OK then it
> continues. If a beacon isn't generated then it never starts. Repeating
> cycles of hostapd stop/start may or may not generate a beacon. There are
> no specific error messages displayed either on console or in syslog. I
> have repeated hostapd stop/start a number of consecutive times and
> received a beacon each time, however I have also done this a number of
> times and never generated a beacon.
>
> We have succesfully used the pvaret-rtl8192cu driver which is based on the
> vendor driver and used that in conjunction with the modified hostapd code
> that requires use of the rtl871xdrv driver interface and as far as we have
> seen it always generates a beacon.
>
> Platform is a custom designed Atmel-ARM CPU (AT91SAM9G25) with a D-Link
> DWA-121.

Is send_beacon_frame() being called even when the beacon fails to start? Adding 
a pr_info() at the start of the routine should answer that question.

Larry


