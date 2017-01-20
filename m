Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47812 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752217AbdATOp1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 09:45:27 -0500
Message-ID: <58822285.30008@candelatech.com> (sfid-20170120_154535_103813_5097F072)
Date: Fri, 20 Jan 2017 06:45:25 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>,
        linux-wireless@vger.kernel.org
CC: kvalo@codeaurora.org
Subject: Re: [RFC 0/1] ath9k: Frame corruption simulator
References: <1484922570-23659-1-git-send-email-Wojciech.Dubowik@neratec.com>
In-Reply-To: <1484922570-23659-1-git-send-email-Wojciech.Dubowik@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/20/2017 06:29 AM, Wojciech Dubowik wrote:
> I have been debugging customer reported timeout and loss of
> communication and I have relaized that I don't have such a lossy
> environment available in the lab. To speed up debugging I have
> written frame corruption simulator which will allow me to
> totally loose specific types of packets. I have been mostly
> using it with the mask 0x5000 which drops some EAPOL
> and deauthentication frames. This way I was able to test better
> timeouts and fail paths.
> At the moment only management, null function and EAPOL frames
> are supported. One can add more if necessary.

Would it be worth having a unique percentage configurable for each
of the selected packet types?

How about moving this up into mac80211 so other drivers could
be supported as well?  Couldn't you just drop the frames instead
of corrupting their checksum?  That would work with things like ath10k
as well.

I would like to have something like this, but with the added ability
to corrupt specific things like information-elements in management
frames to better test the receiver's packet parsing and error checking
logic.  For this feature, checksum would not be corrupted.

Thanks,
Ben

>
> Wojciech Dubowik (1):
>    ath9k: Add frame corruption simulator
>
>   drivers/net/wireless/ath/ath9k/Kconfig |  15 +++++
>   drivers/net/wireless/ath/ath9k/ath9k.h |   7 +++
>   drivers/net/wireless/ath/ath9k/debug.c |  49 +++++++++++++++
>   drivers/net/wireless/ath/ath9k/xmit.c  | 106 +++++++++++++++++++++++++++++++++
>   4 files changed, 177 insertions(+)
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
