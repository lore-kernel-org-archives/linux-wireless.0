Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f192.google.com ([209.85.212.192]:63793 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbZKYJuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 04:50:16 -0500
Received: by vws30 with SMTP id 30so2076425vws.33
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 01:50:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87zl6b9f0i.fsf@purkki.valot.fi>
References: <1259132754-18164-1-git-send-email-vnatarajan@atheros.com>
	 <87zl6b9f0i.fsf@purkki.valot.fi>
Date: Wed, 25 Nov 2009 15:20:22 +0530
Message-ID: <8e92b4100911250150p31f3d0dr6cdace01ff8c55a5@mail.gmail.com>
Subject: Re: [RFC PATCH] mac80211: Send null data frame after disabling power
	save in Tx path.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 25, 2009 at 2:07 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Vivek Natarajan <vnatarajan@atheros.com> writes:
>
>> For drivers setting IEEE80211_HW_PS_NULLFUNC_STACK, a null data frame
>> with PM bit off has to be sent before sending normal data frames.
>
> Why? Sending a data frame with PM bit off should be enough to inform
> AP that the client is awake.

Since the subtype is different for null function data frame
(IEEE80211_STYPE_NULLFUNC)  which is normally used to indicate the
power management status , than normal data frame
(IEEE80211_STYPE_DATA), I thought some APs might create some
functionality issues by checking the frame subtype.
After your mail, I looked at the spec and it does not mention about
null frame in this context. It says,
'STAs changing Power Management mode shall inform the AP of this fact
using the Power Management bits within the Frame Control field of
transmitted frames. '

Accordingly, the present implementation might be correct. Thanks for
pointing it out.

Vivek.
