Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:56554 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934325AbXC2TMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 15:12:42 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HX011-0000iy-0D
	for linux-wireless@vger.kernel.org; Thu, 29 Mar 2007 15:10:31 -0400
Subject: Re: [PATCH 1/5] Meddled with by Andy Green since signed-off: made  it apply to current wireless-dev, took out comments for radiotap types not  in current wireless-dev
From: Pavel Roskin <proski@gnu.org>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070329133123.323900095@warmcat.com>
References: <20070329133114.569947199@warmcat.com>
	 <20070329133123.323900095@warmcat.com>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 15:12:39 -0400
Message-Id: <1175195559.12052.14.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-03-29 at 14:31 +0100, andy@warmcat.com wrote:
> plain text document attachment
> (mac80211-sparse-annotate-radiotap-header-pavel-roskin.diff)
> Document that all fields must be little endian.  Use annotated types
> even in the comments.  Consistently use shorter type names (u8, s8). 
> Realign the comments.

I don't know what it means, but I think wireless-dev should just copy
include/net/ieee80211_radiotap.h from wireless-2.6.  The later has more
fields, and it turns out they are approved by David Young, the radiotap
maintainer.

There is no reason mac80211 would need to change that file.

>   *
> - * IEEE80211_RADIOTAP_FCS           	u32       data
> + * IEEE80211_RADIOTAP_FCS           	__le32          data
>   *
>   *	FCS from frame in network byte order.

I sent a patch yesterday that removes this part altogether.

I'm fine with this patch, I'm just saying that adjusting the patch is
more work than copying the file.

-- 
Regards,
Pavel Roskin

