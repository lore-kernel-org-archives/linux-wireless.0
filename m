Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62023 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbdCPIy6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 04:54:58 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv2] ath10k: Update available channel list for 5G radio
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1487855902-32090-1-git-send-email-c_traja@qti.qualcomm.com>
References: <1487855902-32090-1-git-send-email-c_traja@qti.qualcomm.com>
To: <c_traja@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Tamizh chelvam <c_traja@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>
Message-ID: <0ad928ccfaa34e28ba8c2731ff1cc42d@euamsexm01a.eu.qualcomm.com> (sfid-20170316_095608_902809_792DFE69)
Date: Thu, 16 Mar 2017 09:54:16 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

c_traja@qti.qualcomm.com wrote:
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
> 
> If a 5 GHz radio is calibrated for operation in both
> the low band (channels 36 to 64) and high band(channels 100 to 169),
> hardware allows operations in all the listed channels. However,
> if the chip has been calibrated only for the low/high band and
> a high/low band channel is configured, due to lack of calibration
> there will be potentially invalid signal on those non calibrated channels.
> To avoid this problem this patch sets IEEE80211_CHAN_DISABLED flag for
> those non calibrated channels by using low_5ghz_chan and high_5ghz_chan
> values which we get from target through wmi service ready event.
> 
> Driver initialized flags are getting re initialized in handle_channel
> in cfg80211. So calling the function to disable the non supported channel
> from reg_notifier().
> 
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

523f6701dbab ath10k: update available channel list for 5G radio

-- 
https://patchwork.kernel.org/patch/9588297/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
