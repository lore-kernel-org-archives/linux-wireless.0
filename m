Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111Ab3IYMm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 08:42:58 -0400
Message-ID: <1380113275.7555.18.camel@dcbw.foobar.com> (sfid-20130925_144318_257278_090D8897)
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 25 Sep 2013 07:47:55 -0500
In-Reply-To: <524215AD.6060300@lwfinger.net>
References: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com>
	  <522E4315.4040806@lwfinger.net> <1378764913.31180.9.camel@dcbw.foobar.com>
	 <524215AD.6060300@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-24 at 17:43 -0500, Larry Finger wrote:
> On 09/09/2013 05:15 PM, Dan Williams wrote:
> > On Mon, 2013-09-09 at 16:52 -0500, Larry Finger wrote:
> 
> >> I have been running rtl8192cu for the past 24 hours without a permanent
> >> disconnect. Under NetworkManager, I see some reason 7 deauthentications, but
> >
> > Running wpa_supplicant with debugging on might shed some light on these;
> > basically:
> >
> > mv /usr/sbin/wpa_supplicant /
> > killall -TERM wpa_supplicant
> > /wpa_supplicant -dddtu <piped to your favorite log file>
> >
> > and NM should automatically reconnect, and then we can figure out what's
> > going on in the supplicant.
> 
> Dan,
> 
> The log of wpa_supplicant associated with the reason 7 disconnects are as follows:

So reason 7 is "Incorrect frame type or subtype received from
unassociated station" which seems like the AP thinks we got
disconnected, and would seem to be a driver/mac80211 issue still, right?

> 1380060983.255499: RTM_NEWLINK: operstate=1 ifi_flags=0x1003 ([UP])
> 1380060983.255516: RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan3' added
> 1380060983.255588: nl80211: if_removed already cleared - ignore event
> 1380060983.255600: Ignore event for foreign ifindex 22
> 1380060983.272257: nl80211: Event message available
> 1380060983.272307: nl80211: Delete station 20:e5:2a:01:f7:ea
> 1380060983.280211: nl80211: Event message available
> 1380060983.280228: nl80211: MLME event 39
> 1380060983.280230: nl80211: MLME event frame - hexdump(len=26): c0 00 3a 01 1c 
> 65 9d 5a c3 9d 20 e5 2a 01 f7 ea 20 e5 2a 01 f7 ea 30 d2 07 00
> 1380060983.280248: wlan3: Event DEAUTH (12) received
> 1380060983.280252: wlan3: Deauthentication notification
> 1380060983.280255: wlan3:  * reason 7
> 1380060983.280258: wlan3:  * address 20:e5:2a:01:f7:ea
> 1380060983.280260: Deauthentication frame IE(s) - hexdump(len=0): [NULL]
> 1380060983.280264: wlan3: WPA: Auto connect enabled: try to reconnect (wps=0)
> 1380060983.280267: wlan3: Setting scan request: 0 sec 100000 usec
> 1380060983.280271: Added BSSID 20:e5:2a:01:f7:ea into blacklist
> 1380060983.280276: wlan3: Not rescheduling scan to ensure that specific SSID 
> scans occur
> 1380060983.280281: wlan3: CTRL-EVENT-DISCONNECTED bssid=20:e5:2a:01:f7:ea reason=7
> 1380060983.280283: wlan3: Disconnect event - remove keys

Ok, got disconnected with reason 7...

> 1380060984.471985: WPA: Group Key - hexdump(len=16): [REMOVED]
> 1380060984.471989: wlan3: WPA: Installing GTK to the driver (keyidx=1 tx=0 len=16)
> 1380060984.471991: WPA: RSC - hexdump(len=6): 61 44 1a 00 00 00
> 1380060984.472044: wpa_driver_nl80211_set_key: ifindex=22 alg=3 addr=0x492909 
> key_idx=1 set_tx=0 seq_len=6 key_len=16
> 1380060984.472051:    broadcast key
> 1380060984.473171: wlan3: WPA: Key negotiation completed with 20:e5:2a:01:f7:ea 
> [PTK=CCMP GTK=CCMP]
> 1380060984.473174: wlan3: Cancelling authentication timeout
> 1380060984.473178: wlan3: State: GROUP_HANDSHAKE -> COMPLETED
> 1380060984.473183: wlan3: CTRL-EVENT-CONNECTED - Connection to 20:e5:2a:01:f7:ea 
> completed (reauth) [id=0 id_str=]

And got reconnected after a bit more than one second.  So at least it
recovers quickly, but the question is more about why the reason 7
happened, and what frames caused it, I think.

Dan

