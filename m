Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63664 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab2ENOS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 10:18:29 -0400
Received: by pbbrp8 with SMTP id rp8so6171897pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 07:18:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1337004474.4303.17.camel@jlt3.sipsolutions.net>
References: <CALGY4fvUmHmFbYAH2044qCBOozOqmOCBcmB8acV-Qivd3PpFgQ@mail.gmail.com>
	<1337004474.4303.17.camel@jlt3.sipsolutions.net>
Date: Mon, 14 May 2012 10:18:28 -0400
Message-ID: <CALGY4ftipuxoSVN_4Aa0GvEU5E7n8q2iRWBmSWrQTYxit5gXPw@mail.gmail.com> (sfid-20120514_161903_215301_BDAB2B7C)
Subject: Re: iwlwifi regression: disconnections
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/5/14 Johannes Berg <johannes@sipsolutions.net>:
> On Mon, 2012-05-14 at 10:00 -0400, Nikolay Martynov wrote:
>
>>   Here is what I see in logs during disconnect:
>>
>> [ 1024.296004] ICMPv6 RA: ndisc_router_discovery() failed to add default route.
>> [ 1259.209166] wlan1: deauthenticating from XX:XX:XX:XX:XX:XX by local
>> choice (reason=3)
>
>> I'll be happy to help with any additional information of debugging.
>
> Hmm, this is interesting. Can you check syslog for anything from
> wpa_supplicant and/or network manager or whatever you use? This just
> means userspace decided to disconnect, but doesn't give a clue as to
> why.

Not sure is this is relevant, but it looks like that this is all I have in logs:

May 14 10:10:03 laptop kernel: [ 2223.292056] ICMPv6 RA:
ndisc_router_discovery() failed to add default route.
May 14 10:14:35 laptop NetworkManager[1003]: <info> (wlan1): device
state change: 8 -> 9 (reason 5)
May 14 10:14:35 laptop NetworkManager[1003]: <warn> Activation (wlan1)
failed for access point (nowhere)
May 14 10:14:35 laptop NetworkManager[1003]: <warn> Activation (wlan1) failed.
May 14 10:14:35 laptop NetworkManager[1003]: <info> (wlan1): device
state change: 9 -> 3 (reason 0)
May 14 10:14:35 laptop NetworkManager[1003]: <info> (wlan1):
deactivating device (reason: 0).
May 14 10:14:35 laptop NetworkManager[1003]: <info> (wlan1): canceled
DHCP transaction, DHCP client pid 3484
May 14 10:14:35 laptop kernel: [ 2495.208887] wlan1: deauthenticating
from XX:XX:XX:XX:XX:XX by local choice (reason=3)
May 14 10:14:35 laptop kernel: [ 2495.292334] cfg80211: All devices
are disconnected, going to restore regulatory settings
May 14 10:14:35 laptop kernel: [ 2495.292345] cfg80211: Restoring
regulatory settings
May 14 10:14:35 laptop kernel: [ 2495.292355] cfg80211: Calling CRDA
to update world regulatory domain
May 14 10:14:35 laptop wpa_supplicant[1103]: CTRL-EVENT-DISCONNECTED
bssid=00:00:00:00:00:00 reason=0

Some additional info than might be useful: I'm using ubuntu 11.04,
Network Manager has this version:
0.8.4~git.20110319t175609.d14809b-0ubuntu3
Thanks!


-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
