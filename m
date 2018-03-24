Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:46463 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751755AbeCXKdl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 06:33:41 -0400
Date: Sat, 24 Mar 2018 10:33:35 +0000
In-Reply-To: <155ca60c-48eb-5e64-b514-d9d5556b405c@candelatech.com>
References: <20180202103645.12215-1-toke@toke.dk> <155ca60c-48eb-5e64-b514-d9d5556b405c@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: [PATCH] ath9k: Protect queue draining by rcu_read_lock()
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
CC: stable@vger.kernel.org
From: =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
Message-ID: <AB398EDA-5C30-4FB5-8040-4961954E2127@toke.dk> (sfid-20180324_113344_969426_B2E93A6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 24 March 2018 00:00:39 GMT, Ben Greear <greearb@candelatech=2Ecom> wrot=
e:
>On 02/02/2018 02:36 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> When ath9k was switched over to use the mac80211 intermediate queues,
>> node cleanup now drains the mac80211 queues=2E However, this call path
>is
>> not protected by rcu_read_lock() as it was previously entirely
>internal
>> to the driver which uses its own locking=2E
>
>As far as I can tell, this is not currently in Linus' tree=2E
>
>Was this dropped on purpose?

It was merged quite recently, but hasn't propagated yet:

https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/kvalo/ath=2Egit/commit=
/?h=3Dath-next

-Toke
