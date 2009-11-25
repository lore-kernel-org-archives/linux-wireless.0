Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:56908 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934636AbZKYOhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 09:37:07 -0500
Received: by fxm5 with SMTP id 5so7026449fxm.28
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 06:37:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911250941.10929.holgerschurig@gmail.com>
References: <200911250941.10929.holgerschurig@gmail.com>
Date: Wed, 25 Nov 2009 09:37:12 -0500
Message-ID: <b6c5339f0911250637t1b698e94o9b835951ca8fbd60@mail.gmail.com>
Subject: Re: PROPOSAL: cfg80211 antenna selection
From: Bob Copeland <bcopeland@gmail.com>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 25, 2009 at 3:41 AM, Holger Schurig <holgerschurig@gmail.com> wrote:
> Hi,
>
> I just wondered how we can do the antenna and diversity
> selection.
>
> Assumption: 32 antennas are enought

So what does a mask of 0 mean?  No antennas, or use default?

FWIW, ath5k has been set up such that you can specify 'default'
mode, or you can pick between one of two antennas for RX.  In the
latter case, we transmit on the same antenna that the user selects.
My main interest is supporting at least this because some people
have devices with two antennas and the disconnected one is default.
For that, the masks should work fine.  The aforementioned people are
used to using iwpriv to fix it in madwifi.

On the tx side, we can specify a different antenna on each transmit,
basically one omni and a sector number (1-14) for a directional antenna.
We don't really have full support for this in the driver but some people
may want it for APs.

-- 
Bob Copeland %% www.bobcopeland.com
