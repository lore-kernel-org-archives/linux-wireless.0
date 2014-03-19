Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:41445 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582AbaCSJQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 05:16:21 -0400
Received: by mail-ob0-f170.google.com with SMTP id uz6so7981523obc.29
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2014 02:16:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87pplih81g.fsf@kamboji.qca.qualcomm.com>
References: <20140313082431.10798.10888.stgit@potku.adurom.net>
	<87pplih81g.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 19 Mar 2014 10:16:20 +0100
Message-ID: <CA+BoTQmaxQj+Bv_dQz-+UmrG+7rmz_pTAZAGLY9_Mi_k7JP6HA@mail.gmail.com> (sfid-20140319_101627_627554_E5FEFBA3)
Subject: Re: [PATCH v2] ath10k: add soft/hard firmware crash option to simulate_fw_crash
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 March 2014 10:06, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Hi Dan,
>
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>
>> From: Marek Puzyniak <marek.puzyniak@tieto.com>
>>
>> Command WMI_FORCE_FW_HANG_CMDID is not supported in firmware 10.1.
>> In order to have firmware crash simulation functionality also
>> in firmware 10.1 driver can force firmware crash by performing not allowed
>> operation. Driver can deliberately crash firmware when setting vdev param for
>> vdev id out of range.  This patch introduces two keywords to simulate_fw_crash:
>>
>> 'soft' which will cause firmware crash that is recoverable
>>        by warm firmware reset but supported only in main firmware.
>> 'hard' which will cause firmware crash recoverable by cold
>>        firmware reset, this option works for both firmwares.
>>
>> Commands to trigger firmware soft/hard crash:
>>
>> echo 'soft' > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash
>> echo 'hard' > /sys/kernel/debug/ieee80211/phyX/ath10k/simulate_fw_crash
>>
>> kvalo: use strncmp(), remove '\n' before checking the command and
>> document how buf is null terminated
>>
>> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>
> [...]
>
>> @@ -479,14 +488,30 @@ static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
>>               goto exit;
>>       }
>>
>> -     ath10k_info("simulating firmware crash\n");
>> +     /* drop the possible '\n' from the end */
>> +     if (buf[count - 1] == '\n') {
>> +             buf[count - 1] = 0;
>> +             count--;
>> +     }
>>
>> -     ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
>> -     if (ret)
>> -             ath10k_warn("failed to force fw hang (%d)\n", ret);
>> +     if (!strncmp(buf, "soft", sizeof(buf))) {
>> +             ath10k_info("simulating soft firmware crash\n");
>> +             ret = ath10k_wmi_force_fw_hang(ar, WMI_FORCE_FW_HANG_ASSERT, 0);
>> +     } else if (!strncmp(buf, "hard", sizeof(buf))) {
>> +             ath10k_info("simulating hard firmware crash\n");
>> +             ret = ath10k_wmi_vdev_set_param(ar, TARGET_NUM_VDEVS + 1,
>> +                                     ar->wmi.vdev_param->rts_threshold, 0);
>> +     } else {
>> +             ret = -EINVAL;
>> +             goto exit;
>> +     }
>
> Fengguan's buildbot got warnings here and I assume they are coming from
> smatch:
>
> drivers/net/wireless/ath/ath10k/debug.c:500 ath10k_write_simulate_fw_crash() error: strncmp() '"hard"' too small (5 vs 32)
> drivers/net/wireless/ath/ath10k/debug.c:497 ath10k_write_simulate_fw_crash() error: strncmp() '"soft"' too small (5 vs 32)
>
> I wanted to use strncmp() instead of strcmp(), but I'm not sure what to
> do here. In my opinion it's guaranteed that the string "hard" is null
> terminated, so it shouldn't matter even if strlen("soft") (5) is less
> than sizeof(buf) (32), right? Or am I missing something here?

Hmm.. strncmp() compares *at most* n chars. The above means you can
overflow the const char[] "hard" and "soft" if `buf` is longer than
those. strncmp() must be passed the smallest length of either
argument.


Michał
