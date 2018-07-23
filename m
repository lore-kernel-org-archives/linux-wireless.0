Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47980 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388022AbeGWNjo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 09:39:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 23 Jul 2018 18:08:41 +0530
From: Govind Singh <govinds@codeaurora.org>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: bjorn.andersson@linaro.org, david.brown@linaro.org,
        andy.gross@linaro.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 0/6] *** Add support for wifi QMI client handshakes ***
In-Reply-To: <20180719175105.GA2633@centauri.lan>
References: <20180706085622.27945-1-govinds@codeaurora.org>
 <20180719175105.GA2633@centauri.lan>
Message-ID: <14acf06c481a2fd077ccc0823bd6e046@codeaurora.org> (sfid-20180723_143903_540177_AB497398)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Niklas,

Thanks for the review.

On 2018-07-19 23:21, Niklas Cassel wrote:
> On Fri, Jul 06, 2018 at 02:26:17PM +0530, Govind Singh wrote:
>> Add QMI client handshakes for Q6 integrated WLAN connectivity 
>> subsystem.
>> This module is responsible for communicating WLAN control messages to 
>> FW
>> over QMI interface. This patch series enables the qmi handshakes 
>> required for
>> WCN3990 chipset.
> 
> (cut)
> 
> Hello Govind,
> 
> I ran make W=1, sparse, and checkpatch on your new iteration of 
> patches.
> (I didn't do a full manual review this time, since I did that last 
> time.)
> 
> Building with warnings and checkpatch looks good,
> but sparse reports the two following warnings:
> 
>   CHECK   drivers/net/wireless/ath/ath10k//qmi.c
> drivers/net/wireless/ath/ath10k//qmi.c:935:29: warning: incorrect type
> in assignment (different address spaces)
> drivers/net/wireless/ath/ath10k//qmi.c:935:29:    expected void *msa_va
> drivers/net/wireless/ath/ath10k//qmi.c:935:29:    got void [noderef] 
> <asn:2>*
> 

Fixed in v4 version.

> and
> 
> drivers/net/wireless/ath/ath10k//snoc.c:76:22: warning: incorrect type
> in initializer (different base types)
> drivers/net/wireless/ath/ath10k//snoc.c:76:22:    expected restricted
> __le16 [usertype] reg_offset
> drivers/net/wireless/ath/ath10k//snoc.c:76:22:    got int
> drivers/net/wireless/ath/ath10k//snoc.c:77:19: warning: incorrect type
> in initializer (different base types)
> drivers/net/wireless/ath/ath10k//snoc.c:77:19:    expected restricted
> __le16 [usertype] ce_id
> drivers/net/wireless/ath/ath10k//snoc.c:77:19:    got int
> drivers/net/wireless/ath/ath10k//snoc.c:77:22: warning: incorrect type
> in initializer (different base types)
> drivers/net/wireless/ath/ath10k//snoc.c:77:22:    expected restricted
> __le16 [usertype] reg_offset
> drivers/net/wireless/ath/ath10k//snoc.c:77:22:    got int
> drivers/net/wireless/ath/ath10k//snoc.c:78:19: warning: incorrect type
> in initializer (different base types)
> drivers/net/wireless/ath/ath10k//snoc.c:78:19:    expected restricted

Fixed in v4 version.

Thanks,
Govind
