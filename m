Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51252 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3LJRXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 12:23:51 -0500
Received: by mail-ie0-f182.google.com with SMTP id as1so9160415iec.27
        for <linux-wireless@vger.kernel.org>; Tue, 10 Dec 2013 09:23:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52A74A7F.5000309@open-mesh.com>
References: <1386693598-3934-1-git-send-email-antonio@meshcoding.com>
	<CAB3XZEfwLk5PUp34hQ_8Uog6T8BHRP6akW4SThjXjgAQRAhC-Q@mail.gmail.com>
	<52A74A7F.5000309@open-mesh.com>
Date: Tue, 10 Dec 2013 19:23:51 +0200
Message-ID: <CAB3XZEe9ZGvn+1P6-eb-vq2yfkx97QheZ002bYYbN0wtYNqK_g@mail.gmail.com> (sfid-20131210_182355_315481_A962AF53)
Subject: Re: [RFC 1/2] mac80211: iterate over vif using RCU
From: Eliad Peller <eliad@wizery.com>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: Antonio Quartulli <antonio@meshcoding.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 10, 2013 at 7:08 PM, Antonio Quartulli
<antonio@open-mesh.com> wrote:
>>> Moreover, why do we use list_for_each_entry_safe() is ieee80211_iter_keys() if
>>> the list cannot be altered (pointer to key is not passed to iter() so we should
>>> be sure that nobody is going to invoke list_del())?
>>
>> see the documentation of ieee80211_remove_key():
>
> This function does not exist anymore
>
it does seem to exist here :)
https://git.kernel.org/cgit/linux/kernel/git/linville/wireless-next.git/tree/include/net/mac80211.h

Eliad.
