Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:35465 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbcAAX2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 18:28:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAM_iQpX-vHywG6DJb=5wLCouNAXXqA1wo=tKJ1S78MDyZfkNCw@mail.gmail.com>
References: <CACT4Y+baorktL_dBHEWcz_jHYTzhM_-DJoms81bzVx8FbYk63w@mail.gmail.com>
	<CAM_iQpX-vHywG6DJb=5wLCouNAXXqA1wo=tKJ1S78MDyZfkNCw@mail.gmail.com>
Date: Fri, 1 Jan 2016 15:28:53 -0800
Message-ID: <CAM_iQpWYqhOQZWB0Oo=Oa2GWGhy_HxunfpEPzjwha3iz9jJ9UQ@mail.gmail.com> (sfid-20160102_002900_537661_7AABCBDE)
Subject: Re: net/nfc: GPF in llcp_sock_getname
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	syzkaller <syzkaller@googlegroups.com>,
	Kostya Serebryany <kcc@google.com>,
	Alexander Potapenko <glider@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 1, 2016 at 12:58 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> It looks like we forget to initialize ->service_name_len
> and ->servicce_name before bind().

Never mind, __GFP_ZERO is passed in sk_alloc()...
