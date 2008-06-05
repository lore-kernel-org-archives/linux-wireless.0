Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:37858 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbYFEN0a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 09:26:30 -0400
Received: by yw-out-2324.google.com with SMTP id 9so392465ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2008 06:26:21 -0700 (PDT)
Message-ID: <43e72e890806050626o53134669u775d04b554734164@mail.gmail.com> (sfid-20080605_152633_135823_055A2B29)
Date: Thu, 5 Jun 2008 06:26:20 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] rt2x00: Rename tx_info to info to help compat-wireless revert MQ support for older kernels
Cc: linville@tuxdriver.com, "Ivo van Doorn" <ivdoorn@gmail.com>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1212671763.698.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080605130734.GD17936@ruslug.rutgers.edu>
	 <1212671763.698.11.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 5, 2008 at 6:16 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2008-06-05 at 09:07 -0400, Luis R. Rodriguez wrote:
>> Rename tx_info to info as used by other drivers. This will help
>> with CONFIG_NETDEVICES_MULTIQUEUE requirement for HT support support
>> in compat-wireless by allowing us to map skb_get_queue_mapping(skb)
>> to the old info->queue.
>>
>> An alternative is to maintain a large compat.diff which replaces all
>> skb_get_queue_mapping(skb) calls back to info->queue but since this
>> is the only driver which requires name change it seems worth it
>> to help with maintenance.
>>
>> Compat-wireless shouldn't be a reason to accept patches in but if
>> the changes are just cosmetic it seems worth the benefit.
>>
>> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
>
> That's just asking for trouble. If you really _must_ do magic in
> skb_get_queue_mapping, do it directly:
>
> int q = IEEE80211_SKB_CB(skb)->queue;

Works for me, thanks. Please ignore patch, or not if you want drivers
for some strange reason to be consistent. I just don't need it now.

  Luis
