Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52830 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbaFJWLS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 18:11:18 -0400
Received: by mail-lb0-f169.google.com with SMTP id s7so4373256lbd.0
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 15:11:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402385153-5056-2-git-send-email-janusz.dziedzic@tieto.com>
References: <1402385153-5056-1-git-send-email-janusz.dziedzic@tieto.com> <1402385153-5056-2-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 10 Jun 2014 15:10:56 -0700
Message-ID: <CAB=NE6X=Uzu_SQbaHuA-uVoU+tdz=yW6PuBOgDyB75VOG1EFOw@mail.gmail.com> (sfid-20140611_001121_831620_E63511CD)
Subject: Re: [RFC 2/2] crda: add crda_tiny implementation
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2014 at 12:25 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> add crda_tiny and crda.sh implementation.
> This implementation base on db.txt file
> signed via PGP. Next crda.sh do db.txt veryfication.
> crda_tiny as a input get regulatory domain
> in text format, parse this and send using
> nl80211 to the kernel.
> This implementation skip regulatory.bin file and
> works directly on signed db.txt file.
>
> Added gpg directory with db_signed.txt file and public key
> required for veryfication.
>
> crda.sh require installed gpg.
>
> To test just run:
> - make && make install
> - sh gpg/install.sh
> - cp /sbin/crda.sh /sbin/crda (or change udev rule)
>
> All logs will be available in /tmp/crda.err file

It seems Felix had some other ideas on how to scale binary
compatibility, this doesn't seem to care for it.

  Luis
