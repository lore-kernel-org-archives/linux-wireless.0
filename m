Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55208 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756348AbcINPNV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 11:13:21 -0400
Message-ID: <57D96910.2010608@candelatech.com> (sfid-20160914_171326_431979_C6105042)
Date: Wed, 14 Sep 2016 08:13:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 09/21] ath10k: print fw debug messages in hex.
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com> <1462986153-16318-10-git-send-email-greearb@candelatech.com> <87oa3qefac.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87oa3qefac.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/14/2016 07:18 AM, Valo, Kalle wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This allows user-space tools to decode debug-log
>> messages by parsing dmesg or /var/log/messages.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> Don't tracing points already provide the same information?

Tracing tools are difficult to set up and may not be available on
random embedded devices.  And if we are dealing with bug reports from
the field, most users will not be able to set it up regardless.

There are similar ways to print out hex, but the logic below creates
specific and parseable logs in the 'dmesg' output and similar.

I have written a tool that can decode these messages into useful human-readable
text so that I can debug firmware issues both locally and from field reports.

Stock firmware generates similar logs and QCA could write their own decode logic
for their firmware versions.

Thanks,
Ben


>
>> +void ath10k_dbg_print_fw_dbg_buffer(struct ath10k *ar, __le32 *ibuf, int len,
>> +				    const char* lvl)
>> +{
>> +	/* Print out raw hex, external tools can decode if
>> +	 * they care.
>> +	 * TODO:  Add ar identifier to messages.
>> +	 */
>> +	int q = 0;
>> +
>> +	dev_printk(lvl, ar->dev, "ath10k_pci ATH10K_DBG_BUFFER:\n");
>> +	while (q < len) {
>> +		if (q + 8 <= len) {
>> +			printk("%sath10k: [%04d]: %08X %08X %08X %08X %08X %08X %08X %08X\n",
>> +			       lvl, q,
>> +			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3],
>> +			       ibuf[q+4], ibuf[q+5], ibuf[q+6], ibuf[q+7]);
>> +			q += 8;
>> +		}
>> +		else if (q + 7 <= len) {
>> +			printk("%sath10k: [%04d]: %08X %08X %08X %08X %08X %08X %08X\n",
>> +			       lvl, q,
>> +			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3],
>> +			       ibuf[q+4], ibuf[q+5], ibuf[q+6]);
>> +			q += 7;
>> +		}
>> +		else if (q + 6 <= len) {
>> +			printk("%sath10k: [%04d]: %08X %08X %08X %08X %08X %08X\n",
>> +			       lvl, q,
>> +			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3],
>> +			       ibuf[q+4], ibuf[q+5]);
>> +			q += 6;
>> +		}
>> +		else if (q + 5 <= len) {
>> +			printk("%sath10k: [%04d]: %08X %08X %08X %08X %08X\n",
>> +			       lvl, q,
>> +			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3],
>> +			       ibuf[q+4]);
>> +			q += 5;
>> +		}
>> +		else if (q + 4 <= len) {
>> +			printk("%sath10k: [%04d]: %08X %08X %08X %08X\n",
>> +			       lvl, q,
>> +			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3]);
>> +			q += 4;
>> +		}
>> +		else if (q + 3 <= len) {
>> +			printk("%sath10k: [%04d]: %08X %08X %08X\n",
>> +			       lvl, q,
>> +			       ibuf[q], ibuf[q+1], ibuf[q+2]);
>> +			q += 3;
>> +		}
>> +		else if (q + 2 <= len) {
>> +			printk("%sath10k: [%04d]: %08X %08X\n",
>> +			       lvl, q,
>> +			       ibuf[q], ibuf[q+1]);
>> +			q += 2;
>> +		}
>> +		else if (q + 1 <= len) {
>> +			printk("%sath10k: [%04d]: %08X\n",
>> +			       lvl, q,
>> +			       ibuf[q]);
>> +			q += 1;
>> +		}
>> +		else {
>> +			break;
>> +		}
>> +	}/* while */
>> +
>> +	dev_printk(lvl, ar->dev, "ATH10K_END\n");
>> +}
>
> Isn't this almost the same as what ath10k_dbg_dump() does?
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
