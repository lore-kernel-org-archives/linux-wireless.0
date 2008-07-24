Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:33409 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYGXHFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 03:05:43 -0400
Received: by an-out-0708.google.com with SMTP id d40so608346and.103
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 00:05:42 -0700 (PDT)
Message-ID: <43e72e890807240005j5d37d7eat73f571288ea7a00b@mail.gmail.com> (sfid-20080724_090547_584889_6FE35D41)
Date: Thu, 24 Jul 2008 00:05:42 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [ath5k-devel] AR5418 works with ath9k
Cc: "Davide Pesavento" <davidepesa@gmail.com>,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1216870929.30436.34.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2da21fe50807221453m5275f59dj7369da5e667815d7@mail.gmail.com>
	 <43e72e890807230513u81e68aaj443110d734161368@mail.gmail.com>
	 <1216870929.30436.34.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 8:42 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Wed, 2008-07-23 at 05:13 -0700, Luis R. Rodriguez wrote:
>> > Maybe MacBook Pro's card has different eeprom's contents? Anyway the
>> > card now works fine, and it also appears quite stable! ;-)
>> > Thank you very much for your work!
>>
>> I believe your last patch may have been "Use skb_end_pointer() ..." if
>> so then this is why you had this issue. Give the git tree a shot:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/ath9k.git
>
> Luis, I'm afraid that code is still wrong.  It used to be min(), but now
> it's essentially max().  You wrote that there was an error in my patch
> and I agreed, but we were talking of different errors, I'm afraid.
>
> Since you have touched the code after me and you know more about the
> hardware, I would prefer that you fix it and recheck everything once
> again.
>
> Here's the patch.  I don't feel comfortable about describing things I
> don't fully understand.

Pavel, you are correct, thanks for the new fix. I'll arrange so that
the patch that goes in only fixes this once on wireless-testing.

  Luis
