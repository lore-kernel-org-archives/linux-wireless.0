Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37969 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbcG0NMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 09:12:07 -0400
Received: by mail-wm0-f42.google.com with SMTP id o80so61856117wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2016 06:12:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5798B042.4070604@qti.qualcomm.com>
References: <1469623006-13178-1-git-send-email-vthiagar@qti.qualcomm.com>
 <1469623006-13178-3-git-send-email-vthiagar@qti.qualcomm.com>
 <CA+BoTQ=kUP-Qtw1EWKKfM_aGtJS_4oQdz4tqD5tiJkF_k3-vOA@mail.gmail.com> <5798B042.4070604@qti.qualcomm.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 27 Jul 2016 15:12:04 +0200
Message-ID: <CA+BoTQnc5x1+YoW=n3e+iXg13HwZaP_BOS_mJWzOWBY+9s=dAw@mail.gmail.com> (sfid-20160727_151211_287846_44BBD484)
Subject: Re: [PATCH 2/4] ath10k: Add provision for Rx descriptor abstraction
To: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 July 2016 at 14:59, Thiagarajan, Vasanthakumar
<vthiagar@qti.qualcomm.com> wrote:
> On Wednesday 27 July 2016 06:13 PM, Michal Kazior wrote:
>> On 27 July 2016 at 14:36, Vasanthakumar Thiagarajan
[...]
>>> --- a/drivers/net/wireless/ath/ath10k/core.c
>>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>>> @@ -68,6 +68,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>>>                          .board_size = QCA988X_BOARD_DATA_SZ,
>>>                          .board_ext_size = QCA988X_BOARD_EXT_DATA_SZ,
>>>                  },
>>> +               .hw_rx_desc_ops = &qca988x_rx_desc_ops,
>> [...]
>>> +struct ath10k_hw_rx_desc_ops {
>>> +       int (*rx_desc_get_l3_pad_bytes)(struct htt_rx_desc *rxd);
>>> +};
>>
>> Benjamin is trying to implement coverage class by poking hw registers
>> over firmware's head [1]. I'm thinking the hw_rx_desc_ops could be
>> generalized to hw_ops so it can be used for doing hw-specific hacks as
>> well. What do you think?
>
> Sure. Instead of reworking this patch set, can this be done in a separate patch?.

I don't really mind especially since there's not much comments on his work yet.


Michał
