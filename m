Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:29634 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaH2GyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 02:54:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: add testmode
References: <20140828072642.14691.44313.stgit@potku.adurom.net>
	<20140828073041.14691.15099.stgit@potku.adurom.net>
	<CA+BoTQk40V_t6M8MEwk77cUtmHpEXR3FKBgonb0T+yDX59B+gw@mail.gmail.com>
Date: Fri, 29 Aug 2014 09:54:03 +0300
In-Reply-To: <CA+BoTQk40V_t6M8MEwk77cUtmHpEXR3FKBgonb0T+yDX59B+gw@mail.gmail.com>
	(Michal Kazior's message of "Thu, 28 Aug 2014 12:35:50 +0200")
Message-ID: <87sikfss50.fsf@kamboji.qca.qualcomm.com> (sfid-20140829_085413_682450_8D2D307A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 28 August 2014 09:30, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> @@ -2483,8 +2484,12 @@ static int ath10k_start(struct ieee80211_hw *hw)
>>         case ATH10K_STATE_RESTARTED:
>>         case ATH10K_STATE_WEDGED:
>>                 WARN_ON(1);
>> +               /* fall through */
>
> Fall through? I see there's a goto ahead..
>>                 ret = -EINVAL;
>>                 goto err;

Fixed.

>> +/* "API" level of the ath10k testmode interface. Bump it after every
>> + * incompatible interface change. */
>
> I recall we reached a conclusion to use the following multiline
> comment style in ath10k:
>
> /* Foo
>  * Bar
>  */
>
> Ah, here it is: http://www.spinics.net/lists/linux-wireless/msg123419.html
>
> But this isn't really important.

I fixed all the multiline comments now.

And I did remember that we agreed about this but I just forgot how it's
supposed to look :) To be able to reasily refresh my memory I documented
this to the wiki:

http://wireless.kernel.org/en/users/Drivers/ath10k/CodingStyle#Comments

>> +       if (ar->testmode.utf != NULL)
>> +               /* utf image is already downloaded */
>> +               goto power_up;
>> +
>> +
>
> 2 empty newlines.

Fixed.

>> +       snprintf(filename, sizeof(filename), "%s/%s",
>> +                ar->hw_params.fw.dir, ATH10K_FW_UTF_FILE);
>> +
>> +       /* load utf image now and release only when the device is removed */
>> +       ret = request_firmware(&ar->testmode.utf, filename, ar->dev);
>> +       if (ret) {
>> +               ath10k_warn(ar, "failed to retrieve utf firmware '%s': %d\n",
>> +                           filename, ret);
>> +               goto out;
>> +       }
>> +
>> +       BUILD_BUG_ON(sizeof(ar->fw_features) !=
>> +                    sizeof(ar->testmode.orig_fw_features));
>> +
>
>> +       memcpy(ar->testmode.orig_fw_features, ar->fw_features,
>> +              sizeof(ar->fw_features));
>> +
>> +       /* force to use correct version of WMI interface */
>> +       memset(ar->fw_features, 0, sizeof(ar->fw_features));
>> +       __set_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features);
>
> I'm a little worried about this.

Yeah, this is an ugly hack. But at the same time I don't see much point
of changing the rest of driver just because of testmode.

> First of all the comment doesn't really explain why this is done, i.e.
> utf.bin isn't FW IE encapsulated and as such fw_features are unknown.

I'll add that.

> And then what about utf binaries which use 10.2 WMI? Or non-10.x WMI?

Right now I don't see any use of that. Think of this like FW API 1 where
we don't have any IE support.

>> +power_up:
>> +       spin_lock_bh(&ar->data_lock);
>> +
>> +       ar->testmode.utf_monitor = true;
>> +
>> +       spin_unlock_bh(&ar->data_lock);
>> +
>> +       ret = ath10k_hif_power_up(ar);
>> +       if (ret) {
>> +               ath10k_err(ar, "failed to power up hif (testmode): %d\n", ret);
>> +               ar->state = ATH10K_STATE_OFF;
>> +               goto out;
>> +       }
>> +
>> +       ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_UTF);
>> +       if (ret) {
>> +               ath10k_err(ar, "failed to start core (testmode): %d\n", ret);
>> +               ath10k_hif_power_down(ar);
>> +               ar->state = ATH10K_STATE_OFF;
>> +               goto out;
>> +       }
>
> You don't seem to be freeing firmware on failure here. I'm aware
> ath10k_testmode_destroy() takes care of it but if you happen to use a
> defect fw (or hit some kind of a fw-hw combination bug) each
> subsequent utf start will re-use the firmware binary - it won't
> re-read the binary (giving you a chance to replace utf binary with a
> different one) unless you reload the whole module or re-bind the
> device<->driver via sysfs or physically.

That's a clear bug, will fix.

>> +static int ath10k_tm_cmd_wmi(struct ath10k *ar, struct nlattr *tb[])
>> +{
>> +       struct sk_buff *skb;
>> +       int ret, buf_len;
>> +       u32 cmd_id;
>> +       void *buf;
>> +
>> +       mutex_lock(&ar->conf_mutex);
>> +
>> +       if (ar->state != ATH10K_STATE_UTF) {
>> +               ret = EHOSTDOWN;
>
> Shouldn't this be a negative number?

Fixed.

> Also ath10k_tm_cmd_utf_stop() uses -ENETDOWN for this case.

I changed this to -ENETDOWN also.

-- 
Kalle Valo
