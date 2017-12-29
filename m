Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 4.mo68.mail-out.ovh.net ([46.105.59.63]:54861 "EHLO
        4.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdL2TQN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 14:16:13 -0500
Received: from player750.ha.ovh.net (b6.ovh.net [213.186.33.56])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id 4BCB5AD5B2
        for <linux-wireless@vger.kernel.org>; Fri, 29 Dec 2017 19:00:05 +0100 (CET)
Reply-To: alexander@wetzel-home.de
Subject: Re: ath9k dropping connections
To: =?UTF-8?Q?Fl=c3=a1vio_Silveira?= <flavioguiraldo@gmail.com>,
        linux-wireless@vger.kernel.org
References: <f5b539a5-5365-7a1d-101d-591b5face78a@gmail.com>
From: Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <e04a6de7-4582-d0be-75d7-ce27eb621a1f@wetzel-home.de> (sfid-20171229_201620_528243_35FE7089)
Date: Fri, 29 Dec 2017 18:59:56 +0100
MIME-Version: 1.0
In-Reply-To: <f5b539a5-5365-7a1d-101d-591b5face78a@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I guess there are quite some potential issues which could cause that.
Since you do not see any error logs one of them could be the WPA rekey IV poisoning one I encountered in the past.

Do you have wpa rekey enabled? If so please check if disabling it fixes the issue for you.
Assuming you are only using a WPA passoword and not EAP you can check if you have rekey enabled from a CLI on the router with the folowing command:
"uci show wireless | grep wpa_pair_rekey"

You have to delete any config statements found by the command and restart the router (or wifi) to apply the changes.

If that helps, at least one STA is sending frames using wrong IV's and tricks the other end into dropping valid frames.
In that case I can offer some options how to work around that, but I'm not aware of a real fix and disabling rekey is still probably the best...

Regards,

Alexander

Am 22.12.2017 um 01:12 schrieb Flávio Silveira:
> Good evening,
> 
>   I have a wireless router running LEDE Reboot (SNAPSHOT, r5445-04127f0fec), with kernel 4.9.65 and I'm seeing connections being dropped without any error in dmesg. To fix I have to restart wifi by issuing "wifi down; wifi up"
> 
>   It was previously running OpenWrt Barrier Breaker and was presenting the same issue, except it would give me an error similar to this one: "ath: phy0: Failed to stop TX DMA, queues=0x005!"
> 
>   After doing some research it seems this error is related to environment interference and it was fixed in later kernel versions, the reason I gave LEDE a try. It makes sense, because this router worked wonderfully for at least a year before giving this issue.
> 
>   The reason I am sending this e-mail is to receive suggestions on how can I debug it properly, because, as pointed above, dmesg shows no errors.
> 
> Regards,
>   Flavio Silveira
