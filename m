Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56074 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763752AbcINPdH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 11:33:07 -0400
Message-ID: <57D96DB1.5040003@candelatech.com> (sfid-20160914_173319_392018_D6DB94F1)
Date: Wed, 14 Sep 2016 08:33:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 03/21] ath10k: Allow changing ath10k debug mask at
 runtime.
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com> <1462986153-16318-4-git-send-email-greearb@candelatech.com> <871t0mfuej.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871t0mfuej.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/14/2016 07:06 AM, Valo, Kalle wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Using debugfs.  More convenient than module options
>> in some cases.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/debug.c | 62 +++++++++++++++++++++++++++++++++
>>   1 file changed, 62 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
>> index e251155..d552a4a 100644
>> --- a/drivers/net/wireless/ath/ath10k/debug.c
>> +++ b/drivers/net/wireless/ath/ath10k/debug.c
>> @@ -870,6 +870,65 @@ static const struct file_operations fops_reg_addr = {
>>   	.llseek = default_llseek,
>>   };
>>
>> +static ssize_t ath10k_read_debug_level(struct file *file,
>> +				       char __user *user_buf,
>> +				       size_t count, loff_t *ppos)
>> +{
>> +	int sz;
>> +	const char buf[] =
>> +		"To change debug level, set value adding up desired flags:\n"
>> +		"PCI:                0x1\n"
>> +		"WMI:                0x2\n"
>> +		"HTC:                0x4\n"
>> +		"HTT:                0x8\n"
>> +		"MAC:               0x10\n"
>> +		"BOOT:              0x20\n"
>> +		"PCI-DUMP:          0x40\n"
>> +		"HTT-DUMP:          0x80\n"
>> +		"MGMT:             0x100\n"
>> +		"DATA:             0x200\n"
>> +		"BMI:              0x400\n"
>> +		"REGULATORY:       0x800\n"
>> +		"TESTMODE:        0x1000\n"
>> +		"INFO-AS-DBG: 0x40000000\n"
>> +		"FW:          0x80000000\n"
>> +		"ALL:         0xFFFFFFFF\n";
>> +	char wbuf[sizeof(buf) + 60];
>> +	sz = snprintf(wbuf, sizeof(wbuf), "Current debug level: 0x%x\n\n%s",
>> +		      ath10k_debug_mask, buf);
>> +	wbuf[sizeof(wbuf) - 1] = 0;
>> +
>> +	return simple_read_from_buffer(user_buf, count, ppos, wbuf, sz);
>> +}
>> +
>> +/* Set logging level.
>> + */
>> +static ssize_t ath10k_write_debug_level(struct file *file,
>> +					const char __user *user_buf,
>> +					size_t count, loff_t *ppos)
>> +{
>> +	struct ath10k *ar = file->private_data;
>> +	int ret;
>> +	unsigned long mask;
>> +
>> +	ret = kstrtoul_from_user(user_buf, count, 0, &mask);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ath10k_warn(ar, "Setting debug-mask to: 0x%lx  old: 0x%x\n",
>> +		    mask, ath10k_debug_mask);
>> +	ath10k_debug_mask = mask;
>> +	return count;
>> +}
>
> There are already sysfs files for module parameters which seems to work
> just fine for this case:
>
> # echo 0xffffffff > /sys/module/ath10k_core/parameters/debug_mask


Ok, but it is still nice to have the printout info of what log levels
means.  Otherwise, you have to go look at firmware source to even know how
to enable the proper flags.  And as these flags are internal and might change,
we could change the printout text to match the specific kernel that is running.

In my opinion, this is a 'nice-to-have', not required, if sysfs works,
so I will also test the sysfs suggestion above.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
