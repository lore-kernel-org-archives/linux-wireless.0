Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:60967 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933521AbXJPQYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 12:24:01 -0400
Received: by py-out-1112.google.com with SMTP id u77so3776030pyb
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 09:23:59 -0700 (PDT)
Message-ID: <43e72e890710160923s704f156bo1351d7c073c892a6@mail.gmail.com> (sfid-20071016_172422_833071_49A5311C)
Date: Tue, 16 Oct 2007 12:23:58 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/3] ath5k global rename of hal to hw
Cc: "Bruno Randolf" <bruno@thinktube.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <40f31dec0710160915h1e0e4376l12173a2c81e850ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-2-git-send-email-bruno@thinktube.com>
	 <40f31dec0710160915h1e0e4376l12173a2c81e850ea@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/16/07, Nick Kossifidis <mickflemm@gmail.com> wrote:
> NACK we'll mess things up because we use hw also for mac80211_hw, too
> much use of "hw" is not recommended (also used in function names etc,
> it'll be difficult to track things down if we go too far). On the
> cleanups i did in madwifi-svn i used the name ath5k_hw for the struct,
> i think  also "ah" or "ahw" or "board" or "card" etc are more
> appropriate for use as a variable name (on my cleanups i left it as
> "hal").

Agreed, perhaps "ah" is best as its used throughout the driver already.

> Question: Since i don't know how things work, if i want to commit some
> patches should i wait for current patches to be commited on
> wireless-2.6 ? I have a patch series to commit about ath5k (my changes
> on madwifi-svn that weren't ported here) that include lots of cleanups
> and some hw.c updates. Against what code should i diff ??? Should i
> include current fixes along with mine (eg. Luis's fixes on base.c etc)
> ?

Always diff against latest wireless-2.6.git.

John already rebased wireless-2.6.git for the 2.6.23 change. In his
changes he already pulled most pending ath5k patch including my own so
I've pulled those changes onto ath5k svn and committed there.

ath5k svn *should only* reflect what's on wireless-2.6.git except for
security fixes or compat changes (but I'll address this in another
e-mail soon).

  Luis
