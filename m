Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33779 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaG2GeT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 02:34:19 -0400
Message-ID: <1406615652.7611.0.camel@jlt4.sipsolutions.net> (sfid-20140729_083422_570672_79C5DB04)
Subject: Re: [PATCH] regulatory: add NULL to alpha2
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Arik Nemtsov <arik@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>
Date: Tue, 29 Jul 2014 08:34:12 +0200
In-Reply-To: <CAB=NE6URWePHjBhKcWE_Jy06YbTsSWF3+xsrw9KcFYZJuv2Gsw@mail.gmail.com> (sfid-20140729_032717_589381_77A5D52B)
References: <1402471415-22723-1-git-send-email-arik@wizery.com>
	 <1403516586.4418.13.camel@jlt4.sipsolutions.net>
	 <20140630222303.GO1390@garbanzo.do-not-panic.com>
	 <1405936933.32255.8.camel@jlt4.sipsolutions.net>
	 <CAB=NE6URWePHjBhKcWE_Jy06YbTsSWF3+xsrw9KcFYZJuv2Gsw@mail.gmail.com>
	 (sfid-20140729_032717_589381_77A5D52B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-07-28 at 18:26 -0700, Luis R. Rodriguez wrote:
> On Mon, Jul 21, 2014 at 3:02 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > This was never intended to be a string, only 2 characters ... so why use
> > it with string functions?
> 
> Sure makes sense, the report was not clear so indeed, if userspace can
> be fixed that's better to enable consistent use.

Sadly, it looks like userspace *is* relying on a NUL-byte (e.g. iw using
nla_get_string()) which would always be there due to padding, but it's
probably better to make it explicit.

johannes

