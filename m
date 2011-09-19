Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33557 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab1ISNEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 09:04:20 -0400
Subject: Re: [PATCH v3 3/3] mac80211: Add HT operation modes for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <an.alexsimon@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110918T004437-426@post.gmane.org> (sfid-20110918_010021_257649_C3C63FC1)
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com>
	 <c06e69fca577a9f162c3d69b4a7e7a212788ee7b.1316297595.git.an.alexsimon@googlemail.com>
	 <loom.20110918T004437-426@post.gmane.org>
	 (sfid-20110918_010021_257649_C3C63FC1)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 15:04:19 +0200
Message-ID: <1316437459.5995.29.camel@jlt3.sipsolutions.net> (sfid-20110919_150423_475587_81D04E2F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-09-17 at 22:54 +0000, Alexander Simon wrote:
> I came to the conclusion that the old patch was way too complicated and
> confusing. Too much cases have to be taken into account when trying to
> homogenize the HT mode.
> I changed the code now that only mode given by iw is considered.
> 
> This yields in a way smaller patch and less refactoring as we don't need to
> manipulate the beacon skb and match additionally for HT mode in scan results.
> 
> I think it's better that way.

Hmm. 10.3.2.2.2 seems to indicate that HT operation parameters should be
adopted, and 11.14.2 says:
"An HT STA that is a member of an IBSS adopts the value of the Secondary
Channel Offset field in received frames according to the rules in 11.1.4
and shall not transmit a value for the Secondary Channel Offset field
that differs from the most recently adopted value."


Also, are you handling the following?

     1. 9.13.3.1: In an IBSS, the HT Protection field is reserved, but
        an HT STA shall protect HT transmissions as though the HT
        Protection field were set to non-HT mixed mode.
     2. In an IBSS, the RIFS Mode field of the HT Operation element is
        also reserved, but an HT STA shall operate as though this field
        were set to 1.
     3. 11.5.1.1: If the initiating STA is an HT STA, is a member of an
        IBSS, and has no other existing Block Ack agreement with the
        recipient STA, then the initiating STA shall transmit a Probe
        Request frame to the recipient STA and shall not transmit an
        ADDBA Request frame unless it receives a Probe Response frame
        from the recipient within dot11ADDBAFailureTimeout.

I'd like to at least give consideration to standards-compliance and make
it clear where we don't want to be compliant.

johannes

