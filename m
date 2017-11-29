Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:54595 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932349AbdK2KV2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Nov 2017 05:21:28 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Luca Coelho <luca@coelho.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Sara Sharon" <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 6/6] iwlwifi: fix access to prph when transport is stopped
Date: Wed, 29 Nov 2017 10:21:22 +0000
Message-ID: <87r2sh1j31.fsf@kamboji.qca.qualcomm.com> (sfid-20171129_112141_491073_0C2F82EB)
References: <20171125153510.25359-1-luca@coelho.fi>
        <20171125153510.25359-7-luca@coelho.fi>
        <87vaht1j63.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87vaht1j63.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Wed, 29 Nov 2017 12:19:32 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Luca Coelho <luca@coelho.fi> writes:
>
>> From: Sara Sharon <sara.sharon@intel.com>
>>
>> When getting HW rfkill we get stop_device being called from two paths.
>> One path is the IRQ calling stop device, and updating op mode and
>> stack. As a result, cfg80211 is running rfkill sync work that shuts
>> down all devices (second path). In the second path, we eventually get
>> to iwl_mvm_stop_device which calls
>> iwl_fw_dump_conf_clear->iwl_fw_dbg_stop_recording, that access
>> periphery registers. The device may be stopped at this point from the
>> first path, which will result with a failure to access those
>> registers. Simply checking for the trans status is insufficient, since
>> the race will still exist, only minimized. Instead, move the stop from
>> iwl_fw_dump_conf_clear (which is getting called only from stop path)
>> to the transport stop device function, where the access is always
>> safe. This has the added value, of actually stopping dbgc before
>> stopping device even when the stop is initiated from the transport.
>>
>> Fixes: 1efc3843a4ee ("iwlwifi: stop dbgc recording before stopping
>> DMA")
>
> No need to resend because of this, but Fixes should be in one line.

Please ignore, I was too clever and forgot that I had called
gnus-article-fill-cited-article which word wraps the mail :)

--=20
Kalle Valo=
