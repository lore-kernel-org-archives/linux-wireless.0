Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1384 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbZHZEbv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 00:31:51 -0400
Subject: Re: Initial work for ar9271
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Christian Lamparter <chunkeey@web.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg KH <greg@kroah.com>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	Zhifeng Cai <zhifeng.cai@atheros.com>,
	Cliff Holden <Cliff.Holden@atheros.com>,
	Christoph Hellwig <hch@infradead.org>,
	Len Widra <Len.Widra@atheros.com>
In-Reply-To: <43e72e890908252103j2332d8eat9e18fecb20a1fe58@mail.gmail.com>
References: <43e72e890908252103j2332d8eat9e18fecb20a1fe58@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 21:31:50 -0700
Message-Id: <1251261111.3463.15.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-08-25 at 21:03 -0700, Luis R. Rodriguez wrote:
> If you'd like to work on the
> driver I welcome patches:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/ar9271.git

I think this style ugly because it's non kernel standard.

int func(args)
{
	do {
		[ linear code ...]
		if (err) {
			errorcode = ;
			break;
		}
		[ more linear code ...]
	} while (0);

	if (errorcode) {
		handle()...
		return some_err;
	}

	return 0;
}

It's a bit too much like a try/throw/catch block.

Are patches accepted to convert it to the more
commonly used kernel style using gotos?


