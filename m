Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43300 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728934AbeGaXTT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 19:19:19 -0400
Subject: Re: [PATCH v4 3/3] mac80211: Fix PTK rekey freezes and cleartext
 leaks
To: Alexander Wetzel <alexander@wetzel-home.de>,
        johannes@sipsolutions.net
References: <20180731201030.2619-1-alexander@wetzel-home.de>
 <20180731201030.2619-4-alexander@wetzel-home.de>
Cc: linux-wireless@vger.kernel.org, s.gottschall@dd-wrt.com,
        denkenz@gmail.com
From: Ben Greear <greearb@candelatech.com>
Message-ID: <234090b7-f260-e5c9-d933-8ce5240d5689@candelatech.com> (sfid-20180731_233704_445985_ABCD6B5F)
Date: Tue, 31 Jul 2018 14:36:57 -0700
MIME-Version: 1.0
In-Reply-To: <20180731201030.2619-4-alexander@wetzel-home.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2018 01:10 PM, Alexander Wetzel wrote:
> Rekeying a pairwise key with encryption offload and only keyid 0 had
> multiple races. Two of them could freeze the wlan connection till
> rekeyed again and the third could send out packets in clear which should
> have been encrypted.
>
>  1) Freeze caused by incoming packets:
>     If the local STA installed the key prior to the remote STA we still
>     had the old key active in the hardware while mac80211 was already
>     operating on the new key.
>     The card could still hand over packets decoded with the old key to
>     mac80211, bumping the new PN (IV) value to an incorrect high number
>     and tricking the local replay detection to later drop all packets
>     really sent with the new key.
>
>  2) Freeze caused by outgoing packets:
>     If mac80211 was providing the PN (IV) and handed over a cleartext
>     packets for encryption to the hardware prior to a key change the
>     driver/card could have processed the queued packets after switching
>     to the new key.
>     This immediately bumped the PN (IV) value on the remote STA to
>     an incorrect high number, which also froze the connection.
>
>  3) Clear text leak:
>     Removing encryption offload from the card cleared the encryption
>     offload flag only after the card had removed the key. Packets handed
>     over between that were send out unencrypted.
>
> To prevent those issues we now stop queuing packets to the driver while
> replacing the key, replace the key first in the HW and stop/block new
> aggregation sessions during the rekey.

I guess the replace_key logic will have to flush the tx hardware/firmware
queues and any other packets currently owned by the driver before it can
replace the key?


..

> +		/* Key is beeing removed */

Looks like 'being' is mis-spelled?


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
