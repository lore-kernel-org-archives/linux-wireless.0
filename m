Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:48098 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaEUQRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 12:17:39 -0400
Received: by mail-ob0-f178.google.com with SMTP id va2so2424196obc.23
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2014 09:17:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400668890.4136.1.camel@jlt4.sipsolutions.net>
References: <20140520203657.2C281E0300@pstew.mtv.corp.google.com>
	<20140520223316.EFCF1E0007@pstew.mtv.corp.google.com>
	<1400668890.4136.1.camel@jlt4.sipsolutions.net>
Date: Wed, 21 May 2014 09:17:38 -0700
Message-ID: <CAMcMvsiGJrJFee_nuGC1L8tRuTJLZR3nikU+4F-Zo1mgNeuNjw@mail.gmail.com> (sfid-20140521_181742_574452_C1A75048)
Subject: Re: [PATCHv2] nl80211: Provide TDLS link state
From: Paul Stewart <pstew@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2014 at 3:41 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Tue, 2014-05-20 at 13:27 -0700, Paul Stewart wrote:
> > Provide a method to query TDLS state in drivers that use the
> > NL80211_CMD_TDLS_OPER method for link setup.
>
> Apart from the fact that your patch isn't very clear on how this was
> intended to be used (some return value?) I don't really see why even
> such a driver couldn't implement station operations
> (get_station/dump_station) and get the same API for this that mac80211
> already implements.


 I still think this might be too heavyweight in situations where the
firmware handles TDLS links. Think about a system where the firmware
is completely responsible for terminating incoming TDLS requests and
offers no facility to notify the kernel as the TDLS link (initiated
remotely) was established.  Unless the driver polls the firmware for
ALL MAC addresses, there's no way for a station entry to magically
appear.  I wan this method so we can directly ask the firmware "hey,
is there a TDLS link to 02:00:00:00:01:00?"  This pre-supposes that
user-space has some knowledge about this remote host (suppose we're
streaming media to it) and we want to know whether in this case, for
diagnostic reasons, whether TDLS was established between them at this
time.
>
>
> iw wlan0 station dump gives me
> Station 02:00:00:00:01:00 (on wlan0)
>         inactive time:  450 ms
>         rx bytes:       3068
>         rx packets:     2
>         tx bytes:       3036
>         tx packets:     2
>         tx retries:     0
>         tx failed:      0
>         signal:         -30 dBm
>         signal avg:     -30 dBm
>         tx bitrate:     24.0 MBit/s
>         rx bitrate:     12.0 MBit/s
>         authorized:     yes
>         authenticated:  yes
>         preamble:       long
>         WMM/WME:        no
>         MFP:            no
>         TDLS peer:      yes
> [...]
>
>
> johannes
>
