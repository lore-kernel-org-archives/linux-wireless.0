Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52285 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756463Ab0KJP7u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 10:59:50 -0500
Message-ID: <4CDAC16A.2050300@openwrt.org>
Date: Wed, 10 Nov 2010 16:59:38 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	mcgrof@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7 1/3] cfg80211: Add nl80211 antenna configuration
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6> <1289404367.3748.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1289404367.3748.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-10 4:52 PM, Johannes Berg wrote:
> On Wed, 2010-11-10 at 12:50 +0900, Bruno Randolf wrote:
> 
>> 802.11n devices should enable or disable chains, based on which antennas are
>> present (If all antennas belonging to a particular chain are disabled, the
>> entire chain should be disabled). HT capabilities (like STBC, TX Beamforming,
>> Antenna selection) should be calculated based on the available chains after
>> applying the antenna masks. Should a 802.11n device have diversity antennas
>> attached to one of their chains, diversity can be enabled or disabled based on
>> the antenna information.
> 
> I'm not entirely convinced that this is a good idea. Nor that, even if
> 11n devices were to implement it, they should all implementing their own
> code to update the HT capabilities. However, I suppose that nothing
> forces them to implement it, and when somebody does I can still complain
> when they put everything into the driver.
Drivers already need to calculate their HT capabilities based on the
number of chains.
If chains get masked out based on the antenna mask settings, the driver
code would most of the time only need minor refactoring for updating the
settings which wouldn't necessarily result in any new code duplication
at all.

- Felix

