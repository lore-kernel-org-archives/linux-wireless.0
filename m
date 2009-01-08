Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39919 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbZAHQzy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 11:55:54 -0500
Subject: Re: [PATCH v2 1/3] libertas: Fix alignment issues in libertas core
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Colin McCabe <colin@cozybit.com>, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>
In-Reply-To: <1231433597.8398.3.camel@johannes>
References: <1230951623-26998-1-git-send-email-colin@cozybit.com>
	 <1230951623-26998-2-git-send-email-colin@cozybit.com>
	 (sfid-20090103_040451_022232_D73555CB)  <1231433597.8398.3.camel@johannes>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 11:54:41 -0500
Message-Id: <1231433681.21643.43.camel@localhost.localdomain> (sfid-20090108_175559_624102_3D41D63C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-01-08 at 17:53 +0100, Johannes Berg wrote:
> On Fri, 2009-01-02 at 19:00 -0800, Colin McCabe wrote:
> > When loading fields from packed structs, use get_unaligned_le16 and
> > get_unaligned_le32 instead of le16_to_cpu and le32_to_cpu.
> > This doesn't matter on x86, but it is important for some other CPUs.
> > 
> > Also, mark all packed structs as packed. Generally, any data structure
> > that comes over the wire from the WLAN firmware should be a packed struct.
> 
> Just marking the structs packed should be sufficient, since then the
> compiler must assume they are potentially unaligned.

Colin, can you test out just the bits that mark the structs as packed
and see if we can get by without using get_unaligned_le16() everywhere?
There will be a few cases where get_unaligned_le16() may be required but
I'm pretty sure we don't need this many...

Dan

