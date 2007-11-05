Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:38291 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbXKEMXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2007 07:23:50 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1502119rvb
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2007 04:23:50 -0800 (PST)
Message-ID: <84144f020711050423r7a1f0e55g36c8c5ad29bfc700@mail.gmail.com> (sfid-20071105_122356_473844_D061F17C)
Date: Mon, 5 Nov 2007 14:23:50 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: RFC: Reproducible oops with lockdep on count_matching_names()
Cc: "Michael Buesch" <mb@bu3sch.de>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Michael Wu" <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Ingo Molnar" <mingo@redhat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org, "Michael Chan" <mchan@broadcom.com>,
	netdev@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <1194264016.27652.428.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071101191716.GA3201@pogo> <1194001120.27652.353.camel@twins>
	 <43e72e890711031258g4ccd9cd0hc4520e9473f6ce49@mail.gmail.com>
	 <200711032106.56569.mb@bu3sch.de> <1194264016.27652.428.camel@twins>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michael,

On Sat, 2007-11-03 at 21:06 +0100, Michael Buesch wrote:
> Who is responsible for slab btw?
> I mean, someone should be interested in getting this bug fixed. :)
> When using slab I see random corruptions. I think related to rmmod, but
> I'm not sure. I don't see this with slub.

Is CONFIG_DEBUG_SLAB enabled? Usually these kind of random corruptions
are caused by someone passing a bad pointer to kfree() or
kmem_cache_free().

                                  Pekka
