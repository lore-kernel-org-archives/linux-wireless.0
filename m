Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50920 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2KTHRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 02:17:17 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so1049802pad.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 23:17:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomHxArtZ+1tqkmGdTobv2Y9CdXHrfxPyJkeAKboqYJoxQ@mail.gmail.com>
References: <1352832488-21516-1-git-send-email-thomas@cozybit.com>
	<1353361141.18299.36.camel@jlt4.sipsolutions.net>
	<CAJ-VmomL6g1LfTNsk6HPeKEySS57-646L6i9rcOT0V9cDK0b9w@mail.gmail.com>
	<CAG6hwVPVbyL+6HTUv+4=zNMvb4KSPMowXwbb1B2H5ugYBuo0gQ@mail.gmail.com>
	<CAJ-VmomHxArtZ+1tqkmGdTobv2Y9CdXHrfxPyJkeAKboqYJoxQ@mail.gmail.com>
Date: Mon, 19 Nov 2012 23:17:16 -0800
Message-ID: <CAJ-Vmok8Zyx7Pr9bVLp2NHnUZu5uaweT+sxVKvyFu7qV+de6hA@mail.gmail.com> (sfid-20121120_081726_528054_6E665C48)
Subject: Re: [PATCH v2 1/2] ath9k: RX timestamp is reported at end of frame
From: Adrian Chadd <adrian@freebsd.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	ath9k-devel@lists.ath9k.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 November 2012 17:22, Adrian Chadd <adrian@freebsd.org> wrote:
> Just do what Sam did in the FreeBSD TDMA code - calculate the actual
> beginning of the frame by using the TSF, the size of the last frame,
> the rate from the last frame, and call ath_hal_calctxtime() (or the
> linux equivalent, obviously.)
>
> For clarification we should find out what the TSF is for 11n
> aggregates. Or the math is totally wrong.

For reference - only the TSF in the final subframe in an aggregate is
valid. The others aren't.

We'll have to jump through some hoops to calculate the timestamp of
each individual MPDU.


Adrian
