Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:58144 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab2FFI4O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:56:14 -0400
Message-ID: <4FCF1B2B.7030803@tieto.com> (sfid-20120606_105617_408376_9B715278)
Date: Wed, 6 Jun 2012 10:56:11 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 01/14] cfg80211: respect intf combinations for 1 interface
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>  <1338203942-5667-2-git-send-email-michal.kazior@tieto.com> <1338972702.4513.24.camel@jlt3.sipsolutions.net>
In-Reply-To: <1338972702.4513.24.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
>> Don't ignore interface combinations when only one
>> interface is up. Otherwise we may call a driver to
>> create (or change) interface type to something it
>> didn't report in interface combinations it
>> reported.
>
> We still check wiphy.interface_modes before we even go into this
> function, no? Arguably we should move the check into the function, but
> I'm not sure what you're fixing here.

Suppose a driver advertises support for AP and STA. Without the patch 
it's possible to bring up e.g. IBSS interface.


-- 
Pozdrawiam / Best regards, Michal Kazior.
