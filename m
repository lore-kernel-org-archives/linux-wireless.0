Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0246.hostedemail.com ([216.40.44.246]:52088 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933452AbaJ2QN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 12:13:28 -0400
Message-ID: <1414599204.11707.5.camel@perches.com> (sfid-20141029_171333_444883_11882188)
Subject: Re: [patch] ath9k: fix some debugfs output
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Date: Wed, 29 Oct 2014 09:13:24 -0700
In-Reply-To: <20141029161021.GH6890@mwanda>
References: <20141029154805.GC5290@mwanda>
	 <1414598919.11707.3.camel@perches.com> <20141029161021.GH6890@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-29 at 19:10 +0300, Dan Carpenter wrote:
> On Wed, Oct 29, 2014 at 09:08:39AM -0700, Joe Perches wrote:
> > On Wed, 2014-10-29 at 18:48 +0300, Dan Carpenter wrote:
> > > The right shift operation has higher precedence than the mask so we
> > > left shift by "(i * 3)" and then immediately right shift by "(i * 3)"
> > > then we mask.  It should be left shift, mask, and then right shift.
[]
> > My grep pattern doesn't like operations on the thing masked.
> > Did you find this by some tool or visual inspection via grep?
[]
> I wrote a Smatch check inspired by the i40e bug you found earlier.

Nice.  fyi: I sent a bunch of these already.

https://lkml.org/lkml/2014/10/27/38


