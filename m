Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44772 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749AbYIHPLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 11:11:04 -0400
Date: Mon, 8 Sep 2008 12:10:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] Ath9k: Add RF kill support.
Message-ID: <20080908151057.GB22081@khazad-dum.debian.net> (sfid-20080908_171109_964447_9A3D9855)
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com> <1220721347.6714.114.camel@californication> <20080908045926.GA28149@vasanth-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080908045926.GA28149@vasanth-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 08 Sep 2008, Vasanthakumar Thiagarajan wrote:
> On Sat, Sep 06, 2008 at 10:45:47PM +0530, Marcel Holtmann wrote:
> > > CONFIG_ATH9K_RFKILL needs to be set
> > > to enable this support.
> > 
> > why do we have to introduce yet another config option for this? What is
> > the advantage of disabling RFKILL support? I really don't see it and all
> > these extra config options are rather confusing than useful.
> Normally home users may not hit a situation where they have to
> disable the radio, so they can compile out the rf kill support
> and essentially disable the periodic run of the work queue 
> (rfkill_poll ,runs for every 2 secs).If this does not make 
> any sense, I will remove this config option.

What doesn't make sense at all is to have it manually selectable.  Just
define it to the same value of CONFIG_RFKILL, or use CONFIG_RFKILL directly
outright.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
