Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0075.outbound.protection.outlook.com ([104.47.41.75]:43520
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752374AbdHNUIe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 16:08:34 -0400
Subject: Re: [PATCH] nl80211: add an option to allow MFP without requiring it
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>,
        sergey.matyukevich.os@quantenna.com
References: <20170814134911.20869-1-emmanuel.grumbach@intel.com>
 <a35aea64-b391-2719-c8cb-92ef9c9288c7@broadcom.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <1723b617-2272-330e-958c-bb988aa504d5@quantenna.com> (sfid-20170814_220842_155139_11F1369C)
Date: Mon, 14 Aug 2017 13:08:26 -0700
MIME-Version: 1.0
In-Reply-To: <a35aea64-b391-2719-c8cb-92ef9c9288c7@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/14/2017 12:22 PM, Arend van Spriel wrote:
> On 14-08-17 15:49, Emmanuel Grumbach wrote:
>> User space can now allow the kernel to associate to an AP
>> that requires MFP or that doesn't have MFP enabled in the
>> same NL80211_CMD_CONNECT command.
>> The driver / firmware will decide whether to use it or not.
>>
>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> ---
>> A short tour of the drivers taught me that only Quantenna really look
>> at cfg80211_connect_params::sme which can now be 2. This is why
>> the maintainer of this driver is CCed.
> 
> Indeed in brcmfmac the IE is processed to determine whether it is
> required or optional. Probably will change our driver to use the
> explicit mfp values from cfg80211_connect_params::sme.

Maybe this is a right way to do that, avoiding that compatibility 
problem (no new NL* flags)? Except for maybe nl80211 layer should parse 
it instead, not driver.

It is kind of not clear right now for drivers where to get information from:
- NL attributes passed from userspace and forwarded to a driver
- IEs passed from userspace, parsed by nl80211 and forwarded to a driver
- IEs that are passed from userspace and parsed by drivers directly

> 
> Thanks,
> Arend
