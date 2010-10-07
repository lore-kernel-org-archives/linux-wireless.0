Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59974 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab0JGWyd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 18:54:33 -0400
Subject: Re: [RFC v2] mac80211: fix possible null-pointer dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Steve deRosier <steve@cozybit.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
In-Reply-To: <AANLkTinCkWGs_KMz+QBUw2J5HUVU2hK1+8kVDr_PNZwP@mail.gmail.com>
References: <201009210057.13297.chunkeey@googlemail.com>
	 <20100924180013.GD8077@tuxdriver.com>
	 <201009250002.21219.chunkeey@googlemail.com>
	 <AANLkTinCkWGs_KMz+QBUw2J5HUVU2hK1+8kVDr_PNZwP@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 00:54:32 +0200
Message-ID: <1286492072.20974.49.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 15:38 -0700, Steve deRosier wrote:

> Javier and I reviewed the patch and it definitely fixes a potential
> problem and is correct.  Furthermore, applied to wireless-testing
> head, it passes all of our cases in our test bed.
> 
> I think it's good to go.

Err, are you positive? I think the code there is correct, apart from the
fact that it does no validation of
mgmt->u.action.u.plink_action.action_code whatsoever which may allow all
kinds of abuse :)

The only action that's valid w/o having a station entry for the peer is
PLINK_OPEN, which makes perfect sense.

johannes

