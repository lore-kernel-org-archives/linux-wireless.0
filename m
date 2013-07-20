Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:43323 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab3GTGB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jul 2013 02:01:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] ath10k: create debugfs interface to trigger fw crash
References: <1372148011-28234-1-git-send-email-michal.kazior@tieto.com>
	<1373961277-14784-1-git-send-email-michal.kazior@tieto.com>
	<1373961277-14784-4-git-send-email-michal.kazior@tieto.com>
	<87zjti4zc5.fsf@kamboji.qca.qualcomm.com>
Date: Sat, 20 Jul 2013 09:01:46 +0300
In-Reply-To: <87zjti4zc5.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Fri, 19 Jul 2013 13:29:46 +0300")
Message-ID: <878v1122id.fsf@kamboji.qca.qualcomm.com> (sfid-20130720_080200_274670_E8A6CFE5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

>> +static ssize_t ath10k_write_simulate_fw_crash(struct file *file,
>> +					      const char __user *user_buf,
>> +					      size_t count, loff_t *ppos)
>> +{
>> +	struct ath10k *ar = file->private_data;
>> +	char buf[32] = {};
>> +	int ret;
>> +
>> +	mutex_lock(&ar->conf_mutex);
>> +
>> +	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
>> +	if (strcmp(buf, "crash") && strcmp(buf, "crash\n")) {
>> +		ath10k_warn("write keyword `crash` to simulate firmware crash\n");
>> +		goto exit;
>> +	}
>
> Better to just return an error here.
>
>> +	if (ar->state != ATH10K_STATE_ON &&
>> +	    ar->state != ATH10K_STATE_RESTARTED) {
>> +		ath10k_warn("firmware isn't loaded yet, nothing to crash\n");
>> +		goto exit;
>> +	}
>
> Ditto.

Sorry, I was unclear here. I also meant that the two ath10k_warn() calls
should be removed.

-- 
Kalle Valo
