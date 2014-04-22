Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932925AbaDVPRf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 11:17:35 -0400
Message-ID: <1398179846.4211.19.camel@jlt4.sipsolutions.net> (sfid-20140422_172308_770802_A4B0B363)
Subject: Re: [PATCH] cfg80211: avoid freeing last_request while in flight
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, colleen@cozybit.com,
	mcgrof@do-not-panic.com, linux@eikelenboom.it
Date: Tue, 22 Apr 2014 17:17:26 +0200
In-Reply-To: <1397646587-11078-1-git-send-email-arik@wizery.com> (sfid-20140416_130951_435209_F2416E3D)
References: <1397646587-11078-1-git-send-email-arik@wizery.com>
	 (sfid-20140416_130951_435209_F2416E3D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-16 at 14:09 +0300, Arik Nemtsov wrote:
> Avoid freeing the last request while it is being processed. This can
> happen in some cases if reg_work is kicked for some reason while the
> currently pending request is in flight.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> This is to be applied on top of
> "cfg80211: fix processing world regdomain when non modular"

I'll apply Luis's version of this, not sure what's up with the respin
since he didn't give me a patch to apply to mac80211.git ...

johannes

