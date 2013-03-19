Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3029 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251Ab3CSVzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 17:55:37 -0400
Message-ID: <5148DEC9.50003@broadcom.com> (sfid-20130319_225544_707064_E246E6EE)
Date: Tue, 19 Mar 2013 22:55:21 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
cc: "Jonathan Nieder" <jrnieder@gmail.com>, 664767@bugs.debian.org,
	linux-wireless@vger.kernel.org, "Dan Williams" <dcbw@redhat.com>
Subject: Re: Brcmsmac driver woes, possible regression?
References: <20130317144603.GA4850@stt008.linux.site>
 <1363532310.3937.266.camel@deadeye.wl.decadent.org.uk>
 <20130317152428.GA4940@stt008.linux.site>
 <20130317175658.GA8181@elie.Belkin>
 <20130317182725.GA5811@stt008.linux.site>
 <20130317183344.GA8786@elie.Belkin>
 <CAKprTDFhNnGOPHUqg8Wn6Cd170KaeXj7-w-D6wS2Cc38vstt5A@mail.gmail.com>
 <20130318083752.GA6570@elie.Belkin> <51476D25.6030609@broadcom.com>
 <20130318211428.GA9136@stt008.linux.site>
 <20130318212544.GB5062@elie.Belkin>
 <CAKprTDFXV4J7cxGqNck95Cu=ncBXCfdNTir40aWRtXjpLPO6OQ@mail.gmail.com>
 <CAKprTDEddPVp+bk7RJX1Jk60b0zVHr4ghvqt0HKnY+h238t3Zw@mail.gmail.com>
In-Reply-To: <CAKprTDEddPVp+bk7RJX1Jk60b0zVHr4ghvqt0HKnY+h238t3Zw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/19/2013 05:21 PM, Camaleón wrote:
> Mar 19 17:05:28 stt300 kernel: [26034.188562] wlan0: authenticated
> Mar 19 17:05:28 stt300 kernel: [26034.192108] wlan0: associate with 00:1a:2b:97:7a:97 (try 1/3)
> Mar 19 17:05:28 stt300 NetworkManager[30971]: <info> (wlan0): supplicant interface state: authenticating -> associating
> Mar 19 17:05:30 stt300 kernel: [26036.586947] wlan0: RX AssocResp from 00:1a:2b:97:7a:97 (capab=0x411 status=0 aid=1)
> Mar 19 17:05:30 stt300 kernel: [26036.587560] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
> Mar 19 17:05:30 stt300 kernel: [26036.587576] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
> Mar 19 17:05:30 stt300 kernel: [26036.587603] wlan0: associated
> Mar 19 17:05:30 stt300 kernel: [26036.587698] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> Mar 19 17:05:30 stt300 wpa_supplicant[2855]: wlan0: Associated with 00:1a:2b:97:7a:97

Seems to be heading in the right direction, but....

> Mar 19 17:05:30 stt300 NetworkManager[30971]: <info> (wlan0): supplicant interface state: associating -> associated
> Mar 19 17:05:30 stt300 NetworkManager[30971]: <info> (wlan0): supplicant interface state: associated -> 4-way handshake
> Mar 19 17:05:32 stt300 avahi-daemon[2630]: Joining mDNS multicast group on interface wlan0.IPv6 with address fe80::ae81:12ff:fe34:6963.
> Mar 19 17:05:32 stt300 avahi-daemon[2630]: New relevant interface wlan0.IPv6 for mDNS.
> Mar 19 17:05:32 stt300 avahi-daemon[2630]: Registering new address record for fe80::ae81:12ff:fe34:6963 on wlan0.*.
> Mar 19 17:05:32 stt300 NetworkManager[30971]: <warn> Activation (wlan0/wireless): association took too long.

Here it seem to go bad again...

> Mar 19 17:05:32 stt300 NetworkManager[30971]: <info> (wlan0): device state change: config -> need-auth (reason 'none') [50 60 0]
> Mar 19 17:05:32 stt300 NetworkManager[30971]: <warn> Activation (wlan0/wireless): asking for new secrets
> Mar 19 17:05:32 stt300 kernel: [26039.005158] wlan0: deauthenticating from 00:1a:2b:97:7a:97 by local choice (reason=3)

And we get a deauth request with WLAN_REASON_DEAUTH_LEAVING.

> Mar 19 17:05:33 stt300 kernel: [26040.004150] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
> Mar 19 17:05:33 stt300 kernel: [26040.004172] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
> Mar 19 17:05:34 stt300 kernel: [26040.504402] cfg80211: Calling CRDA to update world regulatory domain
> Mar 19 17:05:34 stt300 ntpd[2611]: Listen normally on 16 wlan0 fe80::ae81:12ff:fe34:6963 UDP 123
> Mar 19 17:05:34 stt300 ntpd[2611]: peers refreshed
> Mar 19 17:05:34 stt300 wpa_supplicant[2855]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=3
> Mar 19 17:05:34 stt300 NetworkManager[30971]: <info> (wlan0): supplicant interface state: 4-way handshake -> disconnected
> Mar 19 17:05:34 stt300 NetworkManager[30971]: <warn> Couldn't disconnect supplicant interface: This interface is not connected.

I am trying to make sense of it, but it is getting late over here. Have 
a fresh look tomorrow.

Regards,
Arend

