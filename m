Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:60005 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3COQsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 12:48:47 -0400
Received: by mail-ob0-f170.google.com with SMTP id wc20so3461670obb.15
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2013 09:48:47 -0700 (PDT)
Message-ID: <514350EA.2060205@lwfinger.net> (sfid-20130315_174850_811419_73AA1DFC)
Date: Fri, 15 Mar 2013 11:48:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>, isedev@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] b43: A fix for DMA transmission sequence errors
References: <51421afb.xUa3KbaBuvmUk4RG%Larry.Finger@lwfinger.net> <CACna6rzvqo-CdrwkSH0p9=b=Qn+L78jQQSuGcGbgT865_uKvSw@mail.gmail.com> <CACna6rxAGN5cx6BXrdpM+-q_6QAQAvfb8+qhe-romE4hdxSs3g@mail.gmail.com>
In-Reply-To: <CACna6rxAGN5cx6BXrdpM+-q_6QAQAvfb8+qhe-romE4hdxSs3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2013 01:37 AM, Rafał Miłecki wrote:
>
> OK, so after early tests, this card doesn't support full-addressing at all.
>
> I'll give this patch a try during the weekend.

Please follow Michael's suggestion, and change

		if (slot == firstused + 2) {

into

		if (slot == next_slot(ring, next_slot(ring, firstused))) {

This change is needed just in case "firstused + 2" wraps around.

Thanks,

Larry

