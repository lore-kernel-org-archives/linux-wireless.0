Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3605 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759095Ab3BGUDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 15:03:16 -0500
Message-ID: <51140811.3000108@broadcom.com> (sfid-20130207_210319_574465_F2AA44FE)
Date: Thu, 7 Feb 2013 21:01:21 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 0/4] Add support for off-channel powersave state in
 mac80211
References: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com>
 <1360186322.7910.76.camel@jlt4.sipsolutions.net>
 <20130207181543.GA4378@thinkpad-t410>
In-Reply-To: <20130207181543.GA4378@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2013 07:15 PM, Seth Forshee wrote:
> On Wed, Feb 06, 2013 at 10:32:02PM +0100, Johannes Berg wrote:
>> On Wed, 2013-02-06 at 15:01 -0600, Seth Forshee wrote:
>>> Hi Johannes,
>>>
>>> As promised, here are the patches which add the off-channel powesave
>>> state. At a high level, the changes are:
>>>
>>>  * Expand the PS configuration flag to be 2 bits and add helper
>>>    functions for reading and setting the modes
>>>  * Change the terminology around PS states, i.e. disabled -> awake and
>>>    enabled -> doze
>>>  * Add the off-channel PS state and put it to use
>>>  * Minor driver updates based on these changes
>>>  * Update brcmsmac to utilize the off-channel PS state
> 
> Hmm, I guess I should have mentioned that these patches were written on
> top of the version 2 patches I sent for adding the off-channel queue
> stop reason, etc. I'll need to resend them before they're likely to
> apply cleanly anywhere.
> 
>> That's a lot of driver changes ... :)
> 
> A large number of those changes were made by sed ;-)
> 
>> I've been trying to disentangle the mess a bit. It looks like I was
>> completely wrong about wl1251, it has HW scan so we don't care about its
>> weird PS behaviour (1).
>>
>> That leaves us with a few different drivers:
>>  * iwlegacy -- has PS support but not NULLFUNC_STACK, so generates a
>>    wakeup to the AP when we want to go scan ...
>>  * drivers like iwlwifi/wl12xx have HW scan and don't set NULLFUNC_STACK
>>  * drivers like ath5k/9k/... have all SW but set NULLFUNC_STACK
>>  * drivers that just don't have powersave
> 
> I tried to ensure that the patches would result in equivalent behavior
> for all drivers except brcmsmac (which will behave better). But I
> obviously wan't able to test every driver to verify this.
> 
> I suspect b43 should also be updated similarly to brcmsmac. The only
> hardware I have that uses b43 is a macbook whose wireless functions too
> poorly to be a good test case.

If I recall correctly b43 has a Kconfig option to allow it to support
the same devices brcmsmac supports.

Gr. AvS

