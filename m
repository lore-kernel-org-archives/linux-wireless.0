Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:38186 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932579AbcIBQiX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 12:38:23 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v3 1/2] wcn36xx: Transition driver to SMD client
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <87mvjqz2ul.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 2 Sep 2016 09:38:11 -0700
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        wcn36xx@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Message-Id: <C322D204-A6C6-497B-BDA2-1734C775B651@holtmann.org> (sfid-20160902_183845_150058_4023920A)
References: <1472741468-24762-1-git-send-email-bjorn.andersson@linaro.org> <87mvjqz2ul.fsf@kamboji.qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

>> The wcn36xx wifi driver follows the life cycle of the WLAN_CTRL SMD
>> channel, as such it should be a SMD client. This patch makes this
>> transition, now that we have the necessary frameworks available.
>> 
>> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> [...]
> 
>> --- a/drivers/net/wireless/ath/wcn36xx/Kconfig
>> +++ b/drivers/net/wireless/ath/wcn36xx/Kconfig
>> @@ -1,6 +1,6 @@
>> config WCN36XX
>> 	tristate "Qualcomm Atheros WCN3660/3680 support"
>> -	depends on MAC80211 && HAS_DMA
>> +	depends on MAC80211 && HAS_DMA && QCOM_SMD
> 
> While I had this patch on my pending branch I noticed that I can't
> compile wcn36xx on x86 anymore. This is actually quite inconvenient, for
> example then it's easy to miss mac80211 API changes etc. Is there any
> way we could continue build testing wcn36xx on x86 (or all) platforms?

I would also like that for the btqcomsmd Bluetooth driver. Doing quick build tests on x86 would be great.

Regards

Marcel
