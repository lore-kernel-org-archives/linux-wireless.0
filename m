Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1ELDO4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 23:14:56 -0400
Subject: Re: ath5k and ath9k bugs still in 2.6.39-rc7
From: Dan Williams <dcbw@redhat.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 11 May 2011 22:17:00 -0500
In-Reply-To: <4DC968FD.1040906@candelatech.com>
References: <4DC968FD.1040906@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1305170221.8054.20.camel@dcbw.foobar.com> (sfid-20110512_051459_980606_AB0BA6A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-10 at 09:34 -0700, Ben Greear wrote:
> As far as I can tell, ath5k is critically broken due to un-initilized
> spinlock (fixed in the patch I posted a few days ago), and ath9k stations
> won't work due to PS bugs that Felix posted fixes for yesterday.
> 
> It looks like -rc7 is the last RC before the final .39, so I'm hoping
> these patches can be pushed quickly to Linus!

Johannes and I found out yesterday that ath5k doesn't implement the
tx_last_beacon hook either, which breaks IBSS mode.  Anyone know how to
fix that one?  It's been broken since at least 2.6.38 so it's not
technically a regression in current linux-2.6, but it's still broken.

Dan

