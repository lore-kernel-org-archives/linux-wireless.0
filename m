Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33585 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415Ab1FLStF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2011 14:49:05 -0400
Date: Sun, 12 Jun 2011 20:48:59 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	francesco.gringoli@ing.unibs.it
Subject: Re: [RFC][PATCH] b43: do not try sending packets when ring can be
 full
Message-ID: <20110612204859.37e7aed5@maggie> (sfid-20110612_204913_070515_A004ABDC)
In-Reply-To: <BANLkTikVLH8xApD4e5uNW-3Eg6kaMXipBg@mail.gmail.com>
References: <1307891513-6812-1-git-send-email-zajec5@gmail.com>
	<20110612182916.6afc781a@maggie>
	<BANLkTikVLH8xApD4e5uNW-3Eg6kaMXipBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 12 Jun 2011 20:15:53 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:
> Well, as I said, we may be unable to transmit the first element of the
> queue, but 2nd/3rd/... may be for different ring (qos) (we can
> transmit).
> 
> Looping through the whole queue every time, just to find packets we
> may transmit, sounds surely as a bad idea.

I don't think so. It's not that this is an actual queue anyway. It just acts
as a buffer to queue up one or two packets in the small race window of
actually filling up the DMA rings and stopping the mac80211 queue.
(It also acts as a context dispatcher in the first place, though).

So the "looping through the queue" just means checking if one or two packets
can be transmitted now.
