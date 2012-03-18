Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab2CRQcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2012 12:32:39 -0400
Subject: Re: [PATCH] mac80211: fix the endianness problem of HWMP sequence
 number in RANN propagation
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	devel@lists.open80211s.org
In-Reply-To: <CAEFj9861XC5rvBBB3DxLaPDrYFz7FECA82KpEF+L6rMsK1F6Sw@mail.gmail.com> (sfid-20120318_171207_535953_770C2624)
References: <1331923430-23861-1-git-send-email-yeohchunyeow@gmail.com>
	 <1331901642.6753.1.camel@jlt3.sipsolutions.net>
	 <CAEFj9861XC5rvBBB3DxLaPDrYFz7FECA82KpEF+L6rMsK1F6Sw@mail.gmail.com>
	 (sfid-20120318_171207_535953_770C2624)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Mar 2012 17:32:35 +0100
Message-ID: <1332088355.3354.0.camel@jlt3.sipsolutions.net> (sfid-20120318_173242_352198_06B77E6A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > You should mark struct ieee80211_rann_ie to contain __le32, so that
> > sparse will warn about things like this.
> >
> 
> I try to change u32 to __le32 for the following members in struct
> ieee80211_rann_ie.
> 
> struct ieee80211_rann_ie {
>         u8 rann_flags;
>         u8 rann_hopcount;
>         u8 rann_ttl;
>         u8 rann_addr[6];
>         __le32 rann_seq;
>         __le32 rann_interval;
>         __le32 rann_metric;
> } __attribute__ ((packed));
> 
> But when I compile using "make C=2 CF=-D__CHECK_ENDIAN__", I don't see
> any sparse warning on this.

Not sure, if I make the above change I get:

  CHECK   net/mac80211/mesh_hwmp.c
net/mac80211/mesh_hwmp.c:751:17: warning: incorrect type in assignment (different base types)
net/mac80211/mesh_hwmp.c:751:17:    expected unsigned int [unsigned] [usertype] orig_sn
net/mac80211/mesh_hwmp.c:751:17:    got restricted __le32 [usertype] rann_seq
net/mac80211/mesh_hwmp.c:754:16: warning: incorrect type in assignment (different base types)
net/mac80211/mesh_hwmp.c:754:16:    expected unsigned int [unsigned] [usertype] metric
net/mac80211/mesh_hwmp.c:754:16:    got restricted __le32 [usertype] rann_metric

johannes

