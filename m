Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35864 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbcG1TBz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 15:01:55 -0400
Received: by mail-pa0-f43.google.com with SMTP id pp5so23445518pac.3
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2016 12:01:55 -0700 (PDT)
Date: Thu, 28 Jul 2016 12:01:51 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Wagner <wagi@monom.org>, Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>, linux-input@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
Message-ID: <20160728190151.GV13516@tuxbot> (sfid-20160728_210217_689216_3011CE15)
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-8-git-send-email-wagi@monom.org>
 <20160728183343.GD16852@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160728183343.GD16852@dtor-ws>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu 28 Jul 11:33 PDT 2016, Dmitry Torokhov wrote:

> On Thu, Jul 28, 2016 at 09:55:11AM +0200, Daniel Wagner wrote:
> > From: Daniel Wagner <daniel.wagner@bmw-carit.de>
> > 
[..]
> 
> Do not quite like it... I'd rather asynchronous request give out a
> firmware status pointer that could be used later on.
> 
> 	pcu->fw_st = request_firmware_async(IMS_PCU_FIRMWARE_NAME,
> 					    pcu,
> 					    ims_pcu_process_async_firmware);
> 	if (IS_ERR(pcu->fw_st))
> 		return PTR_ERR(pcu->fw_st);
> 
> 	....
> 
> 	fw_loading_wait(pcu->fw_st);
> 

In the remoteproc case (patch 6) this would clean up the code, rather
than replacing the completion API 1 to 1. I like it!

Regards,
Bjorn
