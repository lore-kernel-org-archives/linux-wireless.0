Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:46666 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbXHONQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 09:16:30 -0400
Message-ID: <46C2FCAB.6090607@lwfinger.net>
Date: Wed, 15 Aug 2007 08:16:27 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Turn off meaningless TKIP message when   software WEP encryption is used
References: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net> <1187136960.31200.37.camel@johannes.berg>
In-Reply-To: <1187136960.31200.37.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2007-08-13 at 17:13 -0500, Larry Finger wrote:
>> For drivers that do no hardware encryption/decryption, WEP encryption
>> works as long as IEEE80211_HW_INCLUDE_IV is not set in the flags variable.
>> With WPA encryption and IEEE80211_HW_INCLUDE_IV not set, the logs are full
>> of TKIP decrypt failure messages. Despite the messages, RX is working.
>> This patch turns off the message for this case.
> 
> This is a bit strange. What's your actual key configuration? Are you
> using TKIP at all? I suspect you're using TKIP for multicast and
> CCMP/AES for unicast and something else is actually wrong with TKIP
> leading to this.

AFAIK, I'm using WPA-PSK TKIP. My AP is a Linksys WRT54G V5. On the "Wireless Security" page, I have 
selected "WPA Personal" for the security mode and TKIP for the WPA algorithm. On my laptop, the 
connection is managed by NetworkManager. My key is stored in Kwallet and is supplied automatically, 
but NM asked for a WPA passphrase when I set it up.
> 
> Thing is, it looks as though all frames that trigger the message are
> dropped, and I'm fairly certain we don't actually want that.

> Or something in your network is actually sending bogus frames. Could you
> capture some packets with wireshark on a secondary monitor interface or
> a second device and send me a packet dump?

That is certainly possible, either in my network or that of my neighbors. A network list shows 5 
APs, two of which are mine. Only the AP in question is using WPA, 3 are using WEP, and one is 
unencrypted. I'm collecting a packet dump now using Kismet - I don't run X on my second laptop as it 
has too little memory and is slow besides. I'll send you that file off-list. I have filtered out 
beacons. I hope that is OK.

Thanks,

Larry
