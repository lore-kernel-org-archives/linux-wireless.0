Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3997 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbYKPQw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 11:52:59 -0500
Date: Sun, 16 Nov 2008 11:52:13 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Dan McGee <dpmcgee@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Message-ID: <20081116165213.GC14126@hash.localnet> (sfid-20081116_175303_095401_3A028676)
References: <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com> <449c10960811151811s32fdd2b6p361d2ec9dd674fcc@mail.gmail.com> <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com> <43e72e890811152148q5f65aa43u49555a3977c205ff@mail.gmail.com> <20081116055312.GA14126@hash.localnet> <43e72e890811152205k13318ab7yad8695d9f6dd409c@mail.gmail.com> <43e72e890811152206s3683ecabm658fac255112a262@mail.gmail.com> <43e72e890811152215h5cf389a3ufe4dc10b021b0c0f@mail.gmail.com> <20081116162019.GA15851@hash.localnet> <449c10960811160838h70fd1852g66d8a51c7551530b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <449c10960811160838h70fd1852g66d8a51c7551530b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 16, 2008 at 10:38:39AM -0600, Dan McGee wrote:
> On Sun, Nov 16, 2008 at 10:20 AM, Bob Copeland <me@bobcopeland.com> wrote:
> > As you can see, the modules think "phy0" should be at offset 164, but
> > it's really at 160.
> 
> > Also I noticed the original config had CONFIG_DYNAMIC_FTRACE=y, unfortunately
> > turning that off didn't seem to change anything (hmm, I didn't get a build
> > bug, was the breakage fixed in 2.6.27.y?)
> 
> Note that HAVE is set if the architecture supports it; CONFIG_FTRACE
> itself was turned off (and CONFIG_DYNAMIC_FTRACE is not even present):
> $ grep FTRACE .config
> CONFIG_HAVE_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> # CONFIG_FTRACE is not set

Oh, you are right.  Thanks.  I probably won't be able to do any more
testing today but I would suggest trying to turn off wireless-related
options in the main kernel config and see if you can get it working 
(start with cfg80211 and its dependencies...)

-- 
Bob Copeland %% www.bobcopeland.com

