Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36643 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbcG1R5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 13:57:10 -0400
Date: Thu, 28 Jul 2016 10:57:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Wagner <wagi@monom.org>
Cc: Bastien Nocera <hadess@hadess.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>, linux-input@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: Re: [RFC v0 3/8] firmware: Factor out firmware load helpers
Message-ID: <20160728175706.GB16852@dtor-ws> (sfid-20160728_195735_291370_1F18D997)
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-4-git-send-email-wagi@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1469692512-16863-4-git-send-email-wagi@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 28, 2016 at 09:55:07AM +0200, Daniel Wagner wrote:
> +int __firmware_stat_wait(struct firmware_stat *fwst,
> +				long timeout)
> +{
> +	int err;
> +	err = swait_event_interruptible_timeout(fwst->wq,
> +				is_fw_sync_done(READ_ONCE(fwst->status)),
> +				timeout);
> +	if (err == 0 && fwst->status == FW_STATUS_ABORT)
> +		return -ENOENT;
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(__firmware_stat_wait);
> +
> +void __firmware_stat_set(struct firmware_stat *fwst, unsigned long status)
> +{
> +	WRITE_ONCE(fwst->status, status);
> +	swake_up(&fwst->wq);

Do we need to notify everyone for FW_STATUS_LOADING status?

The driver users do not care for sure.

Thanks.

-- 
Dmitry
