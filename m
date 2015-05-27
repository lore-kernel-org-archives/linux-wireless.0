Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbbE0Pze (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 11:55:34 -0400
Message-ID: <1432742132.15971.29.camel@redhat.com> (sfid-20150527_175538_365673_20B1812B)
Subject: Re: packet loss, disconnects and possible bug in iwlwifi
From: Dan Williams <dcbw@redhat.com>
To: Nick Dimov <dimovnike@gmail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 27 May 2015 10:55:32 -0500
In-Reply-To: <55650565.6020303@gmail.com>
References: <55605637.1080503@gmail.com>
	 <CANUX_P0OzQ45pChQxc-9WVK=7_qh6M4CcE28U6pnu5RbH-qNuQ@mail.gmail.com>
	 <55650565.6020303@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-27 at 02:44 +0300, Nick Dimov wrote:
> Hello,
> thank you for your response. I attach the full syslog since the last
> boot which contains some disconnects. I enabled debug mode for
> wpa_supplicant with -dd option (let me know if you need anything else).
> 
> I also tried connecting directly, i.e. without NetworkManager but
> manually with wpa_supplicant and I still get disconnects, howvever
> wpa_supplicant gives different logs with different drivers. Please, see
> the file wifi.log (you can see there the driver i used in
> wpa_supplicant, that log doesn't have the debug activated but let me
> know if you need that too)

So if NM isn't involved in your later runs (and it's not, looking at the
logs), then I'm not sure what the issue could be except something in the
driver.

mai 27 02:31:54 nick-G55VW wpa_supplicant[1565]: nl80211: Event message
available
mai 27 02:31:54 nick-G55VW wpa_supplicant[1565]: nl80211: Drv Event 20
(NL80211_CMD_DEL_STATION) received for wlan5
mai 27 02:31:54 nick-G55VW wpa_supplicant[1565]: nl80211: Delete station
d8:50:e6:da:1d:b4
mai 27 02:31:54 nick-G55VW kernel: wlan5: deauthenticating from
d8:50:e6:da:1d:b4 by local choice (Reason: 3=DEAUTH_LEAVING)

I don't see anything interesting around those lines, so I guess its up
to Emmanuel now...  the tracing he requests would be good to get.

Dan

> Thank you again,
> Nick.
> 
> On 25.05.2015 14:33, Emmanuel Grumbach wrote:
> > On Sat, May 23, 2015 at 1:28 PM, Nick Dimov <dimovnike@gmail.com> wrote:
> >> Hello,
> >> I recently bought the Intel 7260 AC wifi card (below is the PCI info)
> >> and the card works perfectly in windows with the latest intel driver but
> >> in linux I get deauthenticating and disconnects (reason -3) every minute
> >> or so. When these disconnects happen I get packet loss. In the attached
> >> file iwlwifi_dmesg.txt you can see the log that is produced each time a
> >> disconnect happens. I also tried connecting on 2.4Ghz but I get the same
> >> packet loss. I also put the last firmware from
> >> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git
> >> but it did not help.
> > Please increase the debug level of the supplicant. And attach the full syslog.
> >
> >> There is also another problem: In windows i can see it connecting on
> >> 860mbps, but on linux it never goes higher than 600mbps (i check this
> >> with iwconfig) and it stays somewhere on 500mbps.
> >>
> >> Can you please help me solve this?
> >> Thank you.
> >>
> >> uname -a
> >> Linux nick-laptop 3.19.0-18-generic #18-Ubuntu SMP Tue May 19 18:31:35
> >> UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> >>
> >> lspci info:
> >> 03:00.0 Network controller: Intel Corporation Wireless 7260 (rev bb)
> >>         Subsystem: Intel Corporation Dual Band Wireless-AC 7260
> >>         Flags: bus master, fast devsel, latency 0, IRQ 29
> >>         Memory at f7200000 (64-bit, non-prefetchable) [size=8K]
> >>         Capabilities: [c8] Power Management version 3
> >>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> >>         Capabilities: [40] Express Endpoint, MSI 00
> >>         Capabilities: [100] Advanced Error Reporting
> >>         Capabilities: [140] Device Serial Number d8-fc-93-ff-ff-e4-70-d7
> >>         Capabilities: [14c] Latency Tolerance Reporting
> >>         Capabilities: [154] Vendor Specific Information: ID=cafe Rev=1
> >> Len=014 <?>
> >>         Kernel driver in use: iwlwifi
> >>
> 


