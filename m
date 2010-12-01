Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:40262 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752623Ab0LAKVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 05:21:37 -0500
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0295348893
	for <linux-wireless@vger.kernel.org>; Wed,  1 Dec 2010 19:21:36 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: sedat.dilek@gmail.com
Subject: Re: [linux-next] next-20101201: ath5k permanently disconnecting
Date: Wed, 1 Dec 2010 19:21:11 +0900
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
References: <AANLkTi=_F0orXPY79ojoPKEqn4ohQjV5Rj5Qb3H7CR8f@mail.gmail.com>
In-Reply-To: <AANLkTi=_F0orXPY79ojoPKEqn4ohQjV5Rj5Qb3H7CR8f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201012011921.11151.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed December 1 2010 19:09:03 Sedat Dilek wrote:
> Hi,
> 
> I have built today a linux-next (next-20101201) kernel which includes
> wireless-next-2.6 up to master-2010-11-30.
> 
> >From tig utility:
> 2010-11-30 15:33 Stanislaw Gruszka  [wireless-next-2.6] iwlagn: fix
> microcode error on 4965
> [main] 61790c5f3c5f158821821a00797d94504531839f - commit 1929 of 226338
> (0%)
> 
> Unfortunately, my wlan network connection is totally unstable.
> 
> $ dmesg | grep "RX AssocResp" | wc -l
> 216
> 
> The block looks like this:
> [ 4436.504059] ieee80211 phy0: wlan0: No probe response from AP
> 00:04:0e:e4:00:3d after 500ms, disconnecting.
> [ 4436.504490] cfg80211: Calling CRDA to update world regulatory domain
> [ 4440.677020] wlan0: authenticate with 00:04:0e:e4:00:3d (try 1)
> [ 4440.679096] wlan0: authenticated
> [ 4440.679158] wlan0: associate with 00:04:0e:e4:00:3d (try 1)
> [ 4440.684667] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411
> status=0 aid=1)
> [ 4440.684673] wlan0: associated
> 
> My wlan device is an ath5k:
> 
> $ lspci -nnvv | grep "Ethernet controller" | grep -i ath
> 02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
> 802.11abg NIC [168c:1014] (rev 01)
> 
> Any idea what's wrong? (Just speculating on the last patch-set from
> Nick...) How can I help to dig into this problem?
> Debug-session with wpasupplicant? Which kernel-parameters (debug) to
> be considered/set?

1.) For identification of the chipset, please:
dmesg |grep "ath5.*chip"

2.) Is there a problem when you don't use encryption?

3.) git bisect might help track it down.

bruno
