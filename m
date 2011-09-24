Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1IXQbT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Sep 2011 12:31:19 -0400
Date: Sat, 24 Sep 2011 18:30:07 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	"Bernhard M. Wiedemann" <bernhardout@lsmod.de>
Cc: wireless <linux-wireless@vger.kernel.org>,
	Ivo van Drn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: Bug in rt2800pci on an RT3090
Message-ID: <20110924163007.GA10001@redhat.com> (sfid-20110924_183124_476355_CBFF99C2)
References: <4E7CEE67.2070906@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E7CEE67.2070906@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 23, 2011 at 03:39:03PM -0500, Larry Finger wrote:
> A bug was sent to me concerning a scheduling-while-atomic-BUG. This
> happened shortly after KDE suspended an eeepc1015PE netbook during
> system update over WLAN. Suspend&resume normally worked allright.
> The OP is Berhard Wiedemann in the Cc list. Inquiries for more info
> go to him.

It looks like we forgot to unlock spinlock somewhere or we do not
use _irqsave version of spinlock where needed, but provided calltrace
is not naught to find the bug.

I suggest compile kernel with CONFIG_LOCKDEP, try to reproduce and see
if we do get some more messages.

Stanislaw
