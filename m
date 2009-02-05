Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:57092 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZBEM0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 07:26:15 -0500
Received: by wf-out-1314.google.com with SMTP id 28so270787wfa.4
        for <linux-wireless@vger.kernel.org>; Thu, 05 Feb 2009 04:26:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1233835647.3931.13.camel@johannes.local>
References: <20090205110631.GA13746@myhost.users.atheros.com>
	 <1233835647.3931.13.camel@johannes.local>
Date: Thu, 5 Feb 2009 17:56:13 +0530
Message-ID: <8e92b4100902050426x5c6a0da5r86c3e6ca945b29c1@mail.gmail.com> (sfid-20090205_132619_307258_7901E67F)
Subject: Re: [PATCH] mac80211: Fix the wrong WARN_ON message appearing on
	enabling power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 5, 2009 at 5:37 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2009-02-05 at 16:36 +0530, Vivek Natarajan wrote:
>> The warning message intended to be hit on driver's rejection of a Tx frame
>> is also hit while the netif_subqueue is stopped. This patch fixes this error
>> case.
>
> This seems a little odd. Why would we be in that code if the queue is
> stopped?

This issue happens only when we are associated with a 11n AP and power
save is enabled.
In the function 'ieee80211_master_start_xmit', ps_disable_work is
queued where wake_queues is called. But before this work is executed,
we check if the queues are stopped in _ieee80211_tx and returned
TX_AGAIN to ieee8011_tx which led to the warning message.

Vivek.
