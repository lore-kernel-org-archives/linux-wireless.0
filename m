Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64731 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab0KJUBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 15:01:23 -0500
Received: by bwz15 with SMTP id 15so1122956bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 12:01:21 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
Date: Wed, 10 Nov 2010 21:01:01 +0100
Cc: linux-wireless@vger.kernel.org
References: <1285212541-6834-1-git-send-email-greearb@candelatech.com> <201010162100.02477.chunkeey@googlemail.com> <4CDAF182.4030409@candelatech.com>
In-Reply-To: <4CDAF182.4030409@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201011102101.02263.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 November 2010 20:24:50 Ben Greear wrote:
> On 10/16/2010 12:00 PM, Christian Lamparter wrote:
> > On Thursday 23 September 2010 10:36:58 Johannes Berg wrote:
> >> On Wed, 2010-09-22 at 20:29 -0700, greearb@gmail.com wrote:
> >>> From: Ben Greear<greearb@candelatech.com>
> >>>
> >>> Create 'stations' sub-directory under each netdev:[vif-name]
> >>> directory to hold all stations for that network device.
> >>>
> >>> Signed-off-by: Ben Greear<greearb@candelatech.com>
> >>
> >> Acked-by: Johannes Berg<johannes@sipsolutions.net>
> >
> > ieee80211_debugfs_key_add needs to be updated (debugfs_key.c).
> > Either the "station" symlink has to go, or we need to loop up
> > to which interface the sta belongs. currently it's hard-coded to
> > "sprintf(buf, "../../stations/%pM", sta->sta.addr);"
> > (something which no longer exists)
> 
> To reproduce this problem, do I need to be using WEP, or should
> WPA do the trick?  Or something else?
well, STAs are involved. So you want an encryption which needs/generates
per-station keys. And the setup of choice would be to go with WPA/RSN.

> Are the keys supposed to show up only in STA mode, or also when
> acting as an AP?
They will show up in STA and AP mode.

Regards,
	Chr
