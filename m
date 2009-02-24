Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49347 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbZBXSn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 13:43:58 -0500
Date: Tue, 24 Feb 2009 20:43:43 +0200
From: Jouni Malinen <j@w1.fi>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
Message-ID: <20090224184343.GA12620@jm.kir.nu> (sfid-20090224_194400_283729_BD81731A)
References: <20090223163626.20939.4879.stgit@tikku> <20090223163738.20939.25890.stgit@tikku> <1235442058.4455.71.camel@johannes.local> <20090224090137.GB10851@jm.kir.nu> <87k57fy964.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87k57fy964.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2009 at 08:36:03PM +0200, Kalle Valo wrote:
> I see your point, I also have had to suffer because of buggy APs
> having unstable TBTT. But the cost for this is high, currently it
> increases two seconds the time to signal a lost connection to the user
> space. I would hope to have something faster.

How can that take two seconds? All that would be needed here is to send
out a unicast Probe Request to the current AP and wait for a Probe
Response for a short timeout, say 20 ms. That shouldn't take more than
50 ms or so at most.. If the current implementation uses two seconds for
this, there is certainly room for improvement there and I would rather
see that done than lose this extra protection against buggy
implementations (either AP or STA for that matter).

-- 
Jouni Malinen                                            PGP id EFC895FA
