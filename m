Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:41576 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752483AbdLKI60 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 03:58:26 -0500
Received: by mail-yb0-f193.google.com with SMTP id x83so196096ybg.8
        for <linux-wireless@vger.kernel.org>; Mon, 11 Dec 2017 00:58:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171209003452.GA3441@builder>
References: <1512725730-19188-1-git-send-email-loic.poulain@linaro.org> <20171209003452.GA3441@builder>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Mon, 11 Dec 2017 09:57:45 +0100
Message-ID: <CAMZdPi9N69vfFxDgEGQXowUd7accK-mCLCGS5Cg1d4p8LvZ6wA@mail.gmail.com> (sfid-20171211_095831_141631_5E34E484)
Subject: Re: [PATCH] wcn36xx: Add hardware scan offload support
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: kvalo@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        Eugene Krasnikov <k.eugene.e@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bjorn,

On 9 December 2017 at 01:34, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
>
>> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> [..]
>> +static int wcn36xx_smd_hw_scan_ind(struct wcn36xx *wcn, void *buf, size_t len)
>> +{
>> +     struct wcn36xx_hal_scan_offload_ind *rsp = buf;
>> +     struct cfg80211_scan_info scan_info = {};
>> +
>> +     if (len != sizeof(*rsp)) {
>> +             wcn36xx_warn("Corrupted delete scan indication\n");
>> +             return -EIO;
>> +     }
>> +
>> +     wcn36xx_dbg(WCN36XX_DBG_HAL, "scan indication (type %x)", rsp->type);
>> +
>> +     switch (rsp->type) {
>> +     case WCN36XX_HAL_SCAN_IND_FAILED:
>> +             scan_info.aborted = true;
>> +     case WCN36XX_HAL_SCAN_IND_COMPLETED:
>> +             mutex_lock(&wcn->scan_lock);
>
> Grabbing this mutex with DEBUG_ATOMIC_SLEEP causes issues, but that's
> because the locking in ind_smd_work() is to excessive. Will reply with a
> fix for this.

Oops you're right, thanks for the patch.

Regards,
Loic
