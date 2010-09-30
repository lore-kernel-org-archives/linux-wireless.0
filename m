Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:11115 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752093Ab0I3BrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 21:47:03 -0400
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0533081218
	for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 10:47:00 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH] ath5k: vif adhoc fixup
Date: Thu, 30 Sep 2010 10:46:50 +0900
Cc: linux-wireless@vger.kernel.org
References: <20100929092221.12160.62425.stgit@tt-desk> <4CA36D14.9080400@candelatech.com>
In-Reply-To: <4CA36D14.9080400@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201009301046.50288.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu September 30 2010 01:45:08 Ben Greear wrote:
> > i made these changes on top of your v7 patch, please tell me what you
> > think! and feel free to merge the changes into your patch, if you agree
> > with them.
> 
> I'll merge them in and do some quick testing and re-post the full
> patch.

thanks!
 
> For STAs, I use the can-scan-one logic so that after the first interface
> associates, future automated scans will not scan more than the single
> channel. That helps keep us on the same channel.
> 
> But, if all interfaces disassociate, then full scans will happen again,
> and the first interface to associate gets to choose the channel.
> 
> If the channel is changed for any reason, all of the old stations are
> un-associated and attempt full rescan to re-associate.
> 
> That scan-one logic is probably not going into the upstream kernel though,
> so to keep confusion to a minimum, you would have to make sure that
> your STAs are all configured for APs on the same channel.

that makes sense.
 
> In general, APs and STAs have worked well together for us..but we have
> never used adhoc.  It sounds to me like you know a lot more about this
> stuff than I do, so perhaps you can make more progress.

maybe, but i'm not sure if i can spend much time on this. as i said i'm fine 
as long as one ad-hoc interface per device works and if we can have multiple 
AP interfaces on another device.

if someone is interested in ad-hoc + STA or ad-hoc + AP interfaces, basically 
we would need to test:
- can we have the HW in ad-hoc mode and still have AP interfaces?
- can we have the HW in ad-hoc mode and still have STA interfaces?
- if that's not possible, there have been patches for madwifi, which runs ad-
hoc interfaces with the hardware configured in AP mode, but this has some 
disadvantages (like no TSF sync, no beacon backoff).

i'm not sure if we should disable ad-hoc + other interfaces in the mean time 
or leave it open for others to test??? maybe i can give it a short try today?

> If we can get agreement on the patch as is (with your changes included),
> I'd love to get it pushed upstream.  Then folks can improve it further.

sure. i tested v7 + my changes for the last 12 hours, using 2 WPA and 2 non-
encrypted AP interfaces with concurrent iperf traffic and ping without 
problems. one ad-hoc interface works as well. i think the problems i saw last 
time were due to dupliacte mac addresses. so i'll checkout your v8 patch and 
then let's see to get it merged! :)

bruno
