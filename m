Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.241]:50338 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751604AbXLNONs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 09:13:48 -0500
Received: by hs-out-2122.google.com with SMTP id 54so1117803hsz.5
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2007 06:13:46 -0800 (PST)
Message-ID: <1ba2fa240712140613p59e1d9fsf214310d8d9a66fd@mail.gmail.com> (sfid-20071214_141352_381698_5E77E584)
Date: Fri, 14 Dec 2007 16:13:45 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [FYI] hostapd with mac80211 progress
Cc: linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>, "Jouni Malinen" <j@w1.fi>,
	hostap <hostap@shmoo.com>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1197631052.16079.26.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1197512614.6558.224.camel@johannes.berg>
	 <1197631052.16079.26.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 14, 2007 1:17 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >  * set_tx_queue_params
>
> Actually, I wonder if any of that should be implemented in the wireless
> classifier. Well, what I'm thinking is that we should make mac80211
> provide multiqueue netdevs with four queues and then write a new 802.11
> classifier that is attached in the sch_fifo qdisc. Then, the queue
> parameters could be configured with the 802.11 qdisc.
>
> Tomas, you said you might look into the QoS stuff, any ideas?
>
This is a bit more complicated then that
 In HT aggregation we have more then 4 queues. In theory you have TID
X receiving address queues. Number of TIDs is 16 yet for the
aggregation on 8 are relevant.Let say your AP supports 32 connected
stations so you need 256 queues for to keep packets in order. Of
course in HW you keep smaller number..etc.
Ron will send RX AMSDU aggregation patches at the beginning of the
next week, then he will work on TX side. I suggest that in that
context we can open the discussion how to solve the QoS queues and
Qdisc cleanly.

Tomas

> johannes
>
