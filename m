Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:41337 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756060Ab0LBKiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 05:38:24 -0500
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0717256302
	for <linux-wireless@vger.kernel.org>; Thu,  2 Dec 2010 19:38:23 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/3] lib: Improve EWMA efficiency by using bitshifts
Date: Thu, 2 Dec 2010 19:37:44 +0900
Cc: linville@tuxdriver.com, randy.dunlap@oracle.com,
	peterz@infradead.org, blp@cs.stanford.edu,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lars_Ericsson@telia.com, j@w1.fi, stefanr@s5r6.in-berlin.de,
	kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
	kevin.granade@gmail.com
References: <20101202101231.22988.33396.stgit@localhost6.localdomain6> <20101202101236.22988.1691.stgit@localhost6.localdomain6> <1291285222.3481.45.camel@jlt3.sipsolutions.net>
In-Reply-To: <1291285222.3481.45.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201012021937.44368.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu December 2 2010 19:20:22 Johannes Berg wrote:
> On Thu, 2010-12-02 at 19:12 +0900, Bruno Randolf wrote:
> > +	/* get bitshift for weight */
> > +	for (n = 0; !(weight & 1); n++)
> > +		weight = weight >> 1;
> > +	WARN_ON(weight > 1 || n < 1);
> 
> I'm sure there's something like log2() (and is_power_of_2() for the
> warning) in the kernel already -- no need to reimplement it...

Ah, thanks for that! Will resend an improved version.

bruno
