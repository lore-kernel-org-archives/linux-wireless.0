Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.186]:16646 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYIHIqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 04:46:43 -0400
Received: by gv-out-0910.google.com with SMTP id e6so161657gvc.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 01:46:41 -0700 (PDT)
Message-ID: <1ba2fa240809080146o93200eetcf8e142f6ef4a2b1@mail.gmail.com> (sfid-20080908_104646_717295_53D9A2A9)
Date: Mon, 8 Sep 2008 11:46:41 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220863139.31304.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
	 <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com>
	 <1220863139.31304.33.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 8, 2008 at 11:38 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-08 at 02:14 +0300, Tomas Winkler wrote:
>
>> Shouldn't carrier_off(stada->dev) stop the queue?  I haven't seen this
>> before.
>
> The other question is whether we should be doing netif_carrier_off() at
> all since that throws away frames from the queue and attaches a noop
> qdisc. When we're roaming quickly between two APs, we don't necessarily
> want that, but we don't actually know whether or not we'll be able to
> get back to an AP quickly when we disassociate for whatever reason.
>
we should stop the wlan0 not the master device. Only data frames
should be stopped.
Tomas
