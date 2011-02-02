Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35713 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab1BBSV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 13:21:59 -0500
Received: by qwa26 with SMTP id 26so256235qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Feb 2011 10:21:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201102021229.28104.br1@einfach.org>
References: <20110128075211.26919.39228.stgit@localhost6.localdomain6>
	<AANLkTim2MBSMSDxyokEWWDC=bwzMCO92qd4_i3Cm0h29@mail.gmail.com>
	<20110202105254.GA15843@hash.localnet>
	<201102021229.28104.br1@einfach.org>
Date: Wed, 2 Feb 2011 13:21:57 -0500
Message-ID: <AANLkTimdSsp=vN2MKC5dT1YW_ZPc5nCWuDVY2dEK0QSG@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Fix short and long retry configuration
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: sedat.dilek@gmail.com, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 2, 2011 at 6:29 AM, Bruno Randolf <br1@einfach.org> wrote:
> My patch for ath5k is only one part of the story. It sets the retry limits in
> HW. Most of these values only affect after how many retries the contention
> window is reset to cw_min, not the actual number of retries (please check the
> register documentation in my patch). The total number of retries for a frame
> are the values we put into the TX descriptor - coming from the rate control
> module (minstrel).

Ah, thanks for the clarification.  We could of course mess with the MRR
setup in ->tx inside the driver, but it would be better to fix it there.

-- 
Bob Copeland %% www.bobcopeland.com
