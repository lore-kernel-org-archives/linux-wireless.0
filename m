Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33934 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab0JZRh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 13:37:28 -0400
Received: by eye27 with SMTP id 27so5509842eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 10:37:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimt8yX6NTsLdwaWuOZifhN5hDnQkH+FBsPr50+Z@mail.gmail.com>
References: <AANLkTinP32=snam3Bex+OC8LL00awfjrJz4834mhOaNL@mail.gmail.com>
	<1287995967.3587.9.camel@jlt3.sipsolutions.net>
	<AANLkTik-SaE2ShV7H6Lv1qFQ-FM5fPuWGws6pWM+b6Go@mail.gmail.com>
	<AANLkTik12g6kmynbgyhPuu+B5jZ9Swv+1PhAg9EKMByw@mail.gmail.com>
	<AANLkTi=Qs8tQyNQQik8unFd5NUf2LW2UFowMJ0yjTr0b@mail.gmail.com>
	<AANLkTimt8yX6NTsLdwaWuOZifhN5hDnQkH+FBsPr50+Z@mail.gmail.com>
Date: Tue, 26 Oct 2010 10:37:26 -0700
Message-ID: <AANLkTinDtkzbPouvWrGW7AOVDJ+0sq_GEx6HM289NtFm@mail.gmail.com>
Subject: Re: Modifying the driver iwlwifi
From: Blaise Gassend <blaise@willowgarage.com>
To: "Cassiano Tartari, Eng." <falecom@cassianotartari.eng.br>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> what is a "agressive DHCP client" ? I saw in the manual, there a lot
> of telnet commans for DHCP

One that doesn't start by waiting a few seconds, to start with. I'm
thinking about a client that immediately tries to get a lease, and
does retries within a few hundred ms at most if it doesn't get a
response. dhclient definitely isn't an aggressive dhcp client. It
isn't supposed to be.

> I tryed:
> sudo iwconfig wlan0 mode managed freq 2.437G rate 1M frag 256 key open
> essid 'cassiano-PC_AP'
>
> But when I try to run:
> sudo dhclient wlan0
>
> return: "No DHCPOFFERS received"
>
> And I need to do this because my code will connect automatic. Using
> the networkManager (ubuntu) the connection appears to occur fast.

I can't debug your setup for you, and I suspect this list isn't the
right place to do it... Have you checked that you actually associated
to the AP? Have you tried using tcpdump to see if packets are making
it out?

Blaise
