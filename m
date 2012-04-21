Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:44396 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab2DUNTn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 09:19:43 -0400
Date: Sat, 21 Apr 2012 15:19:22 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Kalle Valo <kvalo@adurom.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] wireless: at76c50x: allocating too much data
In-Reply-To: <20120421124523.GS6498@mwanda>
Message-ID: <alpine.DEB.2.02.1204211518420.1987@hadrien> (sfid-20120421_152020_456895_9DE4D61F)
References: <20120420064705.GE22649@elgon.mountain> <CAGRGNgVgtAYknmpB_8Q0OpcUWFjTxBistG+RNs1ORDZeckGsWw@mail.gmail.com> <20120420091449.GI27101@mwanda> <87vcku9sob.fsf@purkki.adurom.net> <20120421124523.GS6498@mwanda>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-863727080-1335014362=:1987"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-863727080-1335014362=:1987
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 21 Apr 2012, Dan Carpenter wrote:

> On Fri, Apr 20, 2012 at 09:14:44PM +0300, Kalle Valo wrote:
>> Dan Carpenter <dan.carpenter@oracle.com> writes:
>>
>>> On Fri, Apr 20, 2012 at 06:57:00PM +1000, Julian Calaby wrote:
>>>>> -       struct mib_local *m = kmalloc(sizeof(struct mib_phy), GFP_KERNEL);
>>>>> +       struct mib_local *m = kmalloc(sizeof(struct mib_local), GFP_KERNEL);
>>>>
>>>> Would it be better practice to use sizeof(*m)?
>>>>
>>>
>>> That was my temptation as well...  But I decided to make it match
>>> with the surrounding code.  I'm happy to resend if people want.
>>
>> IMHO sizeof(*m) is better and I tend to use it.
>>
>> Related to this: I have a bad habit of sometimes dropping '*' from
>> sizeof()? Is there a tool which could spot that?
>>
>
> That's what I was working on for Smatch when I sent this patch.
>
> The odd thing is that I can't find any bugs like this in the kernel.
> If sizeof(foo) is less than sizeof(*foo), which is probably the
> normal case, then these get caught early on in testing.
>
> Still I think people must have done manual audits as well...  It
> feels too clean to be natural.

I sent some patches with respect to this.  But that was probably around a 
year ago.

julia
--8323329-863727080-1335014362=:1987--
