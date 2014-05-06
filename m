Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45624 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaEFOoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 10:44:01 -0400
Message-ID: <1399387428.4218.45.camel@jlt4.sipsolutions.net> (sfid-20140506_164405_663183_741A0CB6)
Subject: Re: [PATCH v4 3/5] mac80211: use chanctx reservation for STA CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Tue, 06 May 2014 16:43:48 +0200
In-Reply-To: <1397051137-26201-4-git-send-email-michal.kazior@tieto.com> (sfid-20140409_155158_003700_3D901A43)
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	 <1397051137-26201-4-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140409_155158_003700_3D901A43)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 15:45 +0200, Michal Kazior wrote:
> Channel switch finalization is now 2-step. First
> step is when driver calls chswitch_done(), the
> other is when reservation is actually finalized
> (which be defered for in-place reservation).
> 
> It is now safe to call ieee80211_chswitch_done()
> more than once.
> 
> Also remove the ieee80211_vif_change_channel()
> because it is no longer used.

A lot of this looks really duplicated from the previous patch - since I
just merged the fixes is there really a need to go through the work etc.
and have this different, instead of going through cfg80211 for the
disconnect?

johannes

