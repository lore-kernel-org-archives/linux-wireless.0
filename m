Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38454 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab2HIHo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 03:44:27 -0400
Received: by pbbrr13 with SMTP id rr13so487653pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 00:44:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50227EBF.9030400@lwfinger.net>
References: <CAEOSq-Nac1-6SbfQTLCO7bkQVWgLxZE4x0oNbviyyyToPZzo5w@mail.gmail.com>
	<50227EBF.9030400@lwfinger.net>
Date: Thu, 9 Aug 2012 00:44:27 -0700
Message-ID: <CAEOSq-NsO5u9CbhtLAUk3s0Yw_cMkSw2UVoPahSO0QhCAFMRcQ@mail.gmail.com> (sfid-20120809_094431_342831_6279D838)
Subject: Re: Problems with rtl8192cu driver in Access Point mode
From: Mike Thompson <mpthompson@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 8, 2012 at 7:59 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Do you have a 3rd system that can use wireshark or kismet to capture the
> data on the air? That way we would know if the ARP responses are being lost
> inside rtl8192cu, or if they are just being badly formatted and being
> rejected by the laptop's receiver.
>
> Larry

I spent quite a while today getting a third system setup with kismet
(to capture wifi packets) and wireshark (to parse the captured data)
to try and understand what is happening to ARP packets after a station
connects with an rtl8192cu access point.

As best I can tell, I believe the ARP responses are getting lost in
the rtl8192cu driver (or higher level driver).  With kismet, I can see
the ARP request wifi packets and the same packets in tcpdump on the
access point.  In tcpdump I also see the ARP reply, but looking at the
kismet data I never to see the ARP replies as wifi packets.

Below is what the tcpdump output on the access point looks like with
the request and reply:

192.168.2.1 is the access point
192.168.2.12 is the laptop

06:37:54.692374 ARP, Request who-has 192.168.2.1 tell 192.168.2.12, length 28
06:37:54.692343 ARP, Request who-has 192.168.2.1 tell 192.168.2.12, length 28
06:37:54.692937 ARP, Reply 192.168.2.1 is-at 48:02:2a:87:de:80 (oui
Unknown), length 28
06:37:56.053595 ARP, Request who-has 192.168.2.1 tell 192.168.2.12, length 28
06:37:56.053595 ARP, Request who-has 192.168.2.1 tell 192.168.2.12, length 28
06:37:56.054158 ARP, Reply 192.168.2.1 is-at 48:02:2a:87:de:80 (oui
Unknown), length 28

The wifi traffic at the same time from kismet is below:

"56","40.857513","Hewlett-_59:0b:c5","Broadcast","ARP","92","Who has
192.168.2.1?  Tell 192.168.2.12"
"57","40.859533","","Hewlett-_59:0b:c5
(RA)","802.11","42","Acknowledgement, Flags=........"
"58","40.861631","Hewlett-_59:0b:c5","Broadcast","ARP","92","Who has
192.168.2.1?  Tell 192.168.2.12"
"59","41.858298","","Hewlett-_59:0b:c5
(RA)","802.11","42","Acknowledgement, Flags=........"
"60","41.860352","Hewlett-_59:0b:c5","Broadcast","ARP","92","Who has
192.168.2.1?  Tell 192.168.2.12"
"61","42.856317","","Hewlett-_59:0b:c5
(RA)","802.11","42","Acknowledgement, Flags=........"
"62","42.858489","Hewlett-_59:0b:c5","Broadcast","ARP","92","Who has
192.168.2.1?  Tell 192.168.2.12"
"63","44.515521","Hewlett-_59:0b:c5","Broadcast","ARP","92","Who has
192.168.2.1?  Tell 192.168.2.12"
"64","44.516703","Hewlett-_59:0b:c5","Broadcast","ARP","92","Who has
192.168.2.1?  Tell 192.168.2.12"
"65","44.519614","Hewlett-_59:0b:c5","Broadcast","ARP","92","Who has
192.168.2.1?  Tell 192.168.2.12"

I've put the kismet logs at the following URLs:

http://home.comcast.net/~michael.p.thompson/rtl8192cu/kismet_packet_dump.csv
http://home.comcast.net/~michael.p.thompson/rtl8192cu/kismet_packet_dump.pcapdump

I guess the next step is to put tracing breadcrumbs in the rtl8192cu
driver code where packets are sent out and make sure the ARP responses
are getting to the driver and perhaps see where they might be getting
tossed.

BTW, something I find curious in the rtlwifi drivers is that in file
ps.c in functions rtl_ips_nic_on() and rtl_ips_nic_off_wq_callback()
there is the following code:

        if (mac->opmode != NL80211_IFTYPE_STATION)
                return;

Does this imply that if the driver is in access point or adhoc mode
that the nic will not be turned on and off?  I'm wondering if the
packets are flowing, but the transmitter is not being turned on when
it should when driver is in access point mode.  I did try to remove
this test, but it didn't seem to impact the symptoms.

Mike
