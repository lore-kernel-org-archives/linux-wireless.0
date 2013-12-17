Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:58398 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3LQOov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 09:44:51 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: Re: [PATCH v5] cfg80211: fix dfs channel state after stopping AP
Date: Tue, 17 Dec 2013 15:44:48 +0100
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <1387209049-25529-1-git-send-email-marek.puzyniak@tieto.com>
In-Reply-To: <1387209049-25529-1-git-send-email-marek.puzyniak@tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201312171544.48479.sw@simonwunderlich.de> (sfid-20131217_154454_532528_BEDB795A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> In AP mode DFS channel state is changed to DFS_AVAILABLE
> after successful CAC and remains as such until a radar
> signal is detected during the In-Service Monitoring.
> When AP is stopped it is no longer monitoring current channel
> for radar signals. DFS channel state should be changed
> to DFS_USABLE when last AP interface is stopped. Starting AP
> again on that channel will start CAC instead of starting radiation.
> 

Sorry for answering after so many revisions, but ... why do you think this is 
required? Many APs first do a CAC on all available channels, but then pick one 
channel and use that, while being able to switch to another channel 
immediately.

WIth this patch (if I understand that correctly), this is not possible 
anymore. Why do you think it is required? I can not find this requirement in 
ETSI, at least.

To quote from ETSI 301.893:

Once the RLAN has started operations on an Available Channel, then that 
channel becomes an Operating Channel. During normal operation, the master 
device shall monitor all Operating Channels (In-Service Monitoring) to ensure 
that there is no radar operating within these channel(s). If no radar was 
detected on an Operating Channel but the RLAN stops operating on that channel, 
then the channel becomes an Available Channel.

I think this patch is wrong and should not be applied.

Thanks,
    Simon
