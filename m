Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62936 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab0JKSug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 14:50:36 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 11:50:27 -0700
Date: Mon, 11 Oct 2010 11:50:34 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?utf-8?B?THVrw6HFoQ==?= Turek <8an@praha12.net>
CC: Bruno Randolf <br1@einfach.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] Race condition in CRDA calls?
Message-ID: <20101011185034.GB10049@tux>
References: <201003251801.57951.8an@praha12.net>
 <AANLkTik7ckoex4pP1IkY0Vx1j-S4k0WVV62h7Sn4uGCx@mail.gmail.com>
 <201010081657.17326.br1@einfach.org>
 <201010112013.09521.8an@praha12.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <201010112013.09521.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 11, 2010 at 11:13:03AM -0700, Lukáš Turek wrote:
> On Friday 08 October 2010 09:57:17 you wrote:
> > root@RMR1:~# 1284335259.046129: phy #1: regulatory domain change:
> > intersection  used due to a request made by a driver on phy1
> > 1284335263.403515: phy #1: regulatory domain change: intersection used due
> > to  a request made by a driver on phy1
> > 
> > interesting that phy #1 appears twice...
> 
> When I hit this bug my idea was that the problem lies in the CRDA API: the 
> wiphy identifier is not sent to CRDA, instead a global variable last_request 
> is used. However, if a new request is started before the previous one is 
> finished, the old last_request value is replaced, both replies use the same 
> last_request and strange think happen...
> 
> I hoped someone who knows the kernel-userspace interaction better will confirm 
> or disprove it, so I didn't investigate it further, and then I just forgot 
> about it...

Sorry about the delay on a response on this, I've just been caught up
with other higher priority issues, but as soon as I have some cycles I will
give it a shot with two cards.

  Luis
