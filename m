Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:64701 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156AbZCJSux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 14:50:53 -0400
Message-ID: <49B6B630.4000301@gentoo.org> (sfid-20090310_195106_314989_06D5B226)
Date: Tue, 10 Mar 2009 14:49:20 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] zd1211rw: remove zd_addr_t typedef for a simple u16
References: <1236651030-10331-1-git-send-email-lrodriguez@atheros.com> <49B66A73.4030408@gentoo.org> <20090310163810.GA6140@tesla>
In-Reply-To: <20090310163810.GA6140@tesla>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> It would seem to make the code cleaner and more legible but it just fixed a
> sparse warning for me. Unfortunately I don't have an old zydas hardware to
> test it with too though.

The line in question:
	if (int_num == CR_INTERRUPT) {

The usage of CR_INTERRUPT wrong here; in this specific case, we are not 
looking to match a register address. It's a separate constant which is 
also treated separately from register addresses in the zydas documentation.

CR_INTERRUPT should be replaced with 0x9510, or perhaps a new constant e.g.
#define INTR_STS1_MAC_INTERRUPT 0x9510

I'm afraid that I don't have any hardware here to test with either, but 
the above change should be safe enough to go through without testing.

Thanks,
Daniel

