Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38845 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1G3Sqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 14:46:55 -0400
Received: by qyk29 with SMTP id 29so377268qyk.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 11:46:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E33F30D.80807@swiss-wireless.com.ar>
References: <4E33F30D.80807@swiss-wireless.com.ar>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 30 Jul 2011 11:46:35 -0700
Message-ID: <CAB=NE6UhGqi5xcq2Gm_DfzNya+xj2xbNf4gpRbpeR2YzwW3NVQ@mail.gmail.com> (sfid-20110730_204700_302316_34CB7E90)
Subject: Re: What about long distance links in 5.8GHz with ath5k?
To: Beat Meier <mbe_ml@swiss-wireless.com.ar>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 30, 2011 at 5:03 AM, Beat Meier
<mbe_ml@swiss-wireless.com.ar> wrote:
> Hello
>
> I try to use the new ath5k drivers instead of madwifi with long distance
> links (8km-20km) at 5.8GHz
> I have not found how to configure the distance settings link in madwifi and
> I have really bad throughout
> with ath5k driver as client using wpa_supplicant.
>
> Client: Alix board with voyage-0.7.5 (wpa_supplicant 0.7.3), Radio WL54AGP23
> (168C:001B)
> Server: wrap board with voyage-0.5.0 (madwifi-0.9.4 / hostapd 0.5.5), Radio
> WL54AGP23(168C:001B)
>
> Output of the 8km link tests:
> The rate is set fix to 24M on both sites for iperf tests
>
> Signal on sta (ath5k driver): -60dbm       iperf server running on sta:
> 9Mbps
> Signal on ap (madwifi driver): -64dbm   (-65dbm noise -96)  iperf server
> running on ap: 400kbps-1.2Mbps
>
> Signal on sta (madwifi driver): -51dbm (-42dbm noise -85)   iperf server
> running on sta: 12.5Mbps
> Signal on ap (madwifi driver): -53dbm (-54dbm noise -96)   iperf server
> running on ap: 10.3Mbps
>
> If I use ath5k on server with hostapd i.e. voyage-0.7.5 the client does
> connect and disconnect there
> is no link established...
>
> Any hints/solutions/experiences?

Have you tried

        iw phy <phyname> set distance <distance>

 Luis
