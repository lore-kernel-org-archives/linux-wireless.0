Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36586 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab1EFSB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 14:01:57 -0400
Received: by gxk21 with SMTP id 21so1297715gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 11:01:56 -0700 (PDT)
Date: Fri, 6 May 2011 14:01:52 -0400
From: Tom Horsley <horsley1953@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: r8192cu AP mode?
Message-ID: <20110506140152.60c9da93@tomh> (sfid-20110506_200200_648337_7CEF8536)
In-Reply-To: <4DC4306F.20104@lwfinger.net>
References: <20110506081356.08ac93a8@tomh>
	<4DC40CEB.5010107@lwfinger.net>
	<20110506131612.7a6d40cb@tomh>
	<4DC4306F.20104@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 06 May 2011 12:31:27 -0500
Larry Finger wrote:

> What does the output of dmesg say?
> 
> If could be as simple as your compiler is a different version.

I actually figured that out as well: In the messages file
I saw these errors:

May  6 13:12:57 tomh kernel: [ 1106.442233] compat: exports duplicate symbol vzalloc (owned by kernel)

I removed the definition of vzalloc (which is maybe defined
by fedora in some backported patch in their kernel?) and I can now load
the modules and even try to connect, but I keep getting
this sequence:

May  6 13:40:11 tomh hostapd: wlan0: STA 60:a1:0a:c7:af:01 IEEE 802.11: authenticated
May  6 13:40:11 tomh hostapd: wlan0: STA 60:a1:0a:c7:af:01 IEEE 802.11: associated (aid 1)
May  6 13:40:14 tomh hostapd: wlan0: STA 60:a1:0a:c7:af:01 IEEE 802.11: deauthenticated due to local deauth request

So I haven't gotten far enough to worry about DHCP or
NAT or anything yet - I only stay connected for a second. Perhaps
I should first try something less complicated than WPA2
authentication, but I won't get a chance to fool with this
more till tomorrow probably. It's looking a lot better now
that it did earlier though.

Also, when running hostapd -dd, I get an endless stream of
these messages:

Unknown Broadcom information element ignored (type=52 len=26)

don't know if that actually matters to anyone.
