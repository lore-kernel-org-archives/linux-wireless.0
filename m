Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:46103 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbbBZTDn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 14:03:43 -0500
Received: by iecvy18 with SMTP id vy18so19415129iec.13
        for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2015 11:03:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150226102000.GA4839@w1.fi>
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
	<20150226102000.GA4839@w1.fi>
Date: Thu, 26 Feb 2015 11:03:42 -0800
Message-ID: <CAJ-Vmomp74+ninUMVO-XmfPqnV=mh3Hu0qYETpeP0Bq9b0OZgQ@mail.gmail.com> (sfid-20150226_200347_439045_68357499)
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
From: Adrian Chadd <adrian@freebsd.org>
To: Jouni Malinen <j@w1.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@net.t-labs.tu-berlin.de>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Andrew McGregor <andrewmcgr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 February 2015 at 02:20, Jouni Malinen <j@w1.fi> wrote:
> On Wed, Feb 25, 2015 at 10:14:45AM -0800, Linus Torvalds wrote:
>> While I realize that people may disagree about the exact details of
>> how to fix this in the long run, may I suggest that in the meantime we
>> at least get the two workaround patches applied?
>
>> Does anybody hate Jouni's two patches *so* much that they can
>> articulate *why* it would be wrong to apply them as interim patches?
>> And if so, do you have better patches for me to try? Because if not..
>
> Of all people, I do actually have some hatred on the one-liner to force
> minimum rate for all EAPOL TX attempts. That is punishing the vast
> majority of cases where the AP is perfectly fine with higher MCS rates
> being used (and MCS 0 being sufficient fallback option) for EAPOL. Being
> able to use higher TX rates as the initial attempt is a nice feature and
> even though this may be limited to number of upstream Linux drivers
> today, that part of the feature is an improvement, IMHO. This can even
> be more robust in some environments especially when going through long
> EAP exchange with certain types of interference.

I remember running the math - well, the "airtime" math, and realised
it was almost always cheaper to do the single, non-aggregated EAPOL
frame exchange at the lowest rate than to try higher rates and fall
back to the lowest rates.




-adrian
