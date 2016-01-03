Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:35579 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbcACWgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 17:36:18 -0500
MIME-Version: 1.0
In-Reply-To: <CACT4Y+Y6YCYA_v=--spYpPDYj3Jo0cXcntFRe8XzYS3NJFUwqQ@mail.gmail.com>
References: <1451694857-21873-1-git-send-email-xiyou.wangcong@gmail.com>
	<1451694857-21873-2-git-send-email-xiyou.wangcong@gmail.com>
	<CACT4Y+Y6YCYA_v=--spYpPDYj3Jo0cXcntFRe8XzYS3NJFUwqQ@mail.gmail.com>
Date: Sun, 3 Jan 2016 14:36:17 -0800
Message-ID: <CAM_iQpVMk5nutJ=F=mGR9vw4n0A8JJMODfpN_wt=_k5mwa+MBA@mail.gmail.com> (sfid-20160103_233629_660453_DA3F765A)
Subject: Re: [Patch net] nfc: check sock state in llcp_sock_getname()
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 2, 2016 at 12:03 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Sat, Jan 2, 2016 at 1:34 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>> llcp_sock_getname() checks llcp_sock->dev to make sure
>> llcp_sock is already connected or bound, however, we could
>> be in the middle of llcp_sock_bind() where llcp_sock->dev
>> is bound and llcp_sock->service_name_len is set,
>> but llcp_sock->service_name is not, in this case we would
>> lead to copy some bytes from a NULL pointer.
>>
>> We should just check if sk->sk_state is still closed since
>> both connect() and bind() will update this state at the end.
>
> Hi Cong,
>
> This is still racy. If you want to play lock-free then you also need
> proper memory barriers. Stores to sk_state need to be
> smp_store_release, while the load needs to be smp_load_acquire.
> Otherwise getname still can see partially initialized socket.
>

Right... Or just lock sock perhaps. I will update my patch.

Thanks!
