Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:63732 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYIHISo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 04:18:44 -0400
Received: by yw-out-2324.google.com with SMTP id 9so144631ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 01:18:42 -0700 (PDT)
Message-ID: <1ba2fa240809080118p26b4d984k57ce0b20a5d2c36a@mail.gmail.com> (sfid-20080908_101851_935501_F9020076)
Date: Mon, 8 Sep 2008 11:18:41 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220860709.31304.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
	 <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com>
	 <1220860709.31304.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 8, 2008 at 10:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-08 at 02:14 +0300, Tomas Winkler wrote:
>
>> why I'm hitting unathorized prot messag for subif_start_xmit.
>> Shouldn't carrier_off(stada->dev) stop the queue?  I haven't seen this
>
> and no, netif_carrier_off() doesn't immediately stop the queues, it just
> schedules the link watch which will _eventually_ remove the qdiscs and
> attach the noop qdisc.

So what you are saying this is expected behavior?

Please remember I'm testing the disassociation
1. AP is should down
2. Switching to another AP -> Legacy <-> HT
3. WPA supplicnat (it uses ieee80211_ioctl_siwmlme)
4. The BA tear down will be unfortunately untested, for now

Tomas
