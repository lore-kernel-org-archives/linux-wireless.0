Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:43774 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbYEKCt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 22:49:58 -0400
Received: from X61.NetworkingUnlimited.com
 (ool-43503a0c.dyn.optonline.net [67.80.58.12]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0K0O00KHZNV9HS80@mta5.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Sat, 10 May 2008 22:49:57 -0400 (EDT)
Date: Sat, 10 May 2008 22:49:39 -0400
From: Vincent C Jones <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -	2.6.26-rc1
 kernel
In-reply-to: <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-id: <1210474179.3787.31.camel@X61.NetworkingUnlimited.com> (sfid-20080511_045028_907185_63CC7409)
MIME-version: 1.0
Content-type: text/plain
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805091423y680b6706ta124eaaed73c81c0@mail.gmail.com>
 <1210376474.3856.7.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sun, 2008-05-11 at 01:06 +0300, Tomas Winkler wrote:
> On Sun, May 11, 2008 at 12:48 AM, Vincent C Jones
> <v.jones@networkingunlimited.com> wrote:
> >
> > On Sat, 2008-05-10 at 21:56 +0300, Tomas Winkler wrote:
> >> >
> >> > May be more to this than just missing 802.11a channel reporting...
> >> > walked to within range of a NetGear dual-band 802.11N 5GHz/11G 2.4GHz AP
> >> > and could not even see the 802.11A side of the AP, (while another
> >> > machine was associated with it, so both halves of the AP were up).
> >> > I associated on the G channel, then tried to force an association on the
> >> > A channel by setting the frequency with iwconfig. At some point, I got
> >> > the following (note that I could still associate with the G channel when
> >> > done):
> >> >
> >> > ay 10 11:20:04 X61 kernel: ------------[ cut here ]------------
> >> > May 10 11:20:04 X61 kernel: WARNING: at
> >> > include/../net/mac80211/rate.h:153 rs_get_rate+0x159/0x194 [iwl4965]()
> >>
> >> Something went wrong with station management.  Do you use same BSSID
> >> on the both interfaces A and G?
> >>
> >> Thanks
> >> Tomas
> >
> > No.
> > 1st Floor-NetGear Dual Band AGN A/N on 36, BSSID = NetworkingUnlimited
> >                                  G on 11, BSSID = NetworkingUnlimited-G
> > 2nd Floor - 3Com POE A/G in A modeA on 48, BSSID = NetworkingUnlimited
> >
> 
> I'm asking for BSSID like mac address not SSID like network name
> Thanks
> Tomas

Oops, my bad... According to iwlist scan under 2.6.25, the BSSIDs are
unique:

          Cell 04 - Address: 00:1E:2A:6C:93:D9
                    ESSID:"NetworkingUnlimited-G"
                    Mode:Master
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=93/100  Signal level=-36 dBm  Noise
level=-127 dBm
                    Encryption key:on
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
                              12 Mb/s; 48 Mb/s
                    Extra:tsf=00000004af8444ec
          Cell 05 - Address: 00:1E:2A:6C:93:D8
                    ESSID:"NetworkingUnlimited"
                    Mode:Master
                    Channel:36
                    Frequency:5.18 GHz (Channel 36)
                    Quality=79/100  Signal level=-55 dBm  Noise
level=-127 dBm
                    Encryption key:on
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (2) : CCMP TKIP
                        Authentication Suites (1) : PSK
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                              36 Mb/s; 48 Mb/s; 54 Mb/s
                    Extra:tsf=00000004af3660e3


