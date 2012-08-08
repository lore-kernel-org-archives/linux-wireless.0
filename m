Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38647 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab2HHO7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 10:59:19 -0400
Received: by ggdk6 with SMTP id k6so127901ggd.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 07:59:19 -0700 (PDT)
Message-ID: <50227EBF.9030400@lwfinger.net> (sfid-20120808_165923_357112_39FF845B)
Date: Wed, 08 Aug 2012 09:59:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike Thompson <mpthompson@gmail.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problems with rtl8192cu driver in Access Point mode
References: <CAEOSq-Nac1-6SbfQTLCO7bkQVWgLxZE4x0oNbviyyyToPZzo5w@mail.gmail.com>
In-Reply-To: <CAEOSq-Nac1-6SbfQTLCO7bkQVWgLxZE4x0oNbviyyyToPZzo5w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2012 02:53 AM, Mike Thompson wrote:
> Hello,
>
> I'm attempting to use an rtl8192cu based USB wifi adapter in Access
> Point mode with the hostapd software on a very small 3-chip iMX233 ARM
> system.  I can run the adapter fine using the driver in station mode
> and I'm able to connect to wifi network.  However, I'm not having much
> luck running the adapter in Access Point mode.  I've seen hints in the
> Linux Wireless email archives that there seems to be issues with the
> rtlwifi/rtl8192cu driver in access point mode.  Has anyone had success
> with this driver in access point mode?
>
> Basically, a remote station (a Windows laptop in this case) can
> connect to the rtl8192cu based access point configured as an open
> network.  However, I'm unable to ping from the laptop to the access
> point or back the other way.  Using tcpdump on the access point, I can
> see the ARP requests from the laptop arriving on the access point and
> the response being sent, but the laptop never seems to receive the ARP
> response.  Likewise, the ARP requests from the access point never seem
> to arrive at laptop.  However, if I manually create entries in the ARP
> tables for each device, I can then ping and other traffic will begin
> to flow over the wireless connection without apparent problems -- even
> subsquent ARP requests are passed.  It's almost as if regular IP
> packets can be transmitted from the station, but ARP type packets
> won't flow until IP packets have proceeded the ARP packets which won't
> occur until the ethernet/IP addressing has been resolved.
>
> I'm currently using a very recent compat-wireless driver from
> 2012-07-03 with an older 2.6.35 kernel.  I've tried at least three
> prior versions of the rtlwifi/rtl8192cu driver (between 2.6.35 to
> 3.5), but they all exhibit the same symptom.
>
> Any hints on where I can begin debugging the issue?

Do you have a 3rd system that can use wireshark or kismet to capture the data on 
the air? That way we would know if the ARP responses are being lost inside 
rtl8192cu, or if they are just being badly formatted and being rejected by the 
laptop's receiver.

Larry

