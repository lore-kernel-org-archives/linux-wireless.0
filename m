Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:63104 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbZBPKJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 05:09:40 -0500
Received: by gxk22 with SMTP id 22so2849331gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 02:09:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234778113.4219.117.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-10-git-send-email-lrodriguez@atheros.com>
	 <1234696212.4219.60.camel@johannes.local>
	 <43e72e890902160148n5a383a96t8e20dc4bc9d10687@mail.gmail.com>
	 <1234778113.4219.117.camel@johannes.local>
Date: Mon, 16 Feb 2009 02:09:39 -0800
Message-ID: <43e72e890902160209q2106331ds540a711e9badfa3f@mail.gmail.com> (sfid-20090216_110943_946881_9117E065)
Subject: Re: [PATCH 09/10] cfg80211: move regulatory hints to workqueue
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 1:55 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-02-16 at 01:48 -0800, Luis R. Rodriguez wrote:
>
>> > Are you sure the mutex order reg_mutex --> cfg80211_mutex is a good
>> > idea? Is there a need for two locks at all?
>>
>> I think so. So reg_mutex would prevent any new requests to be added
>> into the queue, that's the only thing that mutex protects. Once you
>> are sure you have no one adding requests to the queue you then need to
>> ensure no one is processing a regulatory request and hence the
>> cfg80211_mutex.
>>
>> We need to protect the queue from additions to the queue from having
>> the workqueue process it.
>
> Maybe just use a spinlock for the list, and do the loop manually like in
> mac80211/key.c then?
>
>        spin_lock(&todo_lock);
>        while (!list_empty(&todo_list)) {
>                key = list_first_entry(&todo_list, struct ieee80211_key, todo);
>                list_del_init(&key->todo);
>                spin_unlock(&todo_lock);
> ........
>                spin_lock(&todo_lock);
>        }
>        spin_unlock(&todo_lock);

Sure, is the benefit you see that we won't contend userspace longer if
the workqueue is busy?

  Luis
