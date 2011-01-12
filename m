Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:53141 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab1ALOVB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 09:21:01 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 06:20:43 -0800
Date: Wed, 12 Jan 2011 19:50:14 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] ath9k: set hw opmode while changing interface type
Message-ID: <20110112142014.GA7350@vmraj-lnx.users.atheros.com>
References: <1294591888-16625-1-git-send-email-rmanoharan@atheros.com>
 <4D29F995.1000007@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4D29F995.1000007@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 09, 2011 at 11:38:21PM +0530, Felix Fietkau wrote:
> On 2011-01-09 9:51 AM, Rajkumar Manoharan wrote:
> > The commit "ath9k: Add change_interface callback" is
> > failed to set hw opmode while changing interface type
> > on runtime. Not setting opmode fails to generate
> > beacons on changing to AP mode.
> >
> I think since not only ah->opmode matters, but also various other things 
> that conditionally enable/disable ANI, various flags in ah->imask, etc. 
> it would probably be best to merge most of the code of .add_interface, 
> .remove_interface and .change_interface into one function that iterates 
> over all active interfaces and calculates all the mode dependent 
> parameters. The way things are done right now is just too fragile.

Sorry for delayed response. Will send a RFC patch. Thanks for the review.

--
Rajkumar
