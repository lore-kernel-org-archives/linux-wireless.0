Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64572 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1EIPUi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 11:20:38 -0400
Received: by vxi39 with SMTP id 39so5843161vxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 08:20:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikAYtW5o9rVS_WT-1XuGQVXOucjZg@mail.gmail.com>
References: <4DC2C743.9060004@01019freenet.de>
	<BANLkTi=V2=UpZENHek37q2D43KZyeAiO-Q@mail.gmail.com>
	<20110509114601.GA27067@zenon.in.qult.net>
	<BANLkTikAYtW5o9rVS_WT-1XuGQVXOucjZg@mail.gmail.com>
Date: Mon, 9 May 2011 17:20:37 +0200
Message-ID: <BANLkTimsS+efr9WJ8FnLt5WM7H4V9itZiw@mail.gmail.com> (sfid-20110509_172041_737303_96764CCA)
Subject: =?windows-1252?Q?Re=3A_compile=2Derror_agg=2Dtx=2Ec=3A_error=3A_implicit_declarat?=
	=?windows-1252?Q?ion_of_function_=91kfree=5Frcu=92?=
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Ignacy Gawedzki <i@lri.fr>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, May 9, 2011 at 3:32 PM, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> On Mon, May 9, 2011 at 5:16 PM, Ignacy Gawedzki <i@lri.fr> wrote:
>> On Fri, May 06, 2011 at 10:35:08AM +0530, thus spake Mohammed Shafi:
>>> On Thu, May 5, 2011 at 9:20 PM, Andreas Hartmann
>>> <andihartmann@01019freenet.de> wrote:
>>> > Hello,
>>> >
>>> > since May, there is a compile error in compat-wireless (against kernel
>>> > 2.6.34):
>>
>> I, as it appears with many others, have the same kind of trouble compiling the
>> latests compat-wireless snapshots on some kernels (2.6.38 for me).

I'm having this problem as well with a 2.6.24 kernel.

The file /include/linux/rcupdate.h , and maybe other files too,
need to be included in the compat-wireless package
as the function kfree_rcu is actually introduced in a patch for
the current linux-next tree.

I guess they'll be fixing that soon, in the meantime try copying the missing
 file(s) manually.

>>
>> Obviously the kfree_rcu machinery should go into some compat/ source file.  In
>> the meantime, I personnaly reverted these changes (see attached patch) and it
>> works just fine.
>
> I blindly used your patch and now the compat-wireless is compiling for me.
> thanks a lot.
>
> with regards,
> shafi
>
>>
>> --
>> /* This is not a comment */
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Juan Carlos Garza
