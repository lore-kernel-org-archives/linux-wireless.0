Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47813 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334Ab2BHRGJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 12:06:09 -0500
Message-ID: <4F32AB79.9040307@openwrt.org> (sfid-20120208_180614_597394_C4593F8C)
Date: Wed, 08 Feb 2012 18:06:01 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: minstrel_ht: fix NULL pointer dereference
 during auth/assoc
References: <1328705077-31360-1-git-send-email-arend@broadcom.com> <4F329DE5.20408@openwrt.org> <4F32A263.5050909@broadcom.com>
In-Reply-To: <4F32A263.5050909@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-08 5:27 PM, Arend van Spriel wrote:
> On 02/08/2012 05:08 PM, Felix Fietkau wrote:
>> On 2012-02-08 1:44 PM, Arend van Spriel wrote:
>>> This patch fixes the following NULL pointer dereference:
>>>
>>>> I rerun the test on a kernel with some more lock checking and got lucky.
>>>>
>>>> Feb  8 08:40:17 lb-bun-10 kernel: [  514.512283] wlan0: authenticate
>>>> with 98:fc:11:8e:94:57
>>>> Feb  8 08:40:17 lb-bun-10 kernel: [  514.512515] wlan0: send auth to
>>>> 98:fc:11:8e:94:57 (try 1/3)
>>>> Feb  8 08:40:17 lb-bun-10 kernel: [  514.514184] BUG: unable to handle
>>>> kernel NULL pointer dereference at 00000004
>>>> Feb  8 08:40:17 lb-bun-10 kernel: [  514.514233] IP: [<f8648f08>]
>>>> minstrel_tx_status+0x48/0xe0 [mac80211]
>>>
>>> static inline int
>>> rix_to_ndx(struct minstrel_sta_info *mi, int rix)
>>> {
>>>         int i = rix;
>>>         for (i = rix; i >= 0; i--)
>>>                 if (mi->r[i].rix == rix)
>>>   48:   3b 58 04                cmp    0x4(%eax),%ebx
>>>   4b:   74 4b                   je     98 <minstrel_tx_status+0x98>
>>>   4d:   83 c2 01                add    $0x1,%edx
>>>
>>> It fails because of mi->r[i] being a NULL pointer. It is allocated in
>>> minstel_alloc_sta, but minstrel_ht_alloc_sta does not call that function.
>>>
>>> struct minstrel_ht_sta_priv holds a union with struct minstrel_ht_sta and
>>> struct minstrel_sta_info. During authenticate the bool is_ht is false so
>>> minstrel_ht_tx_status calls minstrel_tx_status, but minstrel_sta_info::r
>>> is not set until rate_init which is after assoc.
>> I'm not sure this is the right fix. If I understand the issue correctly,
>> mi->r is only NULL because .rate_init has not been called yet, which is
>> a bug that other rate control modules might trip over as well, maybe in
>> more subtle ways. If this is the case, then I believe this bug should be
>> fixed in mac80211 instead.
>> 
>> Maybe it would even be a good idea to set a flag after calling
>> rate_control_rate_init, and calling WARN_ON or even BUG_ON when doing tx
>> before that.
>> 
>> - Felix
>> 
> 
> Hi Felix,
> 
> I am not sure I can agree. minstrel_ht allocates the struct
> minstrel_ht_sta_priv initializing is_ht to false thereby choosing a
> default and zero'ing the legacy field. When setting is_ht to false
> consequently the contents of the legacy field should be properly set as
> is done in minstrel_ht_update_caps (at use_legacy label).
Right, minstrel_ht_update_caps initializes that field, and it's always
called from .rate_init.

While the non-HT minstrel initializes that field earlier (because it is
not stored anywhere else), it still also assumes that it isn't asked to
do tx until .rate_init is called.

It doesn't matter whether it crashes in non-HT minstrel or not, the main
issue is that assumptions of both minstrel and minstrel_ht (and possibly
other rate control implementations) are being violated by mac80211.

Before we can address that problem, we need to decide whether we want to
change the code to no longer require .rate_init before tx (which I think
is a bad idea, since there's no list of supported rates available yet at
that point in time), or if we change mac80211 to no longer violate those
assumptions. In either case, this patch is insufficient.

- Felix
