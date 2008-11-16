Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:52571 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbYKPQil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 11:38:41 -0500
Received: by yx-out-2324.google.com with SMTP id 8so898667yxm.1
        for <linux-wireless@vger.kernel.org>; Sun, 16 Nov 2008 08:38:40 -0800 (PST)
Message-ID: <449c10960811160838h70fd1852g66d8a51c7551530b@mail.gmail.com> (sfid-20081116_173845_335395_BF938A73)
Date: Sun, 16 Nov 2008 10:38:39 -0600
From: "Dan McGee" <dpmcgee@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, "Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <20081116162019.GA15851@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	 <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	 <449c10960811151811s32fdd2b6p361d2ec9dd674fcc@mail.gmail.com>
	 <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com>
	 <43e72e890811152148q5f65aa43u49555a3977c205ff@mail.gmail.com>
	 <20081116055312.GA14126@hash.localnet>
	 <43e72e890811152205k13318ab7yad8695d9f6dd409c@mail.gmail.com>
	 <43e72e890811152206s3683ecabm658fac255112a262@mail.gmail.com>
	 <43e72e890811152215h5cf389a3ufe4dc10b021b0c0f@mail.gmail.com>
	 <20081116162019.GA15851@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 16, 2008 at 10:20 AM, Bob Copeland <me@bobcopeland.com> wrote:
> As you can see, the modules think "phy0" should be at offset 164, but
> it's really at 160.

> Also I noticed the original config had CONFIG_DYNAMIC_FTRACE=y, unfortunately
> turning that off didn't seem to change anything (hmm, I didn't get a build
> bug, was the breakage fixed in 2.6.27.y?)

Note that HAVE is set if the architecture supports it; CONFIG_FTRACE
itself was turned off (and CONFIG_DYNAMIC_FTRACE is not even present):
$ grep FTRACE .config
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
# CONFIG_FTRACE is not set

-Dan
