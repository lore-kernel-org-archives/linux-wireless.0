Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from up.icubehost.com ([185.62.36.194]:58526 "EHLO up.icubehost.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751786AbdLYNVr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Dec 2017 08:21:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 25 Dec 2017 17:56:50 +0530
From: Alagu Sankar <alagusankar@silex-india.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: silexcommon@gmail.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 03/11] ath10k_sdio: DMA bounce buffers for read write
In-Reply-To: <87lghu9247.fsf@kamboji.qca.qualcomm.com>
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
 <1506793068-27445-4-git-send-email-alagusankar@silex-india.com>
 <87lghu9247.fsf@kamboji.qca.qualcomm.com>
Message-ID: <5281f48b04f8f593ec06e72a041ec021@silex-india.com> (sfid-20171225_142157_806730_3D798E42)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-12-22 21:38, Kalle Valo wrote:
> silexcommon@gmail.com writes:
> 
>> From: Alagu Sankar <alagusankar@silex-india.com>
>> 
>> Some SD host controllers still need bounce buffers for SDIO data
>> transfers. While the transfers worked fine on x86 platforms,
>> this is found to be required for i.MX6 based systems.
>> 
>> Changes are similar to and derived from the ath6kl sdio driver.
>> 
>> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
> 
> Why is the bounce buffer needed exactly, what are the symptoms etc? To
> me this sounds like an ugly workaround for a SDIO controller driver 
> bug.

We faced problems with i.MX6. The authentication frame sent by the 
driver never reached the air. The host driver accepted the buffer, but 
did not send out the packet to the sdio module. No errors reported 
anywhere, but the buffer is not accepted due to alignment. The same 
driver however works fine without bounce buffer on x86 platform with 
stdhci drivers. To make it compliant with all host controllers, we 
introduced the bounce buffers, similar to what was done in ath6kl_sdio 
drivers.
