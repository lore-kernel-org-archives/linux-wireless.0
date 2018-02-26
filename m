Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53116 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751768AbeBZRGh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 12:06:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 26 Feb 2018 22:36:35 +0530
From: periyasa@codeaurora.org
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Revert "ath10k: send (re)assoc peer command when NSS
 changed"
In-Reply-To: <aedd8281-ee1b-e5ae-2521-fd3a7a221dd6@candelatech.com>
References: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
 <aedd8281-ee1b-e5ae-2521-fd3a7a221dd6@candelatech.com>
Message-ID: <dd7bb2acd1be43346315d7bb349b45b2@codeaurora.org> (sfid-20180226_180710_526197_5ED77C16)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


> Can you share exactly which resource the firmware ran out of?  It would 
> seem to
> be a FW bug if it is leaking, so maybe it can be fixed as well...
> 

Firmware have total user_id = 528 (512 clients + 16 VAPs). Each user_id 
is allocated to peer when Firmware receive the WMI_PEER_ASSOC_CMDID 
request from host driver. Firmware free the user_id in peer delete 
operation.

Regards,
Karthikeyan P.
