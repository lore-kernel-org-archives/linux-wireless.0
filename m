Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50336 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbcDYNFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 09:05:37 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Pat Erley <pat-lkml@erley.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Subject: Re: [PATCH 23/43] iwlwifi: remove support for fw older than -16.ucode
References: <1459346667.4731.9.camel@intel.com>
	<1459346715-7954-23-git-send-email-emmanuel.grumbach@intel.com>
	<571C681B.2090604@erley.org>
Date: Mon, 25 Apr 2016 16:05:32 +0300
In-Reply-To: <571C681B.2090604@erley.org> (Pat Erley's message of "Sat, 23 Apr
	2016 23:30:51 -0700")
Message-ID: <87y481x2hv.fsf@purkki.adurom.net> (sfid-20160425_150542_587705_93739746)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pat Erley <pat-lkml@erley.org> writes:

> This patch broke ucode loading on iwl6050 hardware.
>
> [   12.666080] iwlwifi 0000:03:00.0: Direct firmware load for
> iwlwifi-6050-exp.ucode failed with error -2
> [   12.672318] iwlwifi 0000:03:00.0: Driver unable to support your
> firmware API. Driver supports v5, firmware is v689702145.
> [   12.676429] iwlwifi 0000:03:00.0: Driver unable to support your
> firmware API. Driver supports v5, firmware is v164168705.
> [   12.676631] iwlwifi 0000:03:00.0: no suitable firmware found!

I'm seeing the same:

[    7.459114] Intel(R) Wireless WiFi driver for Linux
[    7.459117] Copyright(c) 2003- 2015 Intel Corporation
[    7.459317] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM control
[    7.468245] iwlwifi 0000:03:00.0: Driver unable to support your firmware API. Driver supports v6, firmware is v313001473.
[    7.470916] iwlwifi 0000:03:00.0: Driver unable to support your firmware API. Driver supports v6, firmware is v296224003.
[    7.470931] iwlwifi 0000:03:00.0: no suitable firmware found!

My device:

03:00.0 Network controller [0280]: Intel Corporation Centrino Advanced-N 6205 [Taylor Peak] [8086:0085] (rev 34)

-- 
Kalle Valo
