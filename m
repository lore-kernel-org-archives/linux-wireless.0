Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2KTBWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 20:22:40 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so3869523pbc.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 17:22:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVPVbyL+6HTUv+4=zNMvb4KSPMowXwbb1B2H5ugYBuo0gQ@mail.gmail.com>
References: <1352832488-21516-1-git-send-email-thomas@cozybit.com>
	<1353361141.18299.36.camel@jlt4.sipsolutions.net>
	<CAJ-VmomL6g1LfTNsk6HPeKEySS57-646L6i9rcOT0V9cDK0b9w@mail.gmail.com>
	<CAG6hwVPVbyL+6HTUv+4=zNMvb4KSPMowXwbb1B2H5ugYBuo0gQ@mail.gmail.com>
Date: Mon, 19 Nov 2012 17:22:39 -0800
Message-ID: <CAJ-VmomHxArtZ+1tqkmGdTobv2Y9CdXHrfxPyJkeAKboqYJoxQ@mail.gmail.com> (sfid-20121120_022242_749108_F17A1603)
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

Just do what Sam did in the FreeBSD TDMA code - calculate the actual
beginning of the frame by using the TSF, the size of the last frame,
the rate from the last frame, and call ath_hal_calctxtime() (or the
linux equivalent, obviously.)

For clarification we should find out what the TSF is for 11n
aggregates. Or the math is totally wrong.

Thanks,


Adrian
