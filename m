Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38827 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbcEJLeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 07:34:46 -0400
Received: by mail-wm0-f45.google.com with SMTP id g17so22197993wme.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2016 04:34:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878tzjl3bq.fsf@kamboji.qca.qualcomm.com>
References: <1462280620-13000-1-git-send-email-jjmeijer88@gmail.com>
 <87poszs8tc.fsf@kamboji.qca.qualcomm.com> <CAA+NYvTxA_u1kjwmY+VTnhK0G1b5cEcx2QA90fTTEkci4gWvcQ@mail.gmail.com>
 <87wpn7p6dv.fsf@kamboji.qca.qualcomm.com> <CAA+NYvS3ksstny_Lzw8mLu6=0uKO0VhjuwCyxS9YC-Pb+FaYJA@mail.gmail.com>
 <87futvp432.fsf@kamboji.qca.qualcomm.com> <5730542C.8020201@broadcom.com> <878tzjl3bq.fsf@kamboji.qca.qualcomm.com>
From: Jaap Jan Meijer <jjmeijer88@gmail.com>
Date: Tue, 10 May 2016 13:34:24 +0200
Message-ID: <CAA+NYvQCmssjBWWTFPLa1tiTfpDMDmxKHa=4RXKQFaQ3XOYt8A@mail.gmail.com> (sfid-20160510_133450_324074_E58DB3B3)
Subject: Re: [PATCH] Fix regression in Android due to rework .get_station() callback
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2016-05-09 16:21 GMT+02:00 Kalle Valo <kvalo@codeaurora.org>:
> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
>> I did see the patch and noticed the procedural issues as well. However,
>> last week was a short week over here and I did not get to it to respond.
>> The fix is not done properly. The function determines the RSSI from the
>> per-chain values. I suspect that Jaap Jan is using a device which does
>> not report per-chain values so his solution should be used as fallback.
>> So can you revert the patch so Jaap Jan can rework the patch, ie.:
>>
>>       if (count_rssi) {
>>               :
>>       } else if (test_bit(BRCMF_VIF_STATUS_CONNECTED,
>>                           &ifp->vif->sme_state)) {
>>               memset(&scb_val, 0, sizeof(scb_val));
>>               err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI,
>>                                            &scb_val, sizeof(scb_val));
>>               if (err) {
>>                       brcmf_err("Could not get rssi (%d)\n", err);
>>                       goto done;
>>               } else {
>>                       rssi = le32_to_cpu(scb_val.val);
>>                       sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
>>                       sinfo->signal = rssi;
>>                       brcmf_dbg(CONN, "RSSI %d dBm\n", rssi);
>>               }
>>       }
>>


Thank you for the feedback, I would like to contribute so I'll build a
new patch.

One more question: I only included the signal strength because I
needed it for Android, should I also include Beacon peroid and DTIM
period again in this fallback? If so, I would probably need to
separate this code in a new fallback method?
