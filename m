Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35939 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab2BHQqw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 11:46:52 -0500
Received: by iacb35 with SMTP id b35so1101588iac.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2012 08:46:51 -0800 (PST)
Message-ID: <4F32A6AA.6060508@lwfinger.net> (sfid-20120208_174655_321568_C5EC49F7)
Date: Wed, 08 Feb 2012 10:45:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	Felix Fietkau <nbd@openwrt.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: minstrel_ht: fix NULL pointer dereference
 during auth/assoc
References: <1328705077-31360-1-git-send-email-arend@broadcom.com> <4F329DE5.20408@openwrt.org> <4F32A263.5050909@broadcom.com>
In-Reply-To: <4F32A263.5050909@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2012 10:27 AM, Arend van Spriel wrote:
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
>>>          int i = rix;
>>>          for (i = rix; i>= 0; i--)
>>>                  if (mi->r[i].rix == rix)
>>>    48:   3b 58 04                cmp    0x4(%eax),%ebx
>>>    4b:   74 4b                   je     98<minstrel_tx_status+0x98>
>>>    4d:   83 c2 01                add    $0x1,%edx
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

Once you settle on a "final" patch, I can test it as I can force the crash 
nearly instantly.

Larry

