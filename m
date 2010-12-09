Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f172.google.com ([209.85.214.172]:61915 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab0LIJVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 04:21:35 -0500
Received: by iwn40 with SMTP id 40so3138329iwn.3
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 01:21:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimwprBJpnLM6_Qap1wSVboVJPQecAUgmzAnQhu-@mail.gmail.com>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com>
	<201012061714.15863.br1@einfach.org>
	<AANLkTi=+bZbsZXR2v1AUKLEEAWGLpq-uNJXQ13t-Bf+D@mail.gmail.com>
	<AANLkTimwprBJpnLM6_Qap1wSVboVJPQecAUgmzAnQhu-@mail.gmail.com>
Date: Thu, 9 Dec 2010 10:21:34 +0100
Message-ID: <AANLkTim5hESSHAMYNryUwak=D4tQetZJuDEK41Yq3A+L@mail.gmail.com>
Subject: Re: ath5k: Weird Retransmission Behaviour
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: Bob Copeland <me@bobcopeland.com>, Bruno Randolf <br1@einfach.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 8, 2010 at 10:53 PM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
> I only seem to have Minstrel as the only available Rate Control
> algorithm in my kernel config?

PID is only selectable on embedded platforms:

config MAC80211_RC_PID
        bool "PID controller based rate control algorithm" if EMBEDDED

Just remove the "if EMBEDDED" from net/mac8011/Kconfig and retry.

Helmut
