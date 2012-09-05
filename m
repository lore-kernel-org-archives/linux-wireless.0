Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab2IELta (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 07:49:30 -0400
Date: Wed, 5 Sep 2012 13:49:11 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	stable <stable@vger.kernel.org>,
	Jonathan Nieder <jrnieder@gmail.com>,
	=?iso-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	Milan Bouchet-Valat <nalimilan@club-internet.fr>
Subject: Re: [PATCH 2/2] brcmsmac: rework of mac80211 .flush() callback
 operation
Message-ID: <20120905114910.GA2466@redhat.com> (sfid-20120905_134934_538034_5B64E2CB)
References: <1346838562-4818-1-git-send-email-arend@broadcom.com>
 <1346838562-4818-3-git-send-email-arend@broadcom.com>
 <20120905102046.GC2311@redhat.com>
 <50472B74.5060104@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50472B74.5060104@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 05, 2012 at 12:37:40PM +0200, Arend van Spriel wrote:
> On 09/05/2012 12:20 PM, Stanislaw Gruszka wrote:
> >On Wed, Sep 05, 2012 at 11:49:22AM +0200, Arend van Spriel wrote:
> >>+	ret = wait_event_timeout(wl->tx_flush_wq,
> >>+				 brcms_tx_flush_completed(wl),
> >>+				 msecs_to_jiffies(BRCMS_FLUSH_TIMEOUT));
> >>+
> >>+	ieee80211_wake_queues(hw);
> >>+	WARN_ON(!ret);
> >Any particular reason why this WARN_ON is after ieee80211_wake_queues() ?
> >
> 
> The wait has a timeout so the warning indicates flush did not
> complete as in the old implementation. Maybe a WARN_ON_ONCE() would
> be better, but I have not observed the warning yet.

Yeah, but I rather asked why it is _after_ ieee80211_wake_queues(),
not before, just after wait_event_timeout().

Not big deal thought, just if something wrong will happen in
ieee80211_wake_queues() order of error prints will be confusing.

Stanislaw
