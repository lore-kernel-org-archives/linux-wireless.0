Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.goneo.de ([85.220.129.37]:45840 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750839AbdCaIpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 04:45:18 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 1/2] Documentation/sphinx: kerneldoc: add "unused-functions"
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20170331071632.6209-1-johannes@sipsolutions.net>
Date: Fri, 31 Mar 2017 10:39:12 +0200
Cc: linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Message-Id: <8F272073-79D4-4721-B481-ED018A58174F@darmarit.de> (sfid-20170331_104525_204398_C14FDFE4)
References: <20170331071632.6209-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Am 31.03.2017 um 09:16 schrieb Johannes Berg <johannes@sipsolutions.net>:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> When adding functions one by one into documentation, in order to
> order/group things properly, it's easy to miss things. Allow use
> of the kernel-doc directive with "unused-functions" like this
> 
> .. kernel-doc:: <filename>
>  :unused-functions:
> 
> to output anything previously unused from that file. This allows
> grouping things but still making sure that the documentation has
> all the functions.

Do we really need such generic stuff? ... IMO explicit is better than
implicit. Why not getting an error when a function, which is referred
from a reST-document disappears in the source? Those errors help
to maintain the consistency of documentation with source-code.

In the past (DocBook) we had such generic stuff and IMO it was not
helpful to serve consistency. Take a look at the old DocBook stuff,
most of it is outdated and some object in the source-code, which are
referred in the past from DocBooks, are no longer existing ... but no
errors when compiling the DocBooks, because these are all generic
includes.

I know, there are also use-cases where generic is very helpful (e.g.
create a complete API description from the header file, with just
one line in reST). And I know, that we have already generic e.g. the
"export" option of the kernel-doc directive.

I'am not totally against generic, but I think every decision in
this direction should be well considered.

These are only my 2cent.

-- Markus --
