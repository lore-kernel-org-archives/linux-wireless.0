Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:48587 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759213AbYBEVbs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 16:31:48 -0500
Date: Tue, 5 Feb 2008 22:23:40 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Felix Fietkau" <nbd@openwrt.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Message-ID: <20080205222340.70e043cd@morte> (sfid-20080205_213151_232536_983D36D9)
In-Reply-To: <1ba2fa240802041105g1e11ba99ldaca4acee4a07c35@mail.gmail.com>
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	<47A718CF.50303@openwrt.org>
	<-5971017268625562167@unknownmsgid>
	<1ba2fa240802040621h2c0e9fe6yb5d84d24513aedf4@mail.gmail.com>
	<-7767648866191425885@unknownmsgid>
	<1ba2fa240802040713k56fdf22fp8ab15924bbebe88@mail.gmail.com>
	<47A72E13.8070305@openwrt.org>
	<1ba2fa240802041036v2b311eb4vcced7a9f1e2aa6a0@mail.gmail.com>
	<47A75BF5.90101@openwrt.org>
	<1ba2fa240802041103v622db90co2ddc24eda3347ffc@mail.gmail.com>
	<1ba2fa240802041105g1e11ba99ldaca4acee4a07c35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 4 Feb 2008 21:05:25 +0200
"Tomas Winkler" <tomasw@gmail.com> wrote:

> Sorry I meant
> ieee80211_tx_status {
> >          size_t nrates;
> >          ieee80211_tx_ratectrl  rates[0] ;
> > }

FWIW, I'm OK with this. BTW, further changes to this may be required in
the future as I plan to rework a bit the whole tx_status thing so that
drivers won't have to report ACKed frames but failed and retransmitted
frames only - this would reduce the load on slow buses such as USB.


--
Ciao
Stefano
