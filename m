Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:33510 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbcB2WjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:39:24 -0500
Date: Tue, 1 Mar 2016 00:39:18 +0200
From: Jouni Malinen <j@w1.fi>
To: =?utf-8?B?Sm/Do28=?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux@endlessm.com,
	=?utf-8?B?Sm/Do28=?= Paulo Rechi Vita <jprvita@endlessm.com>
Subject: Re: [PATCHv2 08/10] rfkill: Use switch to demux userspace operations
Message-ID: <20160229223918.GA32464@w1.fi> (sfid-20160229_233949_019358_68CBA088)
References: <1456159001-20307-1-git-send-email-jprvita@endlessm.com>
 <1456159001-20307-9-git-send-email-jprvita@endlessm.com>
 <20160226175925.GA9331@w1.fi>
 <CA+A7VXUY=qVDQ-OqT+QJK8haN6AFX4Br=OPXi-6RCxpvH3=QRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CA+A7VXUY=qVDQ-OqT+QJK8haN6AFX4Br=OPXi-6RCxpvH3=QRg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 29, 2016 at 05:30:20PM -0500, João Paulo Rechi Vita wrote:

> I agree there is a difference in the logic here, thanks for taking the
> time to point it out so clearly, and sorry for missing this. But AFAIU
> userspace should not call RFKILL_OP_CHANGE with ev.type ==
> RFKILL_TYPE_ALL, as RFKILL_OP_CHANGE is intended to be used to
> block/unblock one RFKill switch, and it is not possible to create a
> RFKill switch with type == RFKILL_TYPE_ALL (rfkill_alloc() would
> return NULL).

Interesting. Maybe Johannes can comment on that part since I think he
wrote the code that interacts with kernel for the rfkill test cases.

> I tried to look into the source code of the test suite you pointed,
> but couldn't easily figure out how it ends up with that combination.
> Could you please explain (or point me in the code) how is that a valid
> operation? If I'm not missing anything, we should probably return
> EINVAL in this case.

These specific failures were shown for the test cases in this file:
http://w1.fi/cgit/hostap/tree/tests/hwsim/test_rfkill.py

The interaction with kernel is done using this code:
http://w1.fi/cgit/hostap/tree/tests/hwsim/rfkill.py

It does indeed look like TYPE_ALL is used here (the block() and
unblock() implementations). If this is incorrect, we can certainly
change the script since I'd assume this is not used for anything else
than the hwsim test cases (or well who knows, it is available out there,
so if someone needs python code to do rfkill operations..).
 
-- 
Jouni Malinen                                            PGP id EFC895FA
