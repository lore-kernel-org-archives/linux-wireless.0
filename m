Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51571 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab0JMPah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 11:30:37 -0400
Subject: Re: Bug#599345: linux-image-2.6.32-5-amd64: iwlagn allocation
 failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Julien Cristau <jcristau@debian.org>
Cc: Ben Hutchings <ben@decadent.org.uk>, 599345@bugs.debian.org,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <20101013151716.GA3167@radis.liafa.jussieu.fr>
References: <20101006191947.GA3036@radis.liafa.jussieu.fr>
	 <1286402043.2955.81.camel@localhost>
	 <1286437870.3657.16.camel@jlt3.sipsolutions.net>
	 <1286737393.2955.225.camel@localhost>
	 <20101013151716.GA3167@radis.liafa.jussieu.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 17:30:26 +0200
Message-ID: <1286983826.3640.57.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-13 at 17:17 +0200, Julien Cristau wrote:

> Getting lots of those in dmesg:
> iwlagn 0000:0c:00.0: Too many chunks: 2
> 
> Doesn't seem to prevent the network from working though.

It'll at least leak lots of memory though. But I think the check there
is just wrong -- there are TFDs, and there are SKBs, and we need two
TFDs, but just one SKB.

johannes

