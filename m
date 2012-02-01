Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab2BAPWK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 10:22:10 -0500
Date: Wed, 1 Feb 2012 16:21:57 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 2/4] rt2800: radio 3xxx: program RF_R1
 during channel switch
Message-ID: <20120201152156.GE10045@redhat.com> (sfid-20120201_162214_058364_727D272C)
References: <1327936679-12576-1-git-send-email-sgruszka@redhat.com>
 <1327936679-12576-2-git-send-email-sgruszka@redhat.com>
 <4F271479.4090303@gmail.com>
 <20120131081422.GB2438@redhat.com>
 <CAL1gcdOC8ygHfvqoQewShuXJm25pOaL7CWkoX3wcSZcyJkwaUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL1gcdOC8ygHfvqoQewShuXJm25pOaL7CWkoX3wcSZcyJkwaUw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 06:00:09PM +0100, Gertjan van Wingerde wrote:
> > Not only the code is different, but RF_R1 register value we program
> > is different for 30xx and 33xx when chain_num == 1 (changed by
> > RFCSR1_{RX2,TX2)_PD bit).
> >
> > I'm not against merging these two cases and program different values
> > into register than Ralink driver do, but maybe in the next linux
> > release (counting from release of that change), so any breakage
> > eventually caused by that merge could be easily detected.
> 
> OK. Indeed let's do this in a different commit, at least. I don't know
> if it has to be a
> different kernel release, as long as we are able to bisect it.

Average users are using only released stuff, so if this patch fix
any practical problem i.e. throughput, and merging code will break
that again, fix and new breakage will stay unnoticed.

> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> for this patch as well.

Thanks
Stanislaw
