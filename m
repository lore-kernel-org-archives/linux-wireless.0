Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab1I0Ley (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 07:34:54 -0400
Subject: Re: [RFC] mac80211: remove per band sta supported rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1317121970-3638-1-git-send-email-sgruszka@redhat.com>
References: <1317121970-3638-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 13:34:49 +0200
Message-ID: <1317123289.4082.12.camel@jlt3.sipsolutions.net> (sfid-20110927_133457_461388_EEBE9D12)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-27 at 13:12 +0200, Stanislaw Gruszka wrote:
> It is not possible to connect to remote station on two bands
> at once, or I'm wrong?

I don't think it is, but there could be channel switches maybe?

> As side effect this patch fix warning in
> rate_control_send_low (or rather mask the real problem):
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=731365
> 
> Which may happen when we are just after disassociation and changed
> channel/band, but still want send some frames (namely delBA) to old
> sta. Right fix should prevent to change channel before we fully
> dissassocate, or prevent to send frames after connection is lost,
> or both, but I don't know how to correctly do this so far.

Well, either we should simply not send the frame, or send it before
disassoc, no?

johannes

