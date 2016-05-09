Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46187 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbcEIOVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 10:21:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Jaap Jan Meijer <jjmeijer88@gmail.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] Fix regression in Android due to rework .get_station() callback
References: <1462280620-13000-1-git-send-email-jjmeijer88@gmail.com>
	<87poszs8tc.fsf@kamboji.qca.qualcomm.com>
	<CAA+NYvTxA_u1kjwmY+VTnhK0G1b5cEcx2QA90fTTEkci4gWvcQ@mail.gmail.com>
	<87wpn7p6dv.fsf@kamboji.qca.qualcomm.com>
	<CAA+NYvS3ksstny_Lzw8mLu6=0uKO0VhjuwCyxS9YC-Pb+FaYJA@mail.gmail.com>
	<87futvp432.fsf@kamboji.qca.qualcomm.com>
	<5730542C.8020201@broadcom.com>
Date: Mon, 09 May 2016 17:21:29 +0300
In-Reply-To: <5730542C.8020201@broadcom.com> (Arend Van Spriel's message of
	"Mon, 9 May 2016 11:11:08 +0200")
Message-ID: <878tzjl3bq.fsf@kamboji.qca.qualcomm.com> (sfid-20160509_162139_551982_223B5C73)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 6-5-2016 18:02, Kalle Valo wrote:
>> Jaap Jan Meijer <jjmeijer88@gmail.com> writes:
>> 
>>> 2016-05-06 16:12 GMT+01:00 Kalle Valo <kvalo@codeaurora.org>:
>>>> Jaap Jan Meijer <jjmeijer88@gmail.com> writes:
>>>>
>>>>> Hi Kalle,
>>>>>
>>>>> Op vr 6 mei 2016 12:52 schreef Kalle Valo <kvalo@codeaurora.org>:
>>>>>
>>>>>
>>>>>     This has multiple issues:
>>>>>
>>>>>     o Use your full name.
>>>>>     o Use prefix "brcmfmac: " in the title.
>>>>>
>>>>>     o I can't find commit f654d13, is the commit id really correct?
>>>>>     o Also check from SubmittingPatches how you should reference commit ids.
>>>>>
>>>>>
>>>>>
>>>>> Thank you for the feedback, I will send a reworked patch as soon as I get home
>>>>> next week. Also I did this against v4.4.8 so I'll have to rebase it as well.
>>>>>
>>>>> I'm not sure what went wrong with the commit hash, its actually this commit:
>>>>> 1f0dc59a6de93586fcfc04696a61946408ffc56a.
>>>>
>>>> That commit id looks to be valid.
>>>>
>>>>> I see you did this commit, maybe you can check if this actually is the root
>>>>> cause? I'm sure you have a lot more insight into this issue than I do.
>> 
>> I just commited the patch. Broadcom folks (CCed) should be able to
>> answer better, most likely they missed this patch as the title didn't
>> have "brcmfmac".
>
> I did see the patch and noticed the procedural issues as well. However,
> last week was a short week over here and I did not get to it to respond.
> The fix is not done properly. The function determines the RSSI from the
> per-chain values. I suspect that Jaap Jan is using a device which does
> not report per-chain values so his solution should be used as fallback.
> So can you revert the patch so Jaap Jan can rework the patch, ie.:
>
> 	if (count_rssi) {
> 		:
> 	} else if (test_bit(BRCMF_VIF_STATUS_CONNECTED,
> 			    &ifp->vif->sme_state)) {
> 		memset(&scb_val, 0, sizeof(scb_val));
> 		err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI,
> 					     &scb_val, sizeof(scb_val));
> 		if (err) {
> 			brcmf_err("Could not get rssi (%d)\n", err);
> 			goto done;
> 		} else {
> 			rssi = le32_to_cpu(scb_val.val);
> 			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
> 			sinfo->signal = rssi;
> 			brcmf_dbg(CONN, "RSSI %d dBm\n", rssi);
> 		}
> 	}
>
> Let me know if that is ok or should I submit a fixup patch.

I haven't applied Jaap's patch yet so he can send v2. Sorry for the
confusion.

-- 
Kalle Valo
