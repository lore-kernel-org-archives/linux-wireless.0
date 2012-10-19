Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2149 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab2JSIAw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 04:00:52 -0400
Message-ID: <508108AB.2010801@broadcom.com> (sfid-20121019_100056_543372_F0519641)
Date: Fri, 19 Oct 2012 10:00:43 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Bing Zhao" <bzhao@marvell.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Sam Leffler" <sleffler@chromium.org>,
	"Amitkumar Karwar" <akarwar@marvell.com>
Subject: Re: [PATCH v6 3/6] cfg80211: add scan flag to indicate its
 priority
References: <1350542071-26498-1-git-send-email-bzhao@marvell.com>
 <1350542071-26498-4-git-send-email-bzhao@marvell.com>
 <507FAF19.6030500@broadcom.com>
 <477F20668A386D41ADCC57781B1F7043083B80E682@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083B80E682@SC-VEXCH1.marvell.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2012 08:44 PM, Bing Zhao wrote:
> Hi Arend,
>
>>> From: Sam Leffler <sleffler@chromium.org>
>>>
>>> Add NL80211_SCAN_FLAG_LOW_PRIORITY flag support. It tells drivers
>>> that this is a low priority scan request, so that they can take
>>> necessary action.
>>> Drivers need to advertise low priority scan capability during
>>> registration.
>>
>> I missed the previous versions of this patch series, but what 'necessary
>> action' is needed for a low priority scan request. Patch #6 gives a clue
>> so my assumption is that a low prio scan will be *aborted* when
>> associated and data traffic is available. Is that correct? Could it also
>
> It's up to the driver to decide and implement the 'low priority scan' feature.
> The driver can defer or abort the low priority scan request depending on various conditions.
> For example, when heavy data traffic is on going you may want to abort the scan.

Thanks, Bing

I always find such answer tricky. Seeing where this is coming from I 
suspect there is some high-level expectation from user-space 
perspective. I suspect it is something like: A low-prio scan should not 
affect a data transfer (iperf, nfs i/o, etc.) noticably.

Thanks for collecting the reading material ;-)

Gr. AvS


