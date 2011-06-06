Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45372 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab1FFMPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 08:15:21 -0400
Received: by iyb14 with SMTP id 14so3040936iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 05:15:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DEC825A.2020404@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <1306928768-7501-44-git-send-email-rvossen@broadcom.com> <BANLkTin1hT2WT40_uozZvtX-PH5aZHqfZg@mail.gmail.com>
 <4DE90DCE.6060207@broadcom.com> <BANLkTimQacOURw4wQzkyNizksZZj=nhvfQ@mail.gmail.com>
 <4DEB3FF3.8090904@broadcom.com> <BANLkTi=HrP5pSi0t-18N2yGpBueeL2qMSg@mail.gmail.com>
 <4DEC825A.2020404@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 6 Jun 2011 22:14:59 +1000
Message-ID: <BANLkTin1Cv9L+mDDjXSPEPthPPX2uGtaVQ@mail.gmail.com> (sfid-20110606_141524_508258_0EA540AF)
Subject: Re: [PATCH 44/83] staging: brcm80211: replaced typedef si_t with
 struct si_pub
To: Roland Vossen <rvossen@broadcom.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 6, 2011 at 17:31, Roland Vossen <rvossen@broadcom.com> wrote:
> Hi Julian,
>
>>> I am afraid I have to disagree with you, for the reason that by including
>>> the header file you introduce unnecessary coupling. Let me elaborate. If
>>> a
>>> .c file does not need to know the contents of a struct, but it only needs
>>> to
>>> know that a pointer to an opaque struct, then one should not provide the
>>> C
>>> file with knowledge on the internals of the struct (hence not include the
>>> .h
>>> file).
>>
>> Fair enough. I guess I just don't like void pointers.
>
> Well, what I mean is this: suppose you have a function that gets a pointer
> to a struct as one of its parameters. This function calls another function
> with this parameter:
>
> void foo(struct *bar) {
>        some_other_fnct(bar);
> }
>
> Then foo() simply passes the pointer on to some_other_fnct(), and foo() does
> not need to know about the members inside struct bar. So I am not talking
> about void pointers here as the alternative.

The reason I was pointing this out was that while foo() doesn't need
to know what's in struct bar, it will help type safety and general
code cleanliness to have some declaration of struct bar in the
headers.

If we have a module that exports a set of functions in it's header
file (say "bar.h") like:

extern struct bar *get_bar();
extern void foo(struct bar *bar);

the struct bar is part of the API of the module, even if no caller
ever uses it's internals. Therefore the header file should include the
line:

struct bar;

so that users of the API don't have to declare it themselves to
suppress the compiler warnings that would be generated otherwise.

My objection was to the struct declaration appearing at the top of
wl_iw.c, rather than in the header file that defines the functions
that use it.

In fact, looking a bit further around, it appears that this
declaration is already in aiutils.h making it's appearance at the top
of wl_iw.c completely redundant, especially given that the file in
question appears to not use *any* functions that use the struct, and
if it does, it should include aiutils.h rather than declaring the
struct itself - and this isn't introducing extra coupling, this is
merely including the header that defines the API for the code that
actually uses this struct.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
