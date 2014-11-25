Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41609 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaKYIim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 03:38:42 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so8345050wiv.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 00:38:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87d28b3dzg.fsf@kamboji.qca.qualcomm.com>
References: <1416834909-7130-1-git-send-email-michal.kazior@tieto.com>
	<1416834909-7130-3-git-send-email-michal.kazior@tieto.com>
	<87d28b3dzg.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 25 Nov 2014 09:38:41 +0100
Message-ID: <CA+BoTQmf6+U20083pHxMdDPMDZf=MNoup+CxBTn=azLZupQYPw@mail.gmail.com> (sfid-20141125_093845_870716_3CFAEAA2)
Subject: Re: [PATCH 3/3] ath10k: fix station count enforcement
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 November 2014 at 09:01, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> The number of peers isn't directly translatable to
>> the number of stations because ath10k needs to
>> reserve a few extra peers for special cases like
>> multi-vif concurrency.
>>
>> The previous limit was 126 and 15 stations in AP
>> mode for 10.x and main firmware branches
>> respectively. The limit is now 128 and 16 which
>> was the original intention.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> +static void ath10k_core_init_max_sta_count(struct ath10k *ar)
>> +{
>> +     if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
>> +             ar->max_num_peers = TARGET_10X_NUM_PEERS;
>> +             ar->max_num_stations = TARGET_10X_NUM_STATIONS;
>> +     } else {
>> +             ar->max_num_peers = TARGET_NUM_PEERS;
>> +             ar->max_num_stations = TARGET_NUM_STATIONS;
>> +     }
>> +}
>> +
>>  int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
>>  {
>>       int status;
>> @@ -939,6 +950,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
>>       else
>>               ar->free_vdev_map = (1LL << TARGET_NUM_VDEVS) - 1;
>>
>> +     ath10k_core_init_max_sta_count(ar);
>
> I don't see the need to call this during every firmware start as these
> are not changed afterwards. I think it would be better to call this once
> just after ath10k_core_fetch_firmware_files() is called.

Hmm.. It makes sense but now that I think about it the max number of
peers should actually depend on WMI_SERVICE_IRAM_TIDS which is known
after booting firmware. However since only 10.x was released with the
service enabled we used fw_features. So.. yeah. I can move the
function call if you want though.


Michał
