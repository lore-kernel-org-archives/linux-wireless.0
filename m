Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:35010 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751625AbdFGHwe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Jun 2017 03:52:34 -0400
Received: by mail-qt0-f172.google.com with SMTP id w1so2888063qtg.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jun 2017 00:52:34 -0700 (PDT)
Subject: Re: Wifi-Event for when initial 4-way completes?
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
References: <854f7995-2cc0-3649-2c94-9ef3c219fb73@candelatech.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <30b6091b-f74f-fabf-b0ed-ef1c1b78ef72@broadcom.com> (sfid-20170607_095248_303807_F3419559)
Date: Wed, 7 Jun 2017 09:52:31 +0200
MIME-Version: 1.0
In-Reply-To: <854f7995-2cc0-3649-2c94-9ef3c219fb73@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



+ hostap list

On 6/7/2017 2:46 AM, Ben Greear wrote:
> I have been tracking down a nasty EAPOL related bug in ath10k, and found 
> something that may be peripheral, or maybe
> it is significant.
> 
> My logic is basically to kick supplicant, watch 'iw events', and then 
> when I see something
> like "sta62 (phy #5): connected to 00:0e:8e:f8:73:96", I consider it 
> connected and start
> dhcpd.
> 
> But, it appears that the 'connected' message comes out before the EAPOL 
> 4-way completes, so
> I am starting dhclient before the encryption is really set up properly.  
> At best, this slows
> things down and makes dhclient have to retry.
> 
> Is there some existing event or state I can probe to determine when the 
> initial 4-way is complete?
> 
> In case there is not, maybe that event would be worth adding?
> 
> Or, should I hack on supplicant instead and grab the info out of it 
> somehow?

The completion of the 4-way handshake is a supplicant state. Reaching 
that state the PTK is set in the driver. It fires a CTRL-EVENT to the 
wpa_s control interface. Actually found a python script eapol_test.py in 
hostap repo that catches that event. So you may check it out.

Gr. AvS
