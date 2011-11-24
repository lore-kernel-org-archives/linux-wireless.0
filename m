Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43898 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab1KXPkn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 10:40:43 -0500
Received: by iage36 with SMTP id e36so3140491iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 07:40:42 -0800 (PST)
Message-ID: <4ECE6570.1030706@lwfinger.net> (sfid-20111124_164047_272970_B3A334F4)
Date: Thu, 24 Nov 2011 09:40:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?SmFuIER2b8WZw6Fr?= <dvorakj@cngroup.dk>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192cu not working with Edimax EW-7811Un
References: <20111122113427.3d332b00776546d5ebac11de@cngroup.dk> <20111122140139.GA3891@redhat.com> <20111123112301.f5e523ff743f86dae539fdf3@cngroup.dk> <20111123143304.GA13460@redhat.com> <20111123162426.9a30d25585fa54507c1c864e@cngroup.dk> <4ECD13D0.6010500@lwfinger.net> <20111123155108.GD13460@redhat.com> <20111123175210.fd0ac6b0b66885b3deaecfc0@cngroup.dk> <4ECD3E5E.6010109@lwfinger.net> <20111124140350.06e9644056a9b4993bc093cb@cngroup.dk>
In-Reply-To: <20111124140350.06e9644056a9b4993bc093cb@cngroup.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2011 07:03 AM, Jan Dvořák wrote:
> On Wed, 23 Nov 2011 12:41:34 -0600
> Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>>>>> I can't still use hostapd, however.
>>>> Hmm, I'm not sure if rtl92c works in AP mode, Larry?
>>
>> When I try it, I get rtl8192cu to beacon, and it is possible to authenticate and
>> associate, but the second computer never gets an IP number.
>
> Even without DHCP, no traffic ever comes through. Plus from here it looks like
> the client is reconnecting (quickly, let's say once per 5s) to no end.
>
> So, how do I debug this properly? Can I turn on some kind of verbose mode?
> Is there a way to sniff the communication (kismet or something)?

You could look at what the device is putting on the air with kismet or 
wireshark. Another option would be to see the flow through the driver by loading 
the driver with the debug option. The maximum debug level of 5 is likely too 
much output, but using 4 should be OK. You need a recent kernel to use this 
option. I'm not sure if it is in 3.1 or not. Use 'modinfo rtl8192cu' to see the 
module parameter list.

Larry

