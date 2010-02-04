Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45730 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab0BDKPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 05:15:08 -0500
Received: by vws20 with SMTP id 20so846924vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 02:15:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265271286.29119.96.camel@johannes.local>
References: <1265266442-6273-1-git-send-email-vnatarajan@atheros.com>
	 <1265266442-6273-2-git-send-email-vnatarajan@atheros.com>
	 <1265271286.29119.96.camel@johannes.local>
Date: Thu, 4 Feb 2010 15:45:07 +0530
Message-ID: <8e92b4101002040215ma7b5a85x9354bbb3ce675cbe@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] mac80211: Reset dynamic ps timer in Rx path.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org, kvalo@iki.fi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 4, 2010 at 1:44 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2010-02-04 at 12:24 +0530, Vivek Natarajan wrote:
>> If there is a continuous Rx UDP traffic with power save enabled,
>> there is some loss of packets with ath9k as Atheros chipsets
>> need to be awake to do Rx, unlike other vendor chipsets.
>
> That sentence doesn't make a whole lot of sense, all chips need to be
> awake to RX ;)
>
> IOW, I think the flag is probably useless?

I believe, in wl12xx or p54 chipsets, Rx engine is always awake eventhough
power save  might have been enabled. But with Atheros, it is completely
shut off. Hence I had to use a flag in order to avoid disturbing the
other drivers. Without the flag,it may end up in increasing the average power
consumption for other drivers.

Thanks
Vivek
