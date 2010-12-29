Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53648 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab0L2VCa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 16:02:30 -0500
Received: by qwa26 with SMTP id 26so10562585qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 13:02:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101203040300.GA2988@makis.mantri>
References: <20101203040300.GA2988@makis.mantri>
Date: Wed, 29 Dec 2010 16:02:29 -0500
Message-ID: <AANLkTinD+XrkXeUR2PNqj4eVVvTmrh8a9c4UEy0Nr7JE@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/6] ath5k: Always write tx powertable on hw
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 2, 2010 at 11:03 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>  * By skipping tx power table calibration we also skip setting
>  tx power table on hw. Make sure we always write tx power table
>  on hw since it gets cleared on reset.
>
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Just a very late heads-up, this patch seems to be causing problems
for me.

Seems a bit weird given the content, but the symptom is that
when I bring up the device none of my probe requests are actually
getting sent, according to wireshark captures from another device.
Reverting just this patch helps, so my power table must be broken
at start up.

I saw that Bruno had a later series that touched this area, so I'll
try them next.

-- 
Bob Copeland %% www.bobcopeland.com
