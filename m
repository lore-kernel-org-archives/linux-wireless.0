Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35555 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab1HaBur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 21:50:47 -0400
Received: by gya6 with SMTP id 6so185317gya.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 18:50:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPjQAd9Fyu-MQSvi+aa4VwwWBTo_Brf=jCvAEnLdQZaJvjvu=Q@mail.gmail.com>
References: <1314706867.4011.25.camel@jlt3.sipsolutions.net>
 <1314728954-22646-1-git-send-email-javier@cozybit.com> <1314729813.4011.43.camel@jlt3.sipsolutions.net>
 <CAPjQAd9Fyu-MQSvi+aa4VwwWBTo_Brf=jCvAEnLdQZaJvjvu=Q@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 30 Aug 2011 18:50:25 -0700
Message-ID: <CAPjQAd-CLvvn_1efsC_FjgoPSkyxiXC3c9yDGFzgPC4ts9Ay3w@mail.gmail.com> (sfid-20110831_035050_523745_83C7CEC1)
Subject: Re: [PATCH] mac80211: Defer tranmission of mesh path errors
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 2:38 PM, Javier Cardona <javier@cozybit.com> wrote:
> On Tue, Aug 30, 2011 at 11:43 AM, Johannes Berg
>> But that's not a big thing. Have you tested it? I'm wondering if because
>> we take a lock here we might run into lock dependencies issues (lockdep
>> would say) but I don't think so because stop_queue etc. all take the
>> same lock from an arbitrary driver context already.
>
> We don't have a test specific for that particular perr.  Other tests
> run fine and lockdep does not complain.
> I can resubmit the patch with the clearer comment once we've run our
> whole test suite if that gives you peace of mind.

The stress tests do trigger perrs and, with this change, we see a
warning due to missing info->control.vif

[14202.988077] ------------[ cut here ]------------
[14202.988351] WARNING: at net/mac80211/util.c:358
ieee80211_add_pending_skb+0x97/0xa0()
[14202.988353] Hardware name: Bochs
[14202.988355] Modules linked in: mac80211_hwsim [last unloaded: mac80211_hwsim]
[14202.988359] Pid: 15051, comm: iperf Tainted: G        W   3.1.0-rc4-wl+ #47
[14202.988361] Call Trace:
[14202.988364]  [<c103ad2d>] warn_slowpath_common+0x6d/0xa0
[14202.988367]  [<c15fbca7>] ? ieee80211_add_pending_skb+0x97/0xa0
[14202.988370]  [<c15fbca7>] ? ieee80211_add_pending_skb+0x97/0xa0
[14202.988373]  [<c103ad7d>] warn_slowpath_null+0x1d/0x20
[14202.988376]  [<c15fbca7>] ieee80211_add_pending_skb+0x97/0xa0
[14202.988379]  [<c1605ab1>] mesh_path_error_tx+0x151/0x190
[14202.988382]  [<c160362b>] mesh_path_discard_frame+0xfb/0x100
[14202.988385]  [<c1603580>] ? mesh_path_discard_frame+0x50/0x100
[14202.988387]  [<c1605dd7>] mesh_nexthop_lookup+0x157/0x1d0
[14202.988390]  [<c1605c80>] ? mesh_queue_preq+0x190/0x190
[14202.988393]  [<c15f826a>] ieee80211_xmit+0x10a/0x240
[14202.988395]  [<c15f8160>] ? ieee80211_tx+0xe0/0xe0
[14202.988398]  [<c15f5c3a>] ? ieee80211_skb_resize+0x7a/0x100
[14202.988401]  [<c15f8ba7>] ieee80211_subif_start_xmit+0x307/0x810
[14202.988404]  [<c15f8cf8>] ? ieee80211_subif_start_xmit+0x458/0x810

I'll look into it tomorrow.

Cheers,

j



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
