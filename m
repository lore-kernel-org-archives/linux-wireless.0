Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38488 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2ECVfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 17:35:16 -0400
Received: by obbtb18 with SMTP id tb18so2999981obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 14:35:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336073629.5167.13.camel@jlt3.sipsolutions.net>
References: <201203281117.53033.tlnd@online.de> <201203281128.27956.tlnd@online.de>
 <1332927150.3479.25.camel@jlt3.sipsolutions.net> <201203281547.21550.tlnd@online.de>
 <20120430183454.GE2560@tuxdriver.com> <1336073629.5167.13.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 3 May 2012 14:34:55 -0700
Message-ID: <CAPjQAd9wr8qdiJc1LobKu_OJWY1drJ+SWQfXUDhbLLEGK1q1Rw@mail.gmail.com> (sfid-20120503_233521_088052_47E5004A)
Subject: Re: [PATCH] mac80211_hwsim: Report rate info in tx status
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Timo Lindhorst <tlnd@online.de>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 3, 2012 at 12:33 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-04-30 at 14:34 -0400, John W. Linville wrote:
>> On Wed, Mar 28, 2012 at 03:47:21PM +0200, Timo Lindhorst wrote:
> (...)
> I'm a little confused about this discussion & Javier's patch though --
> are they related?

Yes they are.  My patch¹ was fixing the same problem with rate
adaptation, but I only handled the case of successful transmission.
Timo's patch fixes rate reporting for both successful and failed
transmissions, which, in the in-kernel perfect/broken link simulation
is all that we need.
I would recommend you ignore my patch and take Timo's.

As for the in-userspace case, the driver is giving the userspace
daemon (e.g. wmediumd) control over which rates to report (see
hwsim_tx_info_frame_received_nl() for details).

Cheers,

Javier


[1] http://www.spinics.net/lists/linux-wireless/msg89454.html

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
