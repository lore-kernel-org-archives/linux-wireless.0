Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7198 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbbJRSjC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 14:39:02 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>,
	"Berg, Johannes" <johannes.berg@intel.com>
CC: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"linux-firmware@kernel.org" <linux-firmware@kernel.org>
Subject: Re: [PATCH] iwlwifi: Fix module firmware information for 3160
Date: Sun, 18 Oct 2015 18:38:58 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E8A5AFF@hasmsx107.ger.corp.intel.com> (sfid-20151018_203907_162765_AA72EF1D)
References: <1445190425.31451.70.camel@decadent.org.uk>
 <1445193191.31451.79.camel@decadent.org.uk>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 10/18/2015 09:33 PM, Ben Hutchings wrote:
> On Sun, 2015-10-18 at 18:47 +0100, Ben Hutchings wrote:
>> IWL3160_UCODE_API_OK is no longer defined, so we end up with this
>> in the module information:
>>
>> firmware:       iwlwifi-3160-IWL3160_UCODE_API_OK.ucode
>>
>> It looks like IWL7260_UCODE_API_OK should be used instead now.
> [...]
> 
> Somewhat relatedly, I noticed that iwlwifi is now requesting firmware
> files that aren't yet in linux-firmware.git.  Please can you submit
> them for inclusion?
> 

This is a good point but the firmware filename is now changing too
rapidly (every 6 weeks) to include all of them into linux-firmware.git.
So we chose the firmware version that are the most stable and that
correspond to a certain kernel. E.g. I won't upstream -16.ucode since
4.2 can handle 15 and 4.3 can already handle 17.
That's the compromise we found.
Note that all the firmware versions are available in our
linux-firmware.git clone.

Right now, I am waiting for -17.ucode to stabilize before upstreaming it.
