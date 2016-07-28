Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cit-hm8-mail01.bmw-carit.de ([212.118.206.84]:33595 "EHLO
	cit-hm8-gw01.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757940AbcG1NKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 09:10:10 -0400
Subject: Re: [RFC v0 4/8] Input: goodix: use firmware_stat instead of
 completion
To: Bastien Nocera <hadess@hadess.net>, Daniel Wagner <wagi@monom.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-5-git-send-email-wagi@monom.org>
 <1469704952.6761.142.camel@hadess.net>
 <f7dd0db5-af15-7310-ac9f-1034bdf4f592@bmw-carit.de>
 <1469708450.6761.156.camel@hadess.net>
CC: <linux-input@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<irina.tirdea@intel.com>, <octavian.purdila@intel.com>
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Message-ID: <d173a67b-43f7-c0d6-255b-9ce4a0fb1e00@bmw-carit.de> (sfid-20160728_151041_351809_3713B067)
Date: Thu, 28 Jul 2016 15:10:04 +0200
MIME-Version: 1.0
In-Reply-To: <1469708450.6761.156.camel@hadess.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Looking at the API, I really don't like the mixing of namespaces.
> Either it's fw_ or it's firmware_ but not a mix of both.

I agree, that was not really clever.

	struct fw_loading { ... }
	__fw_loading_*()
	fw_loading_*()

Would that make more sense? firmware_loading_ as prefix is a bit long IMO.

> Also looks like fw_loading_start() would do nothing as the struct is
> likely zero initialised, and FW_STATUS_LOADING == 0. Maybe you need an
> UNSET enum member?

Good point, I cut a corner here a bit :). In the spirit of making things 
more clear fw_loading_start() should be used.

> FW_STATUS_ABORT <- FW_STATUS_ABORTED, to match the adjective suffixes
> of the other members. Ditto fw_loading_abort() which doesn't abort
> firmware loading but sets the status.

Okay.

Thanks a lot for the feedback.

cheers,
daniel
