Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1KXSSE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 13:18:04 -0500
Subject: Re: [PATCH v2 0/3] mac80211: timeout tx agg sessions in way
 similar to rx agg sessions
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com> (sfid-20111123_035046_552802_8E57CF1D)
References: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com>
	 (sfid-20111123_035046_552802_8E57CF1D)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 19:17:58 +0100
Message-ID: <1322158678.5366.27.camel@jlt3.sipsolutions.net> (sfid-20111124_191808_789823_1576ACB3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-22 at 21:50 -0500, Nikolay Martynov wrote:
> Currently tx aggregation is not being timed out even if timeout is
> specified when aggregation is opened. Tx tid stays active until delba
> arrives from recipient (i.e. recipient times out tid when it is
> inactive).
>   The problem with this approach is that delba can get lost in the air
> and tx tid will stay perpetually opened on the originator while closed
> on recipient thus all data sent via this tid will be lost.
>  The problem manifests itself with connection becoming slow/unusable
> with ping times jumping to 4s. At such time opened tx tid can be seen
> on one side of the connection without corresponding rx tid one the
> other side. This seems to be happening quite often soon after
> connection on ar9102 I have.
>   This patch implements tx tid timeouting in way very similar to rx tid
> timeouting.
> 
>   All comments and suggestions are appreciated.

Looks OK to me. Did you run it through sparse too? :-)

johannes

