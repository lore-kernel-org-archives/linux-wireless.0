Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50144 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab0LHVgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 16:36:38 -0500
Received: by qwa26 with SMTP id 26so1782392qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 13:36:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTim2RMaqh-7sYhGLwWV8OK-RH74H3YGm_TV6pVKs@mail.gmail.com>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com>
	<201012061714.15863.br1@einfach.org>
	<AANLkTi=+bZbsZXR2v1AUKLEEAWGLpq-uNJXQ13t-Bf+D@mail.gmail.com>
	<AANLkTi=95mO085Y1PJ3brMMpHa=QvkxSB3SUpQysvKr+@mail.gmail.com>
	<20101208165607.GE2423@tuxdriver.com>
	<AANLkTikmZZuD1h45RkX3QE2xAQLfoZzwSecDXvojSw5=@mail.gmail.com>
	<AANLkTi=5a=LBTUcjyi0je3XYNG+=xsbA_MjtDU_dZat_@mail.gmail.com>
	<AANLkTim2RMaqh-7sYhGLwWV8OK-RH74H3YGm_TV6pVKs@mail.gmail.com>
Date: Wed, 8 Dec 2010 16:36:37 -0500
Message-ID: <AANLkTin9jsqBPg40pCsrkX_Z_52Wz4mJKzmFn0TBqCsB@mail.gmail.com>
Subject: Re: ath5k: Weird Retransmission Behaviour
From: Bob Copeland <me@bobcopeland.com>
To: sedat.dilek@gmail.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bruno Randolf <br1@einfach.org>,
	Jonathan Guerin <jonathan@guerin.id.au>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@venema.h4ckr.net>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 8, 2010 at 12:50 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>
> I have applied, compiled and loaded new mac80211 kernel-module.
> What could be a good test-case?

Hrm, not sure, something like this?

 - config the retry limits with iwconfig
 - bring up the interface and connect to an AP, generate traffic with
   iperf or something
 - with another wireless interface & wireshark take a packet trace
 - power off the AP
 - verify that the configured retry limits aren't exceeded in the trace
   once the AP goes away.

And do the same without the patch to see the difference.

-- 
Bob Copeland %% www.bobcopeland.com
