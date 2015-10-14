Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34523 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbbJNVBL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 17:01:11 -0400
Message-ID: <1444856468.3054.17.camel@sipsolutions.net> (sfid-20151014_230117_120171_44B5232E)
Subject: Re: new regdb file format
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 14 Oct 2015 23:01:08 +0200
In-Reply-To: <1444855924.3054.9.camel@sipsolutions.net> (sfid-20151014_225211_436416_85634BE8)
References: <1444855924.3054.9.camel@sipsolutions.net>
	 (sfid-20151014_225211_436416_85634BE8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Err. Let's try that again.

I spent a bit of time thinking about a file format that would be more
extensible, yet still be loadable into the kernel without having to
parse it into new data structures in the kernel, i.e. be easy enough to
read when needed.

My considerations
 * must be extensible in some way
 * should be relatively dense/small to not use too much kernel memory
 * should still be reasonably easy to parse/read

I came up with a file format that's similar to the existing
regulatory.bin format, but with the following changes:
 * put the DFS region into a reg rule collection
 * put the frequency range and power rules directly into each reg rule
   (i.e. don't try to normalize them)
 * have a length field in the collection and rule structures so that we
   can extend them with new fields
 * use more compact pointers, i.e. u16 offsets, by aligning everything
   to 4 bytes and shifting the offsets by 2 bits, this allows for
   256KiB database files which seems large enough

More documentation is here:
https://wireless.wiki.kernel.org/en/developers/todo-list/regdb-file
-format

I put together a small sample program to create such a file from db.txt
(https://p.sipsolutions.net/1c42079f2e658a82.txt) and one to print such
a file (https://p.sipsolutions.net/8c180172adbe0ad3.txt)

Thoughts?

johannes

