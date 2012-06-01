Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2FAGv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 02:51:58 -0400
Message-ID: <1338533516.4884.5.camel@jlt3.sipsolutions.net> (sfid-20120601_085201_865760_46695F23)
Subject: Re: [PATCH 3.5] iwlwifi: fix TX power antenna access
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 01 Jun 2012 08:51:56 +0200
In-Reply-To: <1338366972.4511.9.camel@jlt3.sipsolutions.net> (sfid-20120530_103641_304149_CED6F984)
References: <1338366972.4511.9.camel@jlt3.sipsolutions.net>
	 (sfid-20120530_103641_304149_CED6F984)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-30 at 10:36 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Since my commit
>   iwlwifi: use valid TX/RX antenna from hw_params
> the config values are pure overrides, not the
> real values for all hardware. Therefore, the
> EEPROM TX power reading code checks the wrong
> values, it should check the hw_params values.

The effect of this is that on some hardware,
all channels are reported with a maximum TX
power of 0 dBm (instead of 15 dBm) which is a
major performance problem.

johannes

