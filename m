Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39089 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaCFKtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 05:49:47 -0500
Received: by mail-wg0-f46.google.com with SMTP id z12so2888066wgg.29
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 02:49:46 -0800 (PST)
Date: Thu, 6 Mar 2014 11:49:36 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Bondar, Alexander" <alexander.bondar@intel.com>
Subject: Re: [PATCH 08/36] iwlwifi: mvm: Change power management dependency
 on multi MAC
Message-ID: <20140306104936.GA21682@magnum.frso.rivierawaves.com> (sfid-20140306_114951_973580_D4A9A916)
References: <52B0B72A.5070704@gmail.com>
 <1387313079-28123-8-git-send-email-egrumbach@gmail.com>
 <20140113111357.GA4611@magnum.frso.rivierawaves.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D3C4A5@HASMSX103.ger.corp.intel.com>
 <20140113124049.GA5796@magnum.frso.rivierawaves.com>
 <52D83C56.5010706@gmail.com>
 <20140116214357.GA10376@gobelin>
 <CANUX_P25Oi=_5RBHKyuWQEZe6DXVyMOFS2xfGfa45HyyJSz=ug@mail.gmail.com>
 <20140306102102.GA15185@magnum.frso.rivierawaves.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D796A6@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D796A6@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Mar 06, 2014 at 10:25:34AM +0000, Grumbach, Emmanuel wrote:
> > >
> > > Hi,
> > >
> > > Thanks for the update, indeed monitor is in better shape, however I am
> > > still seeing some issues.
> > > E.g. short-guard or > 20MHz bw frames are not visible when not
> > > aggregated, I still see "Microcode SW error detected." but in a
> > > different scenario (monitoring with main managed iface down, then
> > > upping the main managed iface up), it also seems that we filter out
> > > many frames when the main managed iface is up and/or? associated.
> > > Also, I started working on AMSDUs this week and yesterday my laptop
> > > crashed immediately when monitoring. This morning I see that this
> > > happens when my aggregates start getting above the ~4k limit and
> > > modprobing with amsdu_size_8K=1 seems to 'fix' the issue, I guess some
> > > places need some oflows checks.
> 
> Hmm... Thanks for the heads - up. Do you have the crash data?
> 
You mean a pcap of the traffic crashing the system or the iwlmvm data ?
The crashes are severe enough that they hang my whole laptop right away.

> > > All this with wireless-next@704445d9 (i.e. circa the time I got your
> > > email) and fw 22.15.8.0.
> > >
> > 
> > Please paste the data for the firmware assert. Also, take
> > https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211.git/commit/?id=
> > 1c37a72c1bd0b83be8b95cff7f1bc9b1f32bd433 into account.
Attached. Looks like this change will help.

 
Karl

--h31gzZEtNLTqOjlF
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="iwlmvm.txt.gzip"
Content-Transfer-Encoding: base64

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

--h31gzZEtNLTqOjlF--
