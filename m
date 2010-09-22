Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:40019 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab0IVNtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 09:49:36 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 06:49:29 -0700
Date: Wed, 22 Sep 2010 19:19:27 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<nbd@openwrt.org>
Subject: Re: [PATCH 1/3] ath9k: Fix regression in starting ANI after
	association
Message-ID: <20100922134927.GA18450@vasanth-laptop>
References: <1284560528-8934-1-git-send-email-vasanth@atheros.com> <AANLkTim5xPKBsitVut-74BNM9riL0C95Nqnyj7M5Bg87@mail.gmail.com> <20100916044933.GA30871@vasanth-laptop> <AANLkTim8xb3V_QpFm3BEx+W4PD6a3n+JRuZqPDkamtwu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTim8xb3V_QpFm3BEx+W4PD6a3n+JRuZqPDkamtwu@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 07:49:39PM +0530, Luis R. Rodriguez wrote:
> On Wed, Sep 15, 2010 at 9:49 PM, Vasanthakumar Thiagarajan
> <vasanth@atheros.com> wrote:
> > On Wed, Sep 15, 2010 at 09:51:43PM +0530, Luis R. Rodriguez wrote:
> >> On Wed, Sep 15, 2010 at 7:22 AM, Vasanthakumar Thiagarajan
> >> <vasanth@atheros.com> wrote:
> >> > Author: Felix Fietkau <nbd@openwrt.org>
> >> > Date:   Sat Jul 31 00:11:59 2010 +0200
> >> >
> >> >    ath9k: prevent calibration during off-channel activity
> >> >
> >> > The above patch checks for off-channel before starting ANI,
> >> > but when the operating channel is set right after association,
> >> > IEEE80211_CONF_OFFCHANNEL would be set as still local->tmp_channel
> >> > is non-NULL. This would result in not starting calibration after
> >> > the association.
> >
> > Yes, the bug is in mac80211, but fixing this one in mac80211 looks
> > not straight forward and probably Felix would know this one better,
> > for now let me do this in driver and remove it once it is cleanly
> > fixed in mac80211.
> 
> No, please address in mac80211, if we clean this up as a work around
> we likely are overlooking other possible issues which can be affected
> as well.

It is not easy (from my understanding at least) to fix this in
mac80211 as the assumption of off-channel activity (IEEE80211_CONF_OFFCHANNEL)
itself seems to be wrong sometimes (in case of station mode, setting this flag
before the association does not look right). As I dont know any
clean fix in mac80211, this patch can be an interim fix for the
regression.

Vasanth
