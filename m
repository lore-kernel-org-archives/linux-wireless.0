Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64221 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab2COI5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 04:57:18 -0400
Date: Thu, 15 Mar 2012 14:27:38 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Bing Zhao <bzhao@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 3.5] cfg80211: enforce lack of interface combinations
Message-ID: <20120315085736.GB17590@vasanth-laptop> (sfid-20120315_095724_892916_33F9FFC2)
References: <20120313150613.300612962@sipsolutions.net>
 <20120315084217.GA17590@vasanth-laptop>
 <1331801488.3432.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1331801488.3432.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2012 at 09:51:28AM +0100, Johannes Berg wrote:
> On Thu, 2012-03-15 at 14:12 +0530, Vasanthakumar Thiagarajan wrote:
> > On Tue, Mar 13, 2012 at 04:06:03PM +0100, Johannes Berg wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > > 
> > > My grand plan to allow drivers to gradually move over
> > > to advertising virtual interface combinations and only
> > > enforce with drivers that do want it enforced doesn't
> > > seem to be working out, only Christian ever added the
> > > advertising (to carl9170), nobody else did.
> > > 
> > > Begin enforcing combinations in cfg80211 so that users
> > > can rely on the information reported about a device.
> > 
> > This breaks ath6kl AP mode and P2P, is it expected that the driver
> > needs to register the combination (?) even it supports a single
> > interface?
> 
> Kalle tells me that ath6kl does support multiple virtual interfaces, but
> if it didn't then it wouldn't have to register combinations.
> 
> I suspect you're using
> driver_param=use_p2p_group_interface=1
> in wpa_supplicant?

Actually, I verified only AP mode, since it affects any sort of change interface,
I mentioned P2P as well. AP is expected to work without any issue right?.

Vasanth
