Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:63523 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678AbbGVEB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 00:01:27 -0400
Date: Wed, 22 Jul 2015 06:01:24 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: Taahir Ahmed <ahmed.taahir@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] Support python 3 in utils/key2pub.py.
Message-ID: <20150722060124.250c6f2c@mir> (sfid-20150722_060131_817811_A22F62B4)
In-Reply-To: <2988720.J8nzy94PWW@basis>
References: <1437525466-27512-1-git-send-email-ahmed.taahir@gmail.com>
	<1437525466-27512-2-git-send-email-ahmed.taahir@gmail.com>
	<20150722045045.30642c25@mir>
	<2988720.J8nzy94PWW@basis>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On 2015-07-21, Taahir Ahmed wrote:
> On Wednesday 22 July 2015 04:50:45 Stefan Lippers-Hollmann wrote:
> > You omit $(pwd) from ./utils/key2pub.py, while /utils/key2pub.py
> > won't exist.
> 
> Wow, that's a really bad mistake on my part.  It should indeed probably
> be './utils/key2pub.py'.  I made this change after my general testing,
> simply because emacs was undoing the execute bit every time I saved
> key2pub.py.
> 
> It's not really a material change, so I'll probably just put it back the
> way it was.
> 
> The rest of the patch is tested, I pinky-swear :)
>  
> > As little as I know about python packaging policies in Debian
> > (and probably Fedora), /usr/bin/python is never supposed to point
> > to python3 - afaik the interpreter should always be called python3
> > there, so I don't really see how that's going to work there.
> 
> I'm not assuming that the system interpreter is any particular version:
> key2pub.py has been modified so it runs under either 2.7 or 3.x.
> 
> Some more simplification might be possible if 2.7 support is dropped,
> but not much, and I didn't want to rock the boat.

The problem, as I understand it, is that the python3 interpreter will
never be available as (/usr/bin/)python on Debian (or Fedora; even if
python2.x is not installed on the system), but always be called python3. 
So your new python3 compatibility is never actually used, neither on a 
python3-only system.

Therefore I'd suggest this approach instead, either make the python
interpreter user configurable, e.g.:

PYTHON ?= python

so the user can specify the interpreter when invoking make (as in
make PYTHON=python3), xor trying to auto-detect it (untested):

ifeq ($(shell which python3),)
  PYTHON = python
else
  PYTHON = python3
endif

and then using 

$(Q) $(PYTHON) ./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@

wherever python is needed.

Regards
	Stefan Lippers-Hollmann
