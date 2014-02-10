Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:49275 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaBJOab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 09:30:31 -0500
Message-ID: <52F8E27D.6020601@broadcom.com> (sfid-20140210_153054_186842_20142256)
Date: Mon, 10 Feb 2014 15:30:21 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 2/8] iwlwifi: mvm: disable scheduled scan
References: <52EFFCE8.6070505@gmail.com>	 <1391459962-7381-2-git-send-email-egrumbach@gmail.com>	 <52F5FC02.8050508@broadcom.com> (sfid-20140208_104235_514359_C8CEB8F3) <1392019923.4128.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1392019923.4128.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/10/2014 09:12 AM, Johannes Berg wrote:
> On Sat, 2014-02-08 at 10:42 +0100, Arend van Spriel wrote:
>> On 02/03/14 21:39, Emmanuel Grumbach wrote:
>>> From: Johannes Berg<johannes.berg@intel.com>
>>>
>>> The iwlwifi scheduled scan implementation doesn't adhere to the
>>> userspace API correctly - the API assumes that any new incoming
>>> 'incompatible' request (like scan or remain-on-channel for this
>>> driver) will just cancel the scheduled scan. Instead our driver
>>> relies on userspace cancelling it, thus breaking existing wpa_s
>>> versions.
>>
>> I think iwlwifi is not alone in this. At least I have to put a new task 
>> on my todo list ;-)
> 
> :)
> You may decide to not care - newer supplicant seems to always cancel
> scheduled scan first (although that should never have been required,
> Broadcom's proprietary Android driver also behaves to require that.)

When implementing scheduled scan, I found our firmware can handle a
regular scan regardless whether a scheduled scan is active or not.

> However, you may find that you don't just need to support the latest
> upstream wpa_supplicant, so ...

Yeah, seems to happen more often than not. Also when people start using
backports they are advised to upgrade user-space apps as well, but tend
to stick to what the distro has, so ...

> johannes

Arend

