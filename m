Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cit-hm8-mail01.bmw-carit.de ([212.118.206.84]:38283 "EHLO
	cit-hm8-gw01.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751451AbcG2GJB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2016 02:09:01 -0400
Subject: Re: [RFC v0 3/8] firmware: Factor out firmware load helpers
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Daniel Wagner <wagi@monom.org>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-4-git-send-email-wagi@monom.org>
 <20160728175706.GB16852@dtor-ws>
CC: Bastien Nocera <hadess@hadess.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	<linux-input@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Message-ID: <956c030c-1847-eb58-c31b-06ad15c551f0@bmw-carit.de> (sfid-20160729_080906_826150_6FCD604C)
Date: Fri, 29 Jul 2016 08:08:50 +0200
MIME-Version: 1.0
In-Reply-To: <20160728175706.GB16852@dtor-ws>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/28/2016 07:57 PM, Dmitry Torokhov wrote:
> On Thu, Jul 28, 2016 at 09:55:07AM +0200, Daniel Wagner wrote:
>> +int __firmware_stat_wait(struct firmware_stat *fwst,
>> +				long timeout)
>> +{
>> +	int err;
>> +	err = swait_event_interruptible_timeout(fwst->wq,
>> +				is_fw_sync_done(READ_ONCE(fwst->status)),
>> +				timeout);
>> +	if (err == 0 && fwst->status == FW_STATUS_ABORT)
>> +		return -ENOENT;
>> +
>> +	return err;
>> +}
>> +EXPORT_SYMBOL(__firmware_stat_wait);
>> +
>> +void __firmware_stat_set(struct firmware_stat *fwst, unsigned long status)
>> +{
>> +	WRITE_ONCE(fwst->status, status);
>> +	swake_up(&fwst->wq);
>
> Do we need to notify everyone for FW_STATUS_LOADING status?

Hmm, I don't think so. In the end drivers are probably only interested 
in the final result which is either success or fail.

cheers,
daniel
