Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42255 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab2HHHxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 03:53:14 -0400
Received: by vcbfk26 with SMTP id fk26so468516vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 00:53:14 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Aug 2012 00:53:13 -0700
Message-ID: <CAEOSq-Nac1-6SbfQTLCO7bkQVWgLxZE4x0oNbviyyyToPZzo5w@mail.gmail.com> (sfid-20120808_095318_123669_C3330217)
Subject: Problems with rtl8192cu driver in Access Point mode
From: Mike Thompson <mpthompson@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm attempting to use an rtl8192cu based USB wifi adapter in Access
Point mode with the hostapd software on a very small 3-chip iMX233 ARM
system.  I can run the adapter fine using the driver in station mode
and I'm able to connect to wifi network.  However, I'm not having much
luck running the adapter in Access Point mode.  I've seen hints in the
Linux Wireless email archives that there seems to be issues with the
rtlwifi/rtl8192cu driver in access point mode.  Has anyone had success
with this driver in access point mode?

Basically, a remote station (a Windows laptop in this case) can
connect to the rtl8192cu based access point configured as an open
network.  However, I'm unable to ping from the laptop to the access
point or back the other way.  Using tcpdump on the access point, I can
see the ARP requests from the laptop arriving on the access point and
the response being sent, but the laptop never seems to receive the ARP
response.  Likewise, the ARP requests from the access point never seem
to arrive at laptop.  However, if I manually create entries in the ARP
tables for each device, I can then ping and other traffic will begin
to flow over the wireless connection without apparent problems -- even
subsquent ARP requests are passed.  It's almost as if regular IP
packets can be transmitted from the station, but ARP type packets
won't flow until IP packets have proceeded the ARP packets which won't
occur until the ethernet/IP addressing has been resolved.

I'm currently using a very recent compat-wireless driver from
2012-07-03 with an older 2.6.35 kernel.  I've tried at least three
prior versions of the rtlwifi/rtl8192cu driver (between 2.6.35 to
3.5), but they all exhibit the same symptom.

Any hints on where I can begin debugging the issue?

Thanks,

Mike Thompson
