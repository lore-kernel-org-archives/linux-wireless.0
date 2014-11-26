Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:48647 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaKZQnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 11:43:53 -0500
Received: by mail-wg0-f54.google.com with SMTP id l2so4251202wgh.27
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 08:43:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141125202847.GL25677@wotan.suse.de>
References: <1416754941-4439-1-git-send-email-arik@wizery.com>
 <1416754941-4439-3-git-send-email-arik@wizery.com> <20141125202847.GL25677@wotan.suse.de>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 26 Nov 2014 18:43:37 +0200
Message-ID: <CA+XVXfeXd0moKyx5MOio_Naqq3K+9VkbYmNkyyPSVU-nxuqzhw@mail.gmail.com> (sfid-20141126_174356_975691_08EF19B6)
Subject: Re: [PATCH v3 3/3] cfg80211: Allow usermode to query wiphy specific
 regd info
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2014 at 10:28 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Sun, Nov 23, 2014 at 05:02:21PM +0200, Arik Nemtsov wrote:
>> From: Jonathan Doron <jond@wizery.com>
>>
>> Allow usermode to query wiphy-specific regd info, for drivers that use
>> wiphy-specific regulatory management.
>>
>> Use the existing API for sending regdomain info to usermode, but return
>> the wiphy-specific regd in case wiphy index is provided and the driver
>> employs wiphy-specific management. This implies user and kernel-mode
>> support for the feature and is backward compatible.
>>
>> Signed-off-by: Jonathan Doron <jonathanx.doron@intel.com>
>> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
>> ---
>>  include/uapi/linux/nl80211.h | 18 ++++++++++-
>>  net/wireless/nl80211.c       | 71 ++++++++++++++++++++++++++++++++++++--------
>>  net/wireless/reg.c           |  2 +-
>>  net/wireless/reg.h           |  1 +
>>  4 files changed, 78 insertions(+), 14 deletions(-)
>>
>> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
>> index 3771e7d..b222e5c 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -252,7 +252,12 @@
>>   *   %NL80211_ATTR_IFINDEX.
>>   *
>>   * @NL80211_CMD_GET_REG: ask the wireless core to send us its currently set
>> - *   regulatory domain.
>> + *   regulatory domain. If %NL80211_ATTR_WIPHY is specified and the device
>> + *   self-manages its regulatory settings, its private regulatory domain
>> + *   will be returned.
>> + *   If %NL80211_ATTR_WIPHY_GET_PRIV_REG is specified in addition to
>> + *   %NL80211_ATTR_WIPHY, a device's private regulatory domain will be
>> + *   returned, even if it's regulatory is not self-managed.
>>   * @NL80211_CMD_SET_REG: Set current regulatory domain. CRDA sends this command
>>   *   after being queried by the kernel. CRDA replies by sending a regulatory
>>   *   domain structure which consists of %NL80211_ATTR_REG_ALPHA set to our
>> @@ -1693,6 +1698,14 @@ enum nl80211_commands {
>>   *
>>   * @NL80211_ATTR_MAC_MASK: MAC address mask
>>   *
>> + * @NL80211_ATTR_WIPHY_SELF_MANAGED_REG: flag attribute indicating the
>> + *   regulatory information was obtained from the private regdomain
>> + *   of a device with self-managed regulatory.
>> + * @NL80211_ATTR_WIPHY_GET_PRIV_REG: flag attribute indicating the regulatory
>> + *   information should be obtained from a device's private regdomain,
>> + *   if it exists. This will happen even if the device is not self-managing
>> + *   its regulatory.
>
> As with REGULATORY_WIPHY_SELF_MANAGED we need a flag that cfg80211 sets for
> drivers that use regulatory_hint() API, perhaps REGULATORY_WIPHY_REG_HINT.
> Then this can be used by cfg80211 to send to userspace regdomains for wiphys
> that have used this API. Below you enable userspace to only query for these
> explictly but we want to be able to let userspace get all information, ie
> through 'iw reg get'. This should go in as a separate patch along with
> NL80211_ATTR_WIPHY_GET_PRIV_REG as its use predates
> NL80211_ATTR_WIPHY_SELF_MANAGED_REG, this will also let you stuff in the boiler
> plate code for getting that reg first, getting self managed regd's can then
> go in as a clear secondary evolutionary step.

Note that we don't really need the new REGULATORY_WIPHY_REG_HINT.. If
a wiphy is not self-managed, we can just put
NL80211_ATTR_WIPHY_PRIV_REG, since it's obvious the regulatory_hint
API was used.

Arik
