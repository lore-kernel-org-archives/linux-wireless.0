Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19024 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab0IPEtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 00:49:51 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 21:49:45 -0700
Date: Thu, 16 Sep 2010 10:19:33 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath9k: Fix regression in starting ANI after
	association
Message-ID: <20100916044933.GA30871@vasanth-laptop>
References: <1284560528-8934-1-git-send-email-vasanth@atheros.com> <AANLkTim5xPKBsitVut-74BNM9riL0C95Nqnyj7M5Bg87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <AANLkTim5xPKBsitVut-74BNM9riL0C95Nqnyj7M5Bg87@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 15, 2010 at 09:51:43PM +0530, Luis R. Rodriguez wrote:
> On Wed, Sep 15, 2010 at 7:22 AM, Vasanthakumar Thiagarajan
> <vasanth@atheros.com> wrote:
> > Author: Felix Fietkau <nbd@openwrt.org>
> > Date:   Sat Jul 31 00:11:59 2010 +0200
> >
> >    ath9k: prevent calibration during off-channel activity
> >
> > The above patch checks for off-channel before starting ANI,
> > but when the operating channel is set right after association,
> > IEEE80211_CONF_OFFCHANNEL would be set as still local->tmp_channel
> > is non-NULL. This would result in not starting calibration after
> > the association.

Yes, the bug is in mac80211, but fixing this one in mac80211 looks
not straight forward and probably Felix would know this one better,
for now let me do this in driver and remove it once it is cleanly
fixed in mac80211.

Vasanth
