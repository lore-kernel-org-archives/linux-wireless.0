Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48646 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab3CTL01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 07:26:27 -0400
Received: by mail-ee0-f50.google.com with SMTP id e51so839873eek.23
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 04:26:26 -0700 (PDT)
From: ISE Development <isedev@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Reply-To: isedev@gmail.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] b43: A fix for DMA transmission sequence errors
Date: Wed, 20 Mar 2013 12:26:23 +0100
Message-ID: <4518745.W5blfs9sIi@wks001.ise.net> (sfid-20130320_122640_712913_E1112E93)
In-Reply-To: <514350EA.2060205@lwfinger.net>
References: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net> <CACna6rxAGN5cx6BXrdpM+-q_6QAQAvfb8+qhe-romE4hdxSs3g@mail.gmail.com> <514350EA.2060205@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 Mar 2013 11:48:42 Larry Finger wrote:
> On 03/15/2013 01:37 AM, Rafał Miłecki wrote:
> > OK, so after early tests, this card doesn't support full-addressing at
> > all.
> > 
> > I'll give this patch a try during the weekend.
> 
> Please follow Michael's suggestion, and change
> 
> 		if (slot == firstused + 2) {
> 
> into
> 
> 		if (slot == next_slot(ring, next_slot(ring, firstused))) {
> 
> This change is needed just in case "firstused + 2" wraps around.
> 
> Thanks,
> 
> Larry

Did you get a chance to validate this patch?

So far on my system, it has been running for over week without problems (over 
15GB of traffic).

Iestyn.
