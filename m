Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:29389 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbYFHQc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 12:32:27 -0400
Received: by rv-out-0506.google.com with SMTP id l9so2200928rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 09:32:27 -0700 (PDT)
Message-ID: <1ba2fa240806080932s3a241ea5x49639f33cf086fd2@mail.gmail.com> (sfid-20080608_183232_975039_DECD935B)
Date: Sun, 8 Jun 2008 19:32:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] rt2x00: Rename tx_info to info to help compat-wirelessrevert MQ support for older kernels
Cc: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, "Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806060507s54c33009i9fb9136d4461802d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080605130734.GD17936@ruslug.rutgers.edu>
	 <1212671763.698.11.camel@johannes.berg>
	 <1879838866982C46A9CB3D56BA49ADEB04FA9CFD@hasmsx411.ger.corp.intel.com>
	 <43e72e890806060448g57b23392t7bcaab305eadffd@mail.gmail.com>
	 <1ba2fa240806060507s54c33009i9fb9136d4461802d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 6, 2008 at 3:07 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Fri, Jun 6, 2008 at 2:48 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Fri, Jun 6, 2008 at 3:39 AM, Rindjunsky, Ron
>> <ron.rindjunsky@intel.com> wrote:
>>>>> Rename tx_info to info as used by other drivers. This will help
>>>>> with CONFIG_NETDEVICES_MULTIQUEUE requirement for HT support support
>>>>> in compat-wireless by allowing us to map skb_get_queue_mapping(skb)
>>>>> to the old info->queue.
>>>>>
>>>>> An alternative is to maintain a large compat.diff which replaces all
>>>>> skb_get_queue_mapping(skb) calls back to info->queue but since this
>>>>> is the only driver which requires name change it seems worth it
>>>>> to help with maintenance.
>>>>>
>>>>> Compat-wireless shouldn't be a reason to accept patches in but if
>>>>> the changes are just cosmetic it seems worth the benefit.
>>>>>
>>>>> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
>>>
>>>> That's just asking for trouble. If you really _must_ do magic in
>>>> skb_get_queue_mapping, do it directly:
>>>
>>>> int q = IEEE80211_SKB_CB(skb)->queue;
>>>
>>> Aren't we heading into to troubles here? In kernels < 2.6.23 there is no
>>> skb->queue_mapping. queue was once passed in the cb, but now that queue
>>> was removed from info and info takes cb we are going to have a compat
>>> problem.
>>
>> This is only going to be done for <= 2.6.22.
>>
>>  Luis
>
> First we have to find out why this tx_info to cb patch broke iwlwifi

This one was solved, the patch will follow in regular driver update from Yi

Tomas
