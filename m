Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35391 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbbCXHEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 03:04:33 -0400
Received: by wibdy8 with SMTP id dy8so66728171wib.0
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 00:04:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87lhind7p7.fsf@kamboji.qca.qualcomm.com>
References: <1427114301-18886-1-git-send-email-michal.kazior@tieto.com>
	<1427114301-18886-2-git-send-email-michal.kazior@tieto.com>
	<87lhind7p7.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 24 Mar 2015 08:04:31 +0100
Message-ID: <CA+BoTQkdkNTpcyUoZ=RDNW7jsKeRpJjJt7sHruZ1QBGh8ujJSQ@mail.gmail.com> (sfid-20150324_080437_240650_2CB0E2E3)
Subject: Re: [PATCH 1/2] ath10k: share board file loading code across FW APIs
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 March 2015 at 17:01, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> There's no need to implement the same thing twice.
>> Reduce code duplication.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> @@ -730,6 +716,12 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
>>       /* calibration file is optional, don't check for any errors */
>>       ath10k_fetch_cal_file(ar);
>>
>> +     ret = ath10k_core_fetch_board_file(ar);
>> +     if (ret) {
>> +             ath10k_err(ar, "failed to fetch board file: %d\n", ret);
>> +             return ret;
>> +     }
>> +
>>       ar->fw_api = 4;
>>       ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
>
> There was a conflict here, please check the resolution in the pending
> branch.

Looks good, thanks!


Michał
