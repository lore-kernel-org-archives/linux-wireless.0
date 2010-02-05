Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f189.google.com ([209.85.223.189]:47768 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab0BEXQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 18:16:50 -0500
Received: by iwn27 with SMTP id 27so14480iwn.5
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2010 15:16:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002052004.06220.sturmflut@lieberbiber.de>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
	 <c1545bb51002050947q707bb5ebud5ec7b4680f49ac5@mail.gmail.com>
	 <20100205175556.GC1496@holoscopio.com>
	 <201002052004.06220.sturmflut@lieberbiber.de>
Date: Fri, 5 Feb 2010 15:16:49 -0800
Message-ID: <c1545bb51002051516u15f25d75s88314534cbea569b@mail.gmail.com>
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh mode
From: Andrey Yurovsky <andrey@cozybit.com>
To: Simon Raffeiner <sturmflut@lieberbiber.de>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 5, 2010 at 11:04 AM, Simon Raffeiner
<sturmflut@lieberbiber.de> wrote:
> If manual addition of plinks is allowed you could theoretically force your
> node to peer with a neighbor running a different profile, e.g. using a different
> path selection or authentication algorithm, or an implementation based on a
> different draft version.
>
> I can't really think of an use for it.

Right, in your case please ensure that your devices are beaconing
(that's the most common problem) before proceeding.  plinks are
established automatically and as far as I know that's the only thing
we need to support at this time.  If your device isn't beaconing, then
that's a bug and it should be fixed.  That said, ath5k beaconed
correctly last time I tried it.

  -Andrey
