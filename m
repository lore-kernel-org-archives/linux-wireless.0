Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56287 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab1GGPSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 11:18:08 -0400
Received: by gyh3 with SMTP id 3so415203gyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jul 2011 08:18:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110707144628.GF23944@broadcom.com>
References: <20110707002034.GA17885@broadcom.com> <CACna6rx5EyZ-=2XgWawdN_Qu2t1K1sdHZydZFW6=TiX2QUwMfw@mail.gmail.com>
 <4E1504A3.1070801@gnu.org> <20110707014512.GA21087@suse.de> <20110707144628.GF23944@broadcom.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 7 Jul 2011 17:17:47 +0200
Message-ID: <CAOiHx=k_Rjzq4-Q3xDLVxKz+soFvWjU0_8qXDSw5Sa1AdbT-AQ@mail.gmail.com> (sfid-20110707_171812_987810_B9B94FA7)
Subject: Re: [RFC] Move brcm80211 to mainline
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Greg KH <gregkh@suse.de>, Pavel Roskin <proski@gnu.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 7 July 2011 16:46, Henry Ptasinski <henryp@broadcom.com> wrote:
> We're looking at BE MIPS, and I sent some cards to Benjamin Herrenschmidt so he
> can test on PPC platforms.

BE MIPS currently doesn't compile (at least for me); the R_REG/W_REG
macros try to use ^ with pointers[1], which my gcc flags as errors.
Adding a cast to unsigned long silences the error, but I didn't yet
confirm whether this is the correct way of fixing it, and if it
actually works for 32 and 64 bit.

I would send a patch, but it might take some days until I come around
to creating/testing it - I don't mind if you fix it yourself.
Hopefully I can then even give a short status report how it works on
BE MIPS, after I finally got the PCIe working on my bcm6328 with a
bcm4313 ;-).


Jonas

[1] <http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git;a=blob;f=drivers/staging/brcm80211/brcmsmac/types.h;h=bbf21897ae0e32137c7f38bbabf5159a31b4cda7;hb=refs/heads/staging-next#l307>
and below
