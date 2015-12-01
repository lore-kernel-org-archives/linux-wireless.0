Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48342 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbbLAWFm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 17:05:42 -0500
Message-ID: <1449007539.2977.11.camel@sipsolutions.net> (sfid-20151201_230545_767575_B7213B65)
Subject: Re: MAC address randomization support
From: Johannes Berg <johannes@sipsolutions.net>
To: Anatol Pomozov <anatol.pomozov@gmail.com>,
	"Greenman, Gregory" <gregory.greenman@intel.com>,
	linux-wireless@vger.kernel.org,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Tue, 01 Dec 2015 23:05:39 +0100
In-Reply-To: <CAOMFOmV-TdX2h2patazVuffZmy=MAqHfnLso90kQn5+d=ODU9w@mail.gmail.com> (sfid-20151201_225959_079001_7630D8E2)
References: <CAOMFOmV-TdX2h2patazVuffZmy=MAqHfnLso90kQn5+d=ODU9w@mail.gmail.com>
	 (sfid-20151201_225959_079001_7630D8E2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Anatol,

> This feature is supported in Android and a few products use it
> already for Preferred Network Offload scan. There is a HAL method
> that allows to set MAC OUI [1] that makes 3 first octets predefined
> and the rest of MAC address is randomized. Kernel passes this OUI
> value to firmware where the randomization is implemented.
> 
> I checked current upstream kernel and did not find any API for
> enabling/dealing with MAC address randomization. If a firmware devs
> want to add the feature easily then there should be some standard API
> for enabling/configuring MAC randomization.

Well, we are treating it on a per-feature basis. The upstream kernel
does, in fact, and I believe we also submitted it into ChromeOS,
support randomized MAC addresses for scan and scheduled scan.

> In fact there is one mention of the feature in upstream source tree -
> macaddr_* fields in "struct iwl_tof_range_req_cmd" of iwlwifi driver.
> It allows to enable/disable randomization for 11MC measurement.

If you're talking about fine timing measurement, however, we haven't
yet submitted that API for that upstream. I sent you a draft of that
API and it does in fact contain MAC address randomization support from
the start :)

> The MAC randomization could be used by other drivers for many
> use-cases and I think it worth making it a part of standard cfg80211
> API. Is it something maintainers are interested in? Does anybody work
> on it already?

Yes and yes, obviously, but I think what I said at the beginning - that
it's per feature rather than global - is just not what you were looking
for or had expected?

I still think it makes sense btw, scan for example can be randomized in
software in certain cases, scheduled scan might not be able to, etc.

johannes

