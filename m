Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:10082 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYL3Kxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 05:53:45 -0500
Received: by ti-out-0910.google.com with SMTP id b6so8037965tic.23
        for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2008 02:53:43 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18777.64817.29561.776128@localhost.localdomain> (sfid-20081230_115353_430307_53E2DAB8)
Date: Tue, 30 Dec 2008 16:21:29 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, jouni.malinen@atheros.com
Subject: Re: [RFC v2] mac80211: Add 802.11h CSA support
In-Reply-To: <1230633949.3850.11.camel@johannes>
References: <18777.63336.140527.717269@localhost.localdomain>
	<1230633305.3850.2.camel@johannes>
	<18777.64102.60878.194252@localhost.localdomain>
	<1230633949.3850.11.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Yeah I know, I'm just wondering if it's worth saving the lookup in the
> other case by doing the lookup outside of ieee80211_process_chanswitch()
> and in ieee80211_rx_h_action()

Actually, this might be better since I haven't seen any AP send a CSA action
frame, it was always through the beacon that it was announced.
But then, it is not often that an AP would switch channels.
I'll change the interface anyway.

> But the RX stuff (rx_h_action) is from a tasklet or directly from the
> driver, and in the tasklet we can't sleep either, and if we call back
> from ieee80211_rx() into rx_h_action into the driver again via config()
> the driver might not like it? Or am I totally off base right now?

True, I'll add it to the workqueue here.

Sujith
