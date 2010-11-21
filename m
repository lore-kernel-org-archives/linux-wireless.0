Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39135 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab0KUFx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 00:53:56 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=QdfdhVcK2tddsaLYzatJEr6KRRoU5pMqKZwte@mail.gmail.com>
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
 <20101118164552.GC2855@kroah.com> <AANLkTing6JkfH=n2GfWtW+2=5oB40FDM-TYPvzd+PPkH@mail.gmail.com>
 <AANLkTi=QdfdhVcK2tddsaLYzatJEr6KRRoU5pMqKZwte@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 20 Nov 2010 21:53:35 -0800
Message-ID: <AANLkTinfF6yN_9YJ4=1u_O_3-c+aptLuuK=Z=g67fBsa@mail.gmail.com>
Subject: Re: Challenges with doing hardware bring up with Linux first
To: Adrian Chadd <adrian@freebsd.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stephen Hemminger <shemminger@vyatta.com>,
	"Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
	Charles Marker <Charles.Marker@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Kevin Hayes <kevin@atheros.com>,
	Zhifeng Cai <zhifeng.cai@atheros.com>,
	Don Breslin <Don.Breslin@atheros.com>,
	Doug Dahlby <Doug.Dahlby@atheros.com>,
	Julia Lawall <julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 20, 2010 at 4:32 PM, Adrian Chadd <adrian@freebsd.org> wrote:
> On 19 November 2010 00:53, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
>
>>> Also, please review the past multi-os driver initiatives that have
>>> sprung up over the years (about 1 every 10 years it seems).  Please
>>> learn from the past as to why those have failed every single time, and
>>> why we don't want to even try to do that again.
>>
>> :-) thanks, just testing waters to see what's possible and what
>> direction to focus more on.
>
> Being involved atm in the "re-multi-OS'ing" of ath code (ie, merging
> some ath9k bits and pieces back into FreeBSD's HAL), I really
> appreciate how the bulk of the hardware-fiddling bits are OS agnostic.
> There's some messiness surrounding the 802.11 stack flags (which the
> FreeBSD HAL "indirects" via HAL flags, hiding away some of the
> net80211 internals) but a lot of the net80211 stuff is still tightly
> integrated with the HAL. There's some platform specific stuff in
> hardware twiddling functions (eg "am I a 40mhz channel? Am i a 2ghz
> channel") but so far it's been straightforward to translate the
> macros.
>
> Now that I've just begun testing (what seems like!) functioning 11n
> TX/RX in my HAL, I plan on starting to merge in more ath9k related
> driver code in. I'll provide some more feedback to the ath9k-devel
> list as I do this. I'm hoping that large chunks of the hardware
> related code (eg AR9002 calibration) can be thrown in with very minor
> changes.
>
> But so far, I have this to say:
>
> * decoupling the hardware twiddling stuff from OS/802.11 stack
> specific stuff is helpful;

ath9k_hw mostly is 802.11 stack independent except band enum usage,
and maybe one other variable we stuffed in there to help clean out
code more.

> * some of the base types are different (eg integer type layout, bool,
> etc), but that's relatively straightforward to merge over;

OK

> * keeping the bits that need locking in "higher level" files (ie,
> separate from hardware twiddling as much as possible) is also helpful.

We do this already.

> * trying to make the actual interface related code (eg "if_ath.c" in
> FreeBSD; it's been broken out in ath9k) platform agnostic is likely
> very difficult and a path to the parent posters "fail."

Agreed. Thanks for your feedback.

  Luis
