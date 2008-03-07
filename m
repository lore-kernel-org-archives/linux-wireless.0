Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.239]:64560 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782AbYCGRPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 12:15:50 -0500
Received: by qb-out-0506.google.com with SMTP id e11so499515qbe.15
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2008 09:15:47 -0800 (PST)
Message-ID: <43e72e890803070915l35564f7ao1c25752b03a9531d@mail.gmail.com> (sfid-20080307_171602_378837_69FA0291)
Date: Fri, 7 Mar 2008 12:15:44 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [PATCH 0/8] ath5k: latest revised patches
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@lists.ath5k.org, "Jiri Slaby" <jirislaby@gmail.com>,
	"Bob Copeland" <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <40f31dec0803070432i2e313b32q68493f0af4a0105c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890802281456j22236cdegb4cf0c90d954af05@mail.gmail.com>
	 <43e72e890803061907j2dca57f1k6907e2942f8a70fc@mail.gmail.com>
	 <40f31dec0803070432i2e313b32q68493f0af4a0105c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 7, 2008 at 7:32 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:

>
>  As i've told you in private, i'm not O.K. with the helper function you
>  introduced in 7/8 because:
>
>  a) It makes cross-reference with dumps more difficult for no reason.

This is not accurate, I stated the reasons why I did it:

a. To not hit the 80-char limitb
b. To not make multiple hw_writes span two lines
c. To make ath5k_hw_reset() shorter

>  b) It doesn't make sense to have a helper function for only one chip
>  and for only one single 5212-specific part of code. There is a lot of
>  chip-specific code in hw_reset, either we make a helper function for
>  each chip containing all chip-specific code or we leave it as it is -i
>  prefer the second since order there matters + it will make
>  cross-reference much more difficult-, grabbing just a small part of
>  chip-specific code and calling it a helper function for that chip
>  doesn't make sense and is misleading IMHO.

This I agree with -- what I'll do is keep the code in the reset, some
writes will span more than two lines and then in another independent
patch I'll address re-writing reset split into different logical
components.

>  c) It doesn't make sense to introduce a small function that's only
>  called once + have the above issues just to avoid 80-column limit.

Actually I think it does, but moreover I think this proves we need a
re-write on ath5k_hw_reset().

>  d) In general i don't think introducing a function for style-reasons
>  is a good practice since it's misleading and in fact makes code
>  readability worse.

I think it depends but in our case, like I said I think we need to
split ath5k_hw_reset() into different logical components to make it
more readable, even if that means taking some code out into helpers.
The benefit will be to use helpers that *do* make sense, even they are
used once. The problem with my helper is its for some writes for which
we are not sure of what they do yet.

>  so please resubmit that patch without the helper function and you'll
>  get my ACK (well it'll be my patch then + checkpatch fixes so
>  ACK/signed-off-by makes no difference :P).

Coming up.

>  As for the pci-e patch i've also told you what i think both public and
>  in private, however since a fix for these cards (2424/5424/2425) is
>  needed asap i'm ok with any given approach (mine + Bob's patch or
>  your's), so i leave it up to John to decide.

I do think its best to go with using struct pci_dev's is_pcie member.
We can deal with ahb when we get there and I think there are more
reasonable ways to deal with it and then adding a ah_ispcie, afterall
-- the difference between ahb and other devices is what bus they're
on, not if the device is PCI-E or not.

  Luis
