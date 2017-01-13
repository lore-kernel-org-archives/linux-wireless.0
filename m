Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33245 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbdAMVbK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:31:10 -0500
Received: by mail-wm0-f65.google.com with SMTP id r144so14577676wme.0
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 13:31:09 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        lede-dev@lists.infradead.org, openwrt-devel@lists.openwrt.org,
        john@phrozen.org, nbd@nbd.name, roman@advem.lv, evaxige@qq.com,
        c.mignanti@gmail.com, michel.stempin@wanadoo.fr,
        vasilugin@yandex.ru, Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [RFC] [PULL REQUEST] rt2x00 patches from OpenWrt.org
Date: Fri, 13 Jan 2017 22:22:49 +0100
Message-ID: <3737186.dsyT6cYTFQ@debian64> (sfid-20170113_223113_522107_8681A493)
In-Reply-To: <20170113154629.GG2332@makrotopia.org>
References: <20170113035020.GA9063@makrotopia.org> <87tw93i6e7.fsf@purkki.adurom.net> <20170113154629.GG2332@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, January 13, 2017 4:46:30 PM CET Daniel Golle wrote:
> On Fri, Jan 13, 2017 at 12:46:56PM +0200, Kalle Valo wrote:
> > Daniel Golle <daniel@makrotopia.org> writes:
> > > ...
> > > Please review and comment, so we can get those patches merged!
> > 
> > No pull requests, please. Instead send these as patches, easier to
> > review and actually also easier for me to merge.
> 
> The advantage of pull requests is that author information can be
> preserved more easily. Running git format-patch results in most patches
> having wrong SMTP sender information due to the assumption that the
> patch author is the same person also submitting the patch.
> So in practise, this would either require changing the From: (and thus
> Author) to myself or having most mails eaten by anti-spam measures due
> to non-matching SPF which prohibits my SMTP to send mail on behalf of
> the original authors of the patches.
> 
> How do you suggest to handle this situation?
> 
>From what I know, git format-patch and send-email [0] will add a second
FROM: in the email's body with the author of the commit automatically
(if author isn't you). This is what it did, when I posted the apm821xx
patches on lede-dev [1] (Look at the additional "FROM: Chris Blake ..."
line in these patches. Whereas the mail came from my address).

The MTA (MDA, ...) will use the first FROM: (your address) whereas git will
use the FROM in the mail body (so the patch will be correctly attributed to
the original patch author). If you don't want to bother the original
authors, you can look at the --suppress-cc=author option and enable --dry-run
on git send-email.

I would say, just give it a "dry".
(Sadly, I didn't find any documentation for this feature.
But I know it worked back then and it should be fine with SPF.)

Regards,
Christian

[0] <https://git-scm.com/docs/git-send-email>
[1] <http://lists.infradead.org/pipermail/lede-dev/2016-July/001865.html>
