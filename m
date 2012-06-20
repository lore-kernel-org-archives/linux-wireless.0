Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49240 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab2FTJmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 05:42:54 -0400
Received: by obbtb18 with SMTP id tb18so11343388obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 02:42:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340182500.4655.47.camel@jlt3.sipsolutions.net>
References: <1340017242-6436-1-git-send-email-nataraja@qca.qualcomm.com>
	<1340182500.4655.47.camel@jlt3.sipsolutions.net>
Date: Wed, 20 Jun 2012 15:12:53 +0530
Message-ID: <CAJqpcCQ34PFxAapy0q1WCQQO8NehV+niwEHpbbTDL+e=rJ7X=w@mail.gmail.com> (sfid-20120620_114309_997610_7EE619E9)
Subject: Re: [PATCH 1/2] cfg80211: Support for automatic channel selection in
 AP mode
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vivek Natarajan <nataraja@qca.qualcomm.com>,
	jouni@qca.qualcomm.com, kvalo@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 2:25 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-06-18 at 16:30 +0530, Vivek Natarajan wrote:
>> If the driver sets WIPHY_FLAG_SUPPORTS_ACS, auto_channel_select
>> is passed to the driver as ap settings and frequency setting is
>> skipped. When the AP mode comes up in the new channel, it is
>> intimated to cfg80211 through cfg80211_ch_switch_notify which
>> in turn notifies the channel information to wpa_supplicant
>> through CH_SWITCH event.
>>
>> Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
>> ---
>> v2: Add a new flag attribute for _START_AP command to indicate ACS request.
>>     Update the channel/frequency information using ch_switch_notify
>>     once the driver (firmware) has selected the channel.
>>
>> For P2P, the operating channel needs to be known before group negotiation starts.
>> This is true in case of P2P GO or client. It needs a separate p2p command from
>> wpa_cli to get the acs-based best channel information from the driver.
>
> So .. is there any reason to not do only the second, and then pass that
> channel back here instead?

So, what you recommend is, for both AP and P2P GO modes, the logic
should be to request the driver for best channel, then the best
channel information event to be passed to userspace and then starting
the AP/GO mode of operation.
The current ath6kl firmware has some limitation for getting this
channel information separately and hence not yet implemented this.
Moreover this needs to be a synchronous operation: to request and get
the event for best channel after a full cycle of channel assessment is
done.

Vivek.
