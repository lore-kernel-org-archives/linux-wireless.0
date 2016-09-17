Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932119AbcIQVpf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 17:45:35 -0400
Date: Sat, 17 Sep 2016 23:45:39 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, Nicolai Stange <nicstange@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 2/4] carl9170: fix debugfs crashes
Message-ID: <20160917214539.GA28379@kroah.com> (sfid-20160917_234550_929183_DB3A9A5A)
References: <48411543620969bebb37a1a9ea7b8f451cdfdd31.1474140477.git.chunkeey@gmail.com>
 <ccf228acb7af8ee3bbd82f72f28ebc068f37cb8e.1474140477.git.chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ccf228acb7af8ee3bbd82f72f28ebc068f37cb8e.1474140477.git.chunkeey@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 17, 2016 at 09:43:02PM +0200, Christian Lamparter wrote:
> Ben Greear reported:
> > I see lots of instability as soon as I load up the carl9710 NIC.
> > My application is going to be poking at it's debugfs files...
> >
> > BUG: KASAN: slab-out-of-bounds in carl9170_debugfs_read+0xd5/0x2a0
> > [carl9170] at addr ffff8801bc1208b0
> > Read of size 8 by task btserver/5888
> > =======================================================================
> > BUG kmalloc-256 (Tainted: G        W      ): kasan: bad access detected
> > -----------------------------------------------------------------------
> >
> > INFO: Allocated in seq_open+0x50/0x100 age=2690 cpu=2 pid=772
> >...
> 
> This breakage was caused by the introduction of intermediate
> fops in debugfs by commit 9fd4dcece43a
> ("debugfs: prevent access to possibly dead file_operations at file open")

Because of this, these should all be backported to 4.7-stable, and
4.8-stable, right?

thanks,

greg k-h
