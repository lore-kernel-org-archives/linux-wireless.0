Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48596 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753557AbdIDN0s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Sep 2017 09:26:48 -0400
Message-ID: <1504531606.27801.2.camel@sipsolutions.net> (sfid-20170904_152651_740840_004154B0)
Subject: Re: How can I get WDS to work? I need some help
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?H=E5vard?= Rabbe <hrabbe@me.com>,
        linux-wireless@vger.kernel.org
Date: Mon, 04 Sep 2017 15:26:46 +0200
In-Reply-To: <6B96DBC1-F290-4853-BC5F-F884727BF591@me.com> (sfid-20170823_170017_289214_D6D7BDC5)
References: <6B96DBC1-F290-4853-BC5F-F884727BF591@me.com>
         (sfid-20170823_170017_289214_D6D7BDC5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-08-23 at 17:00 +0200, Håvard Rabbe wrote:
> Hi
> 
> Im trying to get wds working. I haven’t found much documentation on
> this topic. This is what i have found: https://wireless.wiki.kernel.o
> rg/en/users/documentation/iw#setting_up_a_wds_peer
> 
> I have configured two machines with hostapd with the same config. Its
> also the same wifi card WLE200NX using the AR9280 chipset.
> 
> After APs is running I have used this commands on both AP’s with the
> other APs wifi mac address:
> 
> iw phy phy0 interface add wds0 type wds
> iw dev wds0 set peer <MAC address>
> 
> then wds0 interface is showing up
> 
> ------------------
> wds0      IEEE 802.11abgn  Mode:Repeater  Access Point: Not-
> Associated   
>           Tx-Power=20 dBm   
>           Retry short limit:7   RTS thr:off   Fragment thr:off
>           Power Management:off
> ---------------------
> 
> 
> But it says Access Point: Not-Associated
> 
> 
> I have no clue what to do next.

I think you have to do something like "iw wds0 set peer <MAC addr>" but
frankly, you're far better off using the 4-addr AP/client mode since
that allows proper feature negotiation and can use HT/VHT etc.:

https://wireless.wiki.kernel.org/en/users/documentation/iw#using_4-address_for_ap_and_client_mode

johannes
