Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16725 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab1LINn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 08:43:59 -0500
Date: Fri, 9 Dec 2011 15:41:09 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Haohui Liao <liaohaohui@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] Wireless stalled after a few minutes with Linux
 Kernel 3.1
Message-ID: <20111209134109.GA4887@jouni.qca.qualcomm.com> (sfid-20111209_144403_822846_6F9EEFB0)
References: <CAHW5WCL2V=wh43YYbiMo+rnh=-g4fobKEZHrCLvW03Q73=gzYA@mail.gmail.com>
 <4EC7E739.4080404@broadcom.com>
 <CAHW5WCLUefvgvRkgz7Nr+Rwu6_96t7EVVB33U0ED5g9a0cHFXw@mail.gmail.com>
 <CAHW5WCK7SU8CJRM8pLy9omEtrPu0_ES=SxWfYEWt30NCwBGEZw@mail.gmail.com>
 <CAHW5WCJhwGSM74nN5ivoEgP98y_hbbOB8yDO9+2ahhy2B4H7yw@mail.gmail.com>
 <20111205103751.GA3775@jouni.qca.qualcomm.com>
 <CAHW5WCLOk6b5HSYS-mtqgoS6mvdCOzR4NUL_ZpmzM46CTsreRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHW5WCLOk6b5HSYS-mtqgoS6mvdCOzR4NUL_ZpmzM46CTsreRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 09, 2011 at 09:07:17PM +0800, Haohui Liao wrote:
> >> Just wondering if I am the only one still doing the following from command line
> >> to connect to wifi?
> >
> > I'm sure you are not the only one.. And in this particular
> > case, I don't
> > see how that would make a difference.
> 
> It DOES.  I tried yesterday with my Fedora 16 (which is using
> kernel 3.1.2).

I understand that you see different behavior between using
NetworkManager and stating wpa_supplicant from the command line.
However, I don't think this is because of the NM vs. manual
wpa_supplicant start, but because of configuration differences. In other
words, if your wpa_supplicant.conf in the manual start case would be
identical with the way NM configured wpa_supplicant, you would most
likely see the same behavior.

> The debugging message wpa_supplicant is as follows:
> 
> WPA: Request PTK rekeying
> WPA: Sending EAPOL-Key Request (en=0 pairwise=1 ptk_set=1 len=99)
> WPA: TX EAPOL-Key-hexdump (len=99): 01 03 ...
> 
> And the is no more communication.  With Wireshark, I will
> get the following (Reference:
> https://bugs.archlinux.org/task/27406?getfile=7864):

Do you know how quickly the connection dies after the PTK rekeying
request? The snapshot from wireshark has a gap of over one minute
without any traffic, so it is difficult to say whether that is because
of there really being no traffic or for some other reasons.

If this issue is indeed triggered by this EAPOL-Key request frame, it
would be useful to know what AP you are using. If I understood
correctly, it is the device with Shenzhen OUI in the MAC address. Do you
have a more detailed model number for the device?

It is interesting the hear that you see a difference between two kernel
versions. I could understand that if the process would actually go
through rekeying, but in this particular case, it looks like the AP just
refuses to do anything with the EAPOL-Key frame and as such, the
kernel/driver difference should not really have mattered.

> I am not sure if the term stall is correct.  But
> wpa_supplicant seems to be hanging there asking (ARP protocol)
> for response from my router but the router seems to be deaf
> and is not responding.  So the ONLY way for me to get back
> a connection is to kill the wpa_supplicant daemon and
> the connection resumes.

The ARP request is not from wpa_supplicant, but something else in the
system. wpa_supplicant not actually send any IP packets through the
connection. The EAPOL-Key Request was indeed from wpa_supplicant and for
some reason, the AP did not seem to react to it (it should have sent
EAPOL-Key msg 1/4). It is a bit difficult to figure out why exactly this
is happening, but this could be some kind of combination of a bug in the
AP and state or keys getting mixed up between the AP and station. Most
stations do not really use the explicit PTK rekeying request that you
happened to have enabled in this case and as such, I would not be too
surprised if that does not get tested properly with all APs.

If you would happen to have another WLAN device that could capture
frames in wireless sniffer mode (i.e., full IEEE 802.11 headers and not
just the data frames from the station), that could provide additional
information here.

> # WPA-Personal(PSK) with TKIP and enforcement for frequent PTK rekeying
> 
> I just change the WPA-PSK to WPA2 and everything just works.
> So I thought I got things correct.   Apparently this is not
> the case.  The PTK just happens to come from the
> configuration.

Well, this is a valid configuration in theory, but not really something
that is normally used and I would recommend using WPA2 with CCMP and
leaving out the PTK rekeying (which is really just a workaround for not
so secure TKIP).

-- 
Jouni Malinen                                            PGP id EFC895FA
