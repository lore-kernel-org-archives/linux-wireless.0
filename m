Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60846 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756046AbeDXIJS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 04:09:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: add dynamic vlan support
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
Date: Tue, 24 Apr 2018 11:09:13 +0300
In-Reply-To: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
        (Manikanta Pubbisetty's message of "Fri, 20 Apr 2018 19:27:33 +0530")
Message-ID: <87r2n5auvq.fsf@kamboji.qca.qualcomm.com> (sfid-20180424_100935_301087_46D88A40)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Manikanta Pubbisetty <mpubbise@codeaurora.org> writes:

> Mutlicast/broadcast traffic destined for a particular vlan group will
> always be encrypted in software. To enable dynamic VLANs, it requires
> driver support for sending software encrypted packets.
>
> In ath10k, sending sw encrypted frames is allowed only when we insmod
> the driver with cryptmode param set to 1, this configuration disables
> hardware crypto and enables RAW mode implicitly. Since, enabling raw
> mode has performance impact, this cannot be considered as an ideal
> solution for supporting VLANs in the driver.
>
> As an alternative take, in this approach, cryptographic keys for
> unicast traffic(per peer PTKs) and keys for non-vlan group traffic
> will be configured in hardware, allowing hardware encryption for unicast
> and non-vlan group traffic. Only vlan group traffic will be encrypted in
> software and pushed to the target with encap mode set to RAW in the TX
> descriptors.
>
> Not all firmwares can support this type of key configuration(having few
> keys installed in hardware and few only in software); for this purpose a
> new WMI service flag "WMI_SERVICE_PER_PACKET_SW_ENCRYPT" is introduced to
> advertise this support.
>
> Also, adding the logic required to send sw encrypted frames in raw mode.
>
> Tested this change on QCA9984(firmware version 10.4-3.5.3-00057).
>
> Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>

Your name in patchwork is wrong and hence my script uses the wrong
name. Please fix it by registering to patchwork[1] where it's possible
to change your name during registration, but only one time. If that
doesn't work then send a request to helpdesk@kernel.org and the admins
can fix it.

[1] https://patchwork.kernel.org/register/

-- 
Kalle Valo
