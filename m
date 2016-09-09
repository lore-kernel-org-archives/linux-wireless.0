Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5809 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754605AbcIIMOP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 08:14:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath6kl: Allow the radio to report 0 dbm txpower without timing out
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1472537779-3723-1-git-send-email-eric.bentley@lairdtech.com>
To: Eric Bentley <eric.bentley@lairdtech.com>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <8b623c07c491428485cfbf0cf3458df5@euamsexm01a.eu.qualcomm.com> (sfid-20160909_141418_535790_0CD74AAF)
Date: Fri, 9 Sep 2016 14:14:08 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eric Bentley <eric.bentley@lairdtech.com> wrote:
> The ath6kl driver attempts to get the txpower value from the radio by first
> clearing the existing stored value and then watching the value to become
> non-zero.
> 
> APs allow setting client power to values from -127..127, but this radio
> is not capable of setting values less then 0 and so will report txpower
> as 0dbm for both negative and 0 client power values.
> 
> When the radio has txpower set to 0dbm txpower (equivalent to 1mw) the
> ath6kl_cfg80211_get_txpower() function will remain in the
> wait_event_interruptible_timeout() loop waiting for the value to be
> non-zero, and will eventually timeout. This results in a 5 second delay in
> response. However, the correct value of zero is eventually returned.
> 
> The 6004 defaults to 63dbm which is then limited by regulatory and
> hardware limits with max of 18dbm (6003 max is 16dbm), therefore we can
> use values larger then these to be able to determine when the value has
> been updated.
> 
> To correct the issue, set the value to a nonsensical value (255) and wait
> for it to change to the valid value.

Thanks, 1 patch applied to ath-next branch of ath.git:

cabd34d0e9c4 ath6kl: Allow the radio to report 0 dbm txpower without timing out

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9304907/
