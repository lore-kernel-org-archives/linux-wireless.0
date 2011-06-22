Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40922 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1FVJPC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 05:15:02 -0400
Received: by qwk3 with SMTP id 3so279367qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 02:15:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimW6oLjQoEbHGOAnXwbWMYUvK00fw@mail.gmail.com>
References: <BANLkTimW6oLjQoEbHGOAnXwbWMYUvK00fw@mail.gmail.com>
Date: Wed, 22 Jun 2011 11:15:01 +0200
Message-ID: <BANLkTimUc7Gz0AEKKDZinYpGABnDEBMHDA@mail.gmail.com> (sfid-20110622_111508_380689_0D0EB9C4)
Subject: about RCU programming
From: =?ISO-8859-1?Q?Manuel_S=E1ez?= <manuelsaezr@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am trying to include a list o devices to poll to. I am not very
experienced but looking the current kernel code for wireless, I
thought it would be a good idea to use a linked list list_head
protected with RCU and one mutex for the add/delete parts.

I would like to receive the next device to be poll from the list every
time that someone calls the function instead of iterating the whole
list every time to find out the next device to poll. Is it possible to
use a pointer to the head and update the pointer to the next element
of the list? I mean could i do something like this?

The write side could be something like this:
mutex_lock(&sdata->u.ap.polllist_mtx);
list_add_rcu(poll_req->list, sdata->u.ap.polling_list);
mutex_unlock(&sdata->u.ap.polllist_mtx);

and the read side:
rcu_read_lock();
rcu_derreference(sdata->u.ap.polling_list->sta);
copy_sta(sdata->u.ap.polling_list->sta);
rcu_read_unlock();

sdata->u.ap.polling_list = sdata.u.ap.polling_list->next;

Do I need to use the same mutex or is this operation fast enought?

Thank you in advance!
