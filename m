Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:57897 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426AbbBZKUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 05:20:04 -0500
Date: Thu, 26 Feb 2015 12:20:00 +0200
From: Jouni Malinen <j@w1.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Thomas =?utf-8?B?SMO8aG4=?= <thomas@net.t-labs.tu-berlin.de>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
Message-ID: <20150226102000.GA4839@w1.fi> (sfid-20150226_112010_648392_F5948C59)
References: <20150223224305.GA30228@w1.fi>
 <21739.50662.902775.901924@gargle.gargle.HOWL>
 <CAA_e5Z4zuDMS+CJvFbw4F5M9OZxgS-NZzL2E3d3GSvpRr_TbQw@mail.gmail.com>
 <CAA_e5Z5PqfcYss9fADFewBTgnxrYMy5U6XbRz-J5doEyKgugTg@mail.gmail.com>
 <20150224102611.GA30806@w1.fi>
 <80AA1103-EBCD-4C18-A950-B03FF516E5AC@net.t-labs.tu-berlin.de>
 <20150224181454.GA30859@w1.fi>
 <54ED56D8.9030806@openwrt.org>
 <20150225144723.GA6903@w1.fi>
 <CA+55aFyvhgFMRAg2ftuN_cykGs_3-Oyabhi_N6S-J1daVFFRzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFyvhgFMRAg2ftuN_cykGs_3-Oyabhi_N6S-J1daVFFRzw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2015 at 10:14:45AM -0800, Linus Torvalds wrote:
> While I realize that people may disagree about the exact details of
> how to fix this in the long run, may I suggest that in the meantime we
> at least get the two workaround patches applied?

> Does anybody hate Jouni's two patches *so* much that they can
> articulate *why* it would be wrong to apply them as interim patches?
> And if so, do you have better patches for me to try? Because if not..

Of all people, I do actually have some hatred on the one-liner to force
minimum rate for all EAPOL TX attempts. That is punishing the vast
majority of cases where the AP is perfectly fine with higher MCS rates
being used (and MCS 0 being sufficient fallback option) for EAPOL. Being
able to use higher TX rates as the initial attempt is a nice feature and
even though this may be limited to number of upstream Linux drivers
today, that part of the feature is an improvement, IMHO. This can even
be more robust in some environments especially when going through long
EAP exchange with certain types of interference.

That said, it is clear to me that we need to modify the current behavior
to be more conservative with some of the EAPOL frame retries. I'm not
familiar enough with the current minstrel implementation to prepare a
clean patch doing the approach I think that should be used here (replace
the last rate with a low basic rate and add couple of tries with it). I
have reason to believe that Felix might be able to look at this in
couple of weeks, though.

In other words, I think I'll send out a more formal version of the
patches so that they can be applied now if desired while keeping in mind
that we may want to replace the minrate-for-EAPOL with something else
later. As far as the EAPOL-Key msg 4/4 retries without encryption patch
is concerned, I think I have enough concern on the couple of corner
cases that I know it does not address (and may break), so it may take
some more time before I'm ready to suggest it (or a bit modified version
of it) to be applied, though.

-- 
Jouni Malinen                                            PGP id EFC895FA
