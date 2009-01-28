Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:22511 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZA1UBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 15:01:51 -0500
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WARN_ON message hit on enabling power save.
References: <20090128160332.GA10883@myhost.users.atheros.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 28 Jan 2009 21:59:15 +0200
In-Reply-To: <20090128160332.GA10883@myhost.users.atheros.com> (ext Vivek Natarajan's message of "Wed\, 28 Jan 2009 17\:03\:32 +0100")
Message-ID: <87wscffbho.fsf@nokia.com> (sfid-20090128_210154_909807_FD792550)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> Hello Kalle,

Hi Vivek,

> In the function 'ieee80211_master_start_xmit',
> ieee80211_stop_queues_by_reason is called and a  ps_disable_work is
> queued where wake_queues is called. Can you please clarify me on why the
> queues are stopped and started.

Originally they were in ieee80211_subif_start_xmit() before you moved
them. The reason why added them was to preserve the order of first
disabling IEEE80211_CONF_PS and after that sending the data frames.
Because ieee80211_hw_config() must sleep, I decided to do it in a
workqueue.

> If at all that needs to be stopped, wouldn't
> ieee80211_dynamic_ps_enable_work be a better place to do it?

That's was too late. In that case some of the date frames might have
been already transmitted to the driver before IEEE80211_CONF_PS is
disabled.

> The issue is  while this ps_disable_work is queued,
> netif_subqueue_stopped() is checked in _ieee80211_tx which ultimately
> results in a WARN_ON(info->flags & IEEE80211_TX_CTL_AMPDU) in
> ieee80211_tx. Please see the code for clarification.
>
> So, while I try to ping after enabling power save, the packets are
> dropped due to this warning. The warning message is not at all
> related to the issue and hence I feel that this is an inappropriate
> place for that WARN_ON.
>
> The fix for the issue is to remove the stop/start queues if it is not
> really needed or the better fix is to remove this inappropriate warning
> message. Please clarify me if I'm wrong.

Unfortunately I'm not familiar with the 11n implementation. I will
take a look at this more closely tomorrow and will get back to you.

-- 
Kalle Valo
