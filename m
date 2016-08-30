Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32084 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbcH3G25 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Aug 2016 02:28:57 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Eric Bentley <eric.bentley@lairdtech.com>
CC: "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Allow the radio to report 0 dbm txpower without
 timing out
Date: Tue, 30 Aug 2016 06:28:39 +0000
Message-ID: <871t16ahyh.fsf@kamboji.qca.qualcomm.com> (sfid-20160830_082901_891762_10BA0DD0)
References: <1472537779-3723-1-git-send-email-eric.bentley@lairdtech.com>
In-Reply-To: <1472537779-3723-1-git-send-email-eric.bentley@lairdtech.com>
        (Eric Bentley's message of "Tue, 30 Aug 2016 02:16:19 -0400")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eric Bentley <eric.bentley@lairdtech.com> writes:

> The ath6kl driver attempts to get the txpower value from the radio by fir=
st
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
> non-zero, and will eventually timeout. This results in a 5 second delay i=
n
> response. However, the correct value of zero is eventually returned.
>
> The 6004 defaults to 63dbm which is then limited by regulatory and
> hardware limits with max of 18dbm (6003 max is 16dbm), therefore we can
> use values larger then these to be able to determine when the value has
> been updated.
>
> To correct the issue, set the value to a nonsensical value (255) and wait
> for it to change to the valid value.
>
> --
> Tested on both 6003 and 6004 based radios.  Return value of zero is
> correctly returned in an expected amount of time (similar to when
> returning non-zero values) when AP client power is set to both 0 and
> negative values.
>
> Signed-off-by: Eric Bentley <eric.bentley@lairdtech.com>

This is perfect now, thanks. I'll just remove the "--" line from the
commit log, that looks a bit weird.

--=20
Kalle Valo=
