Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32845 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYJ0VQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 17:16:48 -0400
Date: Mon, 27 Oct 2008 17:15:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] at76_usb: update drivers/staging/at76_usb w/ mac80211
	port
Message-ID: <20081027211553.GH20389@tuxdriver.com> (sfid-20081027_221653_102350_6649AD03)
References: <1224877739-1586-1-git-send-email-linville@tuxdriver.com> <20081027185634.GA21649@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20081027185634.GA21649@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 27, 2008 at 11:56:34AM -0700, Greg KH wrote:
> On Fri, Oct 24, 2008 at 03:48:59PM -0400, John W. Linville wrote:
> > This updates drivers/staging/at76_usb to correspond with the latest
> > version previously available in wireless-testing.
> >=20
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>=20
> I've applied this, but it does add the following warnings, which I do=
n't
> think you want to have:
> 	drivers/staging/at76_usb/at76_usb.c:885: warning: =E2=80=98at76_set_=
associd=E2=80=99 defined but not used
> 	drivers/staging/at76_usb/at76_usb.c:903: warning: =E2=80=98at76_set_=
listen_interval=E2=80=99 defined but not used
> 	drivers/staging/at76_usb/at76_usb.c:989: warning: =E2=80=98at76_add_=
mac_address=E2=80=99 defined but not used
>=20
>=20
> I'll remove these unused functions now from the in-kernel version.

Those were still there because Kalle had said he intended to use them.
I see no need to carry them since you have them in git anyway.

> Is there any way to do development on this in the staging version now=
,
> instead of the wireless-testing tree?

=46ine with me, although I do have at least one patch for it that
relates to a pending API change -- I just figured I'd wait for the
round-trip of the patch above and then carry just that patch in my
tree along with the mac80211 API changes that prompted it.  Any other
development makes sense to go to your tree.

Alternatively, I could just drop the patch I have completely or send
it to you to keep until 2.6.29...?

John
--=20
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
