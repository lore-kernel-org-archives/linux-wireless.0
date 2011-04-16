Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36206 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab1DPSth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2011 14:49:37 -0400
Received: by iwn34 with SMTP id 34so2900867iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 16 Apr 2011 11:49:36 -0700 (PDT)
Subject: Re: crda fails to compile
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Alex <alfragk@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 16 Apr 2011 14:49:33 -0400
In-Reply-To: <4DA8163F.6040308@gmail.com>
References: <4DA8163F.6040308@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1302979775.17255.4.camel@nayuki>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-15 at 12:56 +0300, Alex wrote:
> Hi,
> 
> the last couple of days i've beeen trying to compile crda on my linux 
> box (gentoo) without success.
> 
> I've downloaded crda-1.1.1, and i've installed all the requirements as 
> described in the README file.
> 
> However, when i run make i get the following error:
> 
> GEN  keys-gcrypt.c
>    Trusted pubkeys: pubkeys/linville.key.pub.pem
>    File "./utils/key2pub.py", line 6
>      except ImportError, e:
>                        ^
> SyntaxError: invalid syntax
> make: *** [keys-gcrypt.c] Error 1
> 
> 
> Any help would be appreciated,

My guess is that your system installation of python (/usr/bin/python) is
actually python-3 instead of python-2. The two versions are
incompatible: a python-2 script won't run on python-3 without porting.

On gentoo you can switch your default python version back to 2 by
running the commands:

# eselect python list
Available Python interpreters:
  [1]   python2.7
  [2]   python3.1 *
# eselect python set 1

Also note that gentoo has a crda package available which you could use
instead (I'd recommend this if you're not trying to develop crda):

emerge net-wireless/crda

Hope that helps.
-- 
Calvin Walton <calvin.walton@kepstin.ca>

