Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:5914 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab2LMUrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 15:47:47 -0500
Date: Thu, 13 Dec 2012 12:51:16 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W . Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v10 0/3] wireless: Driver for 60GHz card wil6210
Message-ID: <20121213205116.GQ15974@pogo> (sfid-20121213_214751_845988_F539284B)
References: <1355327278-12965-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1355328278.9708.15.camel@jlt4.sipsolutions.net>
 <2874864.eaglUHDoO0@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <2874864.eaglUHDoO0@lx-vladimir>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 12, 2012 at 06:25:06PM +0200, Vladimir Kondratiev wrote:
> On Wednesday, December 12, 2012 05:04:38 PM Johannes Berg wrote:
> > On Wed, 2012-12-12 at 17:47 +0200, Vladimir Kondratiev wrote:
> > 
> > > Vladimir Kondratiev (3):
> > >   wireless: Driver for 60GHz card wil6210
> > 
> > Since you didn't want to hear my objections on the iftype usage ...
> > maybe you should not Cc me any more.
> > 
> > johannes
> > 
> 
> Johannes,
> 
> I do hear it, and I agree with it!!!
> 
> I will work to support this new
> iftype, PBSS, properly. I just don't have enough data to do it right
> now. Thus, I want initial driver for the 1-st ever 60g card to be merged;
> this will serve as test bed for the next framework modifications.
> 
> I recall, you was asking me why do I pushing to do 60g related
> infrastructure changes when no one driver exists. I want to address this
> and then return to the infrastructure.
> 
> Let's have at least something working as 1-st step. Now, I need to assemble
> all pieces of the puzzle:
> 
> - initial infrastructure (done)
> - minimal driver (these patches)
> - tools (wpa_supplicant partially done, other patches sent; iw - partially done)
> - regulatory - patches submitted.
> 
> Then, when minimal support will be in place, I can handle new features.
> 
> Hope it explain why I want to merge minimal driver 1-st.

Vladimir, please only enable monitor support and STA mode to
be used on the upstream driver submission. If you want PCP mode
you'll have to address Johannes' concerns. If you want to enable
PCP mode as you have you can enable it by enabling it through an
extra crap/ category patch on compat-drivers.

  Luis
