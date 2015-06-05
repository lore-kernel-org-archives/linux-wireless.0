Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38039 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbFEFl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 01:41:58 -0400
Received: by wibdq8 with SMTP id dq8so7056190wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2015 22:41:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A31901A71F95@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A31901A71F95@sbs2003.acksys.local>
Date: Fri, 5 Jun 2015 07:41:56 +0200
Message-ID: <CA+BoTQkES9g3PejUbx4D6MtQcSA4pAT83yrLK71zVC0tWYovLA@mail.gmail.com> (sfid-20150605_074203_634954_F371748D)
Subject: Re: ATH10K and VLAN
From: Michal Kazior <michal.kazior@tieto.com>
To: Cedric VONCKEN <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 June 2015 at 16:46, Cedric VONCKEN <cedric.voncken@acksys.fr> wrote:
>         I'm testing to send a VLAN frame through ATH10K device.
>         I'm using compat wireless 2015-03-09 from openWRT. The ATH10K firmware used is 10.2.4.45
>
>         My test platform is:
>                 Pc1 : IP 10.101.4.3 (without VLAN)
>                         VLAN 1 : IP 192.168.5.1
>
>                 Equipment in AP mode. The netdev is bridged with eth0
>
>                 Equipment in client mode with WDS mode enables. The client is connected to the AP. The netdev is bridged with eth0.
>                 AP and client use ATH10K wireless card.
>
>                 PC2: IP 10.101.4.4 (without VLAN)
>                         VLAN 1 : IP 192.168.5.2
>
>                 The PC1 is connected to the equipment in AP mode and the PC2 is connected to the equipment in client mode.
>
>
>         I can ping from PC1 to PC2 without vlan (ping 10.101.4.4).
>         I cannot ping from PC1 to PC2 with VLAN.
>         With tcpdump I checked the vlan frame is sent to the netdev but this frame is not send to the air.
>
>         Is it possible to send a VLAN frame through ATH10K? If no, is it a driver limitation or firmware limitation?

I'm not sure if IFTYPE_WDS works with ath10k but IFTYPE_AP_VLAN works
fine for me on latest github.com/kvalo/ath master branch. Can you test
if it works with no encryption, please?


Michał
