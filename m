Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f193.google.com ([209.85.160.193]:35409 "EHLO
	mail-yk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbbLUV7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 16:59:23 -0500
MIME-Version: 1.0
In-Reply-To: <20151217193350.GR20409@wotan.suse.de>
References: <1449597684-4631-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1449597684-4631-4-git-send-email-zohar@linux.vnet.ibm.com> <20151217193350.GR20409@wotan.suse.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 21 Dec 2015 13:58:59 -0800
Message-ID: <CAB=NE6VdHKXsWmbRHOAkJb9ph_mkLUE_Du5c9n2entUNWY=+rw@mail.gmail.com> (sfid-20151221_225936_980078_886D7AA0)
Subject: Re: [PATCH v1 3/7] ima: load policy using path
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
	Dmitry Kasatkin <d.kasatkin@samsung.com>,
	linux-ima-devel@lists.sourceforge.net,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Roberts@suse.de,
	William C <william.c.roberts@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Tom Gundersen <teg@jklm.no>,
	Johannes Berg <johannes@sipsolutions.net>,
	Seth Forshee <seth.forshee@canonical.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Kyle McMartin <kyle@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Ming Lei <ming.lei@canonical.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Hannes Reinecke <hare@suse.de>, Takashi Iwai <tiwai@suse.de>,
	Rik van Riel <riel@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 17, 2015 at 11:33 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> Please no, instead of adding yet-another kernel file-loading facility which is
> likely error prone we should consolidate *all kernel file-loading facilities*
> into a *common generic shared one*. So please work to make that happen since you
> need yet-another user for it.m.com
>
> Since you need yet-naother kernel file-loader please do the work to generalize
> it, or at least try it.

As per review in another thread with Mimi we determined they're not
adding a *new* reader, but using an existing one. The possible issues
with early read and pivot_root() as well as possible considerations
for a common user mode helper are still relevant for when we
generalize a common kernel loader. Mimi has also pointed out a few
other kernel loaders. It seems we'll try to tackle this after the
holidays. To help keep track of progress and consolidate notes on this
I've stuffed details about this on this wiki:

http://kernelnewbies.org/KernelProjects/common-kernel-loader

  Luis
