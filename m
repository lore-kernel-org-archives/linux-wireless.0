Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:52431 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbbAPXX0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 18:23:26 -0500
Message-ID: <54B99BEA.9080103@erley.org> (sfid-20150117_002329_674375_07879C43)
Date: Fri, 16 Jan 2015 17:16:58 -0600
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Beat Meier <mbe_ml@swiss-wireless.com.ar>,
	"linux-wireless@vger.kernel.org >> Linux Wireless List"
	<linux-wireless@vger.kernel.org>
Subject: Re: Cannot use ap and sta mode on same interface with ath9k and kernel
 3.8.13 :-(
References: <54B990BC.1060604@swiss-wireless.com.ar>
In-Reply-To: <54B990BC.1060604@swiss-wireless.com.ar>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/16/2015 04:29 PM, Beat Meier wrote:
> Hi
>
> I'm using an WLM200NX card in master mode ath1 and want to do scanning
> on the same interface.
> I'm using ath9k on 3.8.13 kernel (voyage-linux)
>
> So I setup an additional  interface in sta mode with
>    iw phy phy1 interface add ath2 type managed
> This works but the interface is not coming up.
> I tried several things like
> auto ath2
> iface ath2 inet static
>          address 10.58.1.1
>          netmask 255.255.255.0
>          wireless-mode Managed
>          wpa-conf /etc/wpa_supplicant.conf.WPA-PSK
>
> But wpa_spplicant comes with error:
>    wpa_supplicant: /sbin/wpa_supplicant daemon failed to start
>    run-parts: /etc/network/if-pre-up.d/wpasupplicant exited with return
> code 1
>    RTNETLINK answers: Name not unique on network
>    Failed to bring up ath2.
>
> I can setup monitor mode but I want to scan to see what other equipment
> is on which channel ...
>
> What's the problem? With ath9k I cannot use ap and sta mode together???
>

You need to assign a different mac address to the new interface.

[Resend, accidentally dropped mailing list]
