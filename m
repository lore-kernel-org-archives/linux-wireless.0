Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:34314 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab2BFOHP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 09:07:15 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Eliad Peller <eliad@wizery.com>, eyal@wizery.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 5/7] wl12xx: add RX data filter ACX commands
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
	<1328021048-8944-6-git-send-email-eliad@wizery.com>
	<1328170983.3626.265.camel@cumari>
Date: Mon, 06 Feb 2012 16:07:10 +0200
In-Reply-To: <1328170983.3626.265.camel@cumari> (Luciano Coelho's message of
	"Thu, 02 Feb 2012 10:23:03 +0200")
Message-ID: <877h00cay9.fsf@purkki.adurom.net> (sfid-20120206_150720_416037_DE2F6BC3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <coelho@ti.com> writes:

>> +	if (index >= WL1271_MAX_RX_DATA_FILTERS) {
>> +		wl1271_warning("acx_set_rx_data_filter: invalid filter idx(%d)",
>> +			       index);
>> +		return -EINVAL;
>> +	}
>
> Should we use BUG_ON instead? This is only used internally in the
> driver, so if it get here, it's a bug.  And if the filters come from
> userspace, we should validate them before continuing anyway.

BUG_ON() is evil and wireless drivers should really not use it,
WARN_ON_ONCE() and return with an error is much more user friendly.

-- 
Kalle Valo
