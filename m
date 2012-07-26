Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52830 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2GZSlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 14:41:42 -0400
Received: by gglu4 with SMTP id u4so2307934ggl.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2012 11:41:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfcrb9=XQauvbPzw2t_jMoQisrh5aSB1qwpLxXsKJKy2Yg@mail.gmail.com>
References: <1343318961-46933-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <1343319453.4477.2.camel@jlt3.sipsolutions.net> <1343319579.4477.3.camel@jlt3.sipsolutions.net>
 <501170F2.3050300@net.t-labs.tu-berlin.de> <CA+XVXfegYYwc=esyZmJHu1tEqQKcq+h+MnSyp9dXiiwqroG3tw@mail.gmail.com>
 <CA+XVXfcrb9=XQauvbPzw2t_jMoQisrh5aSB1qwpLxXsKJKy2Yg@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 26 Jul 2012 21:41:25 +0300
Message-ID: <CA+XVXfe1uomu4XYD33==bFFozbo9k4mkqC1PE1ORnvVN_1PeTg@mail.gmail.com> (sfid-20120726_204145_893091_5C59401C)
Subject: Re: [PATCH v6] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org, ilw@linux.intel.com,
	users@rt2x00.serialmonkey.com, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com, chunkeey@googlemail.com,
	buytenh@wantstofly.org, dsd@gentoo.org, coelho@ti.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 26, 2012 at 8:04 PM, Arik Nemtsov <arik@wizery.com> wrote:
> On Thu, Jul 26, 2012 at 7:57 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> On Thu, Jul 26, 2012 at 7:31 PM, Thomas Huehn
>> <thomas@net.t-labs.tu-berlin.de> wrote:
>>> Hi Johannes,
>>>
>>> Johannes Berg schrieb:
>>>
>>>>>
>>>>> /home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/tx.c: In
>>>>> function ‘wl1271_skb_queue_head’:
>>>>> /home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/tx.c:622:48:
>>>>> warning: ‘hlid’ may be used uninitialized in this function
>>>>> [-Wuninitialized]
>>>>
>>>> Those changes make no sense anyway -- you should be able to pass the
>>>> station pointer through if it previously used info->control.sta, instead
>>>> of doing an (expensive) lookup.
>>>
>>>
>>> This is the call path
>>>
>>> in main.c ... INIT_WORK(&wl->tx_work, wl1271_tx_work);
>>>  jumps to tx.c...wl1271_tx_work(struct work_struct *work)
>>>   calls wl1271_tx_work(struct work_struct *work)
>>>    calls wlcore_tx_work_locked(struct wl1271 *wl)
>>>     calls wl1271_skb_queue_head()
>>>      calls wl12xx_tx_get_hlid()
>>>       calls wl12xx_tx_get_hlid_ap() .... where sta is needed.
>>>
>>> But I could not find any point in the call path where I could grab the
>>> sta pointer and pass it through. I will move the rcu into
>>> wl12xx_tx_get_hlid_ap(), but I do not see any cheaper way here as using rcu.
>>
>> I agree with Johannes. The find_sta() in the Tx path is unacceptable.
>>
>> A relatively simple change here would be to put the sta pointer in the
>> portion of the struct reserved for rate control during op_tx(). wlcore
>> doesn't use software rate control anyway.
>> This would avoid from changing the code too much.
>
> Johannes correctly pointed out that the sta may no longer be valid
> when the skb is dequeued (which is a bug today as well). It's best to
> just store the hlid in the rate control portion.

Better to just wait some time. I wrote up something to make it much
easier for you. Waiting for some internal review before sending it up.

Arik
