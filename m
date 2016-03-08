Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35719 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbcCHN1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 08:27:49 -0500
Received: by mail-wm0-f48.google.com with SMTP id l68so131528477wml.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2016 05:27:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160308131409.GD5026@localhost>
References: <1456492163-11437-1-git-send-email-michal.kazior@tieto.com>
	<CAA93jw4XsEnp3jTgPL7OKWTJP-83VwRaCdb+foc8nCuqxk3WZA@mail.gmail.com>
	<CA+BoTQk+3jhwK57_fDw0scNCGzu_Edqp9-Beeppz8xj9kSQcoQ@mail.gmail.com>
	<20160308131409.GD5026@localhost>
Date: Tue, 8 Mar 2016 14:27:47 +0100
Message-ID: <CA+BoTQnwvGRhM3_-CT8-__nAAo8RmR51=G-7C1VcMFkSoTKUAg@mail.gmail.com> (sfid-20160308_142756_923949_95BC85B7)
Subject: Re: [RFC/RFT] mac80211: implement fq_codel for software queuing
From: Michal Kazior <michal.kazior@tieto.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Dave Taht <dave.taht@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Tim Shepard <shep@alum.mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 March 2016 at 14:14, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Mar 08, 2016 at 08:12:21AM +0100, Michal Kazior wrote:
>> However other drivers (e.g. ath10k) have offloaded rate control on
>> device. There's currently no way of doing this calculation. I was
>> thinking of drivers exporting tx_rate to mac80211 in some way - either
>> via a simple sta->tx_rate scalar that the driver is responsible for
>> updating, or a EWMA that driver updates (hopefully) periodically and
>> often enough. This should in theory at least allow an estimate how
>> much data on average you can fit into given time frame (e.g. txop, or
>> hardcoded 1ms).
>
> What about implementing ops->get_expected_throughput?  This would be
> useful for mesh (both 11s and batman) as well since they need to
> estimate link quality to pick a path.

Oh, good point! I totally forgot about this because - in the back of
my head - I was convinced this is available only for minstrel. I guess
this could work as well.


Michał
