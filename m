Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:37890 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265AbZKURUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2009 12:20:16 -0500
Received: by yxe17 with SMTP id 17so3700284yxe.33
        for <linux-wireless@vger.kernel.org>; Sat, 21 Nov 2009 09:20:22 -0800 (PST)
Message-ID: <4B081FDC.7000302@lwfinger.net>
Date: Sat, 21 Nov 2009 11:14:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Duy Nguyen <dnlove@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Using wireless-testing tree
References: <70f6a1ed0911210845s5dd46374ie74e6e105433dcae@mail.gmail.com>
In-Reply-To: <70f6a1ed0911210845s5dd46374ie74e6e105433dcae@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2009 10:45 AM, Duy Nguyen wrote:
> Hi everyone, I downloaded and upgraded my kernel with wireless-testing
> tree.  I have some questions.
> 
> 1) I create my own git branch and modify only the mac80211 and
> ath5k/ath9k.  How do I compile only these modules and test them
> without having  to recompile and upgrade my whole kernel again.
> Because of the repetitive nature of modifying and testing drivers, I
> am trying to avoid this but is it possible?  Or compat-wireless is a
> better alternative.
> 
> 2) I have compat-wireless-2.6 tree in my wireless-testing tree.  I
> still don't know how to create my own compat-wireless even after going
> through the wiki online.
> cd compat-wireless-2.6
> make
> but it complains about some errors.
> 
> I am just wondering if you could share your most efficient ways
> working with wireless-testing tree.   Thanks.

I use the master branch of the wireless-testing git tree and introduce patches
from the mailing list and my own using quilt. That way patching and testing a
single driver usually entails only recompiling that driver and a 'sudo make
modules_install'. Furthermore, it is easy to back out the patches.

I also use wiggle to help with patches that do not apply cleanly, but needing it
is rare.

If you use the latest pull of wireless-testing, then compat-wireless is not
needed as you always have the latest from w-t.

Larry
