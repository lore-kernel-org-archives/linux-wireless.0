Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46977 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab1CNPbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 11:31:20 -0400
Received: by wwa36 with SMTP id 36so5798155wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 08:31:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <96025834431BF6428294777AA66CB92B027A0A66420D@MAIL-2.UNINE.CH>
References: <96025834431BF6428294777AA66CB92B027A0A66420D@MAIL-2.UNINE.CH>
Date: Mon, 14 Mar 2011 21:01:18 +0530
Message-ID: <AANLkTi=iuL_=3XV3cgKSq9zx8i0KSfA+MSNpbmDPsjW-@mail.gmail.com>
Subject: Re: question about setting up mesh network
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: MONAKHOV Alexey <alexey.monakhov@unine.ch>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 11, 2011 at 7:24 PM, MONAKHOV Alexey
<alexey.monakhov@unine.ch> wrote:
> Hi guys,
>
> I have several questions about 802.11s, 802.11n and mesh networks in Linux (2.6.37.1 kernel)
> with these devices
> alix3d2 device (http://pcengines.ch/alix3d2.htm) with this card (http://pcengines.ch/dnma92.htm  Atheros AR9220  chipset).
> and I am trying to configure mesh netwroks with these commands
>
>  iw dev wlan0 interface add mesh_iface type mp mesh_id mesh_id
>  iwconfig mesh_iface essid monaale_mesh
>  ifconfig mesh_iface 192.168.3.80
>  ifconfig mesh_iface up
>
> 1.
> I am using node with 2 wi-fi interfaces - my question is how to make a bridge with these 2 interfaces? Now I set 1 channel for one interface and 2 channel for the other one and traffic goes from one interface to other without any bridge - why?
>
> 2.
> I can see that olsrd daemon is running, my question is how can I enable 802.11s routing ? (kernel was compiled with CONFIG_MAC80211_MESH=y option)
>
> 3.
> how to be sure that mesh is operationg in 802.11n mode? now the speed is 54 Mb\sec but accoring to iwconfig command I can see wlan1 IEEE 802.11abgn interface enabled.

802.11n is not supported for mesh mode. iw dev wlan0 link will be more
accurate. I don't know about other things as I am not familiar with
mesh.

>
> 4.
> how can I determine my neighbors IP addresses. i.e. I  get a list of nearest nodes with
> iw dev mesh station dump command, abd how determine IP of MAC? ( without arp cache because it is empty).
> also do you know if it is possible to determine MAC (or IP) address of the neighbor from which IP package came to my node (not the source IP by my 1-hop neighbor who forwarded package to me). As I understand there is no such information in the IP or layer2 header.
>
> thanks in advance,
> Alexey.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
