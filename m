Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:55919 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaCFLyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 06:54:18 -0500
Received: by mail-we0-f180.google.com with SMTP id p61so2921541wes.11
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 03:54:17 -0800 (PST)
Date: Thu, 6 Mar 2014 12:54:06 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Bondar, Alexander" <alexander.bondar@intel.com>
Subject: Re: [PATCH 08/36] iwlwifi: mvm: Change power management dependency
 on multi MAC
Message-ID: <20140306115406.GA32396@magnum.frso.rivierawaves.com> (sfid-20140306_125423_009869_D7F16FC0)
References: <20140113111357.GA4611@magnum.frso.rivierawaves.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D3C4A5@HASMSX103.ger.corp.intel.com>
 <20140113124049.GA5796@magnum.frso.rivierawaves.com>
 <52D83C56.5010706@gmail.com>
 <20140116214357.GA10376@gobelin>
 <CANUX_P25Oi=_5RBHKyuWQEZe6DXVyMOFS2xfGfa45HyyJSz=ug@mail.gmail.com>
 <20140306102102.GA15185@magnum.frso.rivierawaves.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D796A6@HASMSX103.ger.corp.intel.com>
 <20140306104936.GA21682@magnum.frso.rivierawaves.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D79794@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D79794@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 06, 2014 at 11:02:48AM +0000, Grumbach, Emmanuel wrote:
> > > On Thu, Mar 06, 2014 at 10:25:34AM +0000, Grumbach, Emmanuel wrote:
> > > > > >
> > > > > > Hi,
> > > > > >
> > > > > > Thanks for the update, indeed monitor is in better shape,
> > > > > > however I am still seeing some issues.
> > > > > > E.g. short-guard or > 20MHz bw frames are not visible when not
> > > > > > aggregated, I still see "Microcode SW error detected." but in a
> > > > > > different scenario (monitoring with main managed iface down,
> > > > > > then upping the main managed iface up), it also seems that we
> > > > > > filter out many frames when the main managed iface is up and/or?
> > > associated.
> > > > > > Also, I started working on AMSDUs this week and yesterday my
> > > > > > laptop crashed immediately when monitoring. This morning I see
> > > > > > that this happens when my aggregates start getting above the ~4k
> > > > > > limit and modprobing with amsdu_size_8K=1 seems to 'fix' the
> > > > > > issue, I guess some places need some oflows checks.
> > > >
> > > > Hmm... Thanks for the heads - up. Do you have the crash data?
> > > >
> > > You mean a pcap of the traffic crashing the system or the iwlmvm data ?
> > > The crashes are severe enough that they hang my whole laptop right away.
> > 
> > Oh ok - I was talking about the WARNING / BUG message whatever.
> > 
> > >
> > > > > > All this with wireless-next@704445d9 (i.e. circa the time I got
> > > > > > your
> > > > > > email) and fw 22.15.8.0.
> > > > > >
> > > > >
> > > > > Please paste the data for the firmware assert. Also, take
> > > > > https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211.git/co
> > > > > mm
> > > > > it/?id=
> > > > > 1c37a72c1bd0b83be8b95cff7f1bc9b1f32bd433 into account.
> > > Attached. Looks like this change will help.
> > >
> > 
> > BTW - newer FW is available: 22.24.8.0
> 
> Just looked at your log - I'd hope the new FW will fix it.
> Can you give it a try?
> 
Just did, seems to fix the issue, thanks.

 
Karl
