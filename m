Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46452 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab2GIXug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 19:50:36 -0400
Received: by pbbrp8 with SMTP id rp8so19996454pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 16:50:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341845663-24539-1-git-send-email-ozancag@gmail.com>
References: <1341845663-24539-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 9 Jul 2012 16:50:11 -0700
Message-ID: <CAB=NE6UF57isp+z4j3c0JNyTKHKfUsbU1UhMYKbZdGfEaeLn3w@mail.gmail.com> (sfid-20120710_015040_570270_E4DF3571)
Subject: Re: [RFC] compat: Add ability to run as non-root
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2012 at 7:54 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> If the EUID of the process is not 0, assume that get-compat-kernels
> is run as a regular user and extract the downloaded *.deb files
> from debs/ into

> ksrcs/:

How about $HOME/ksrc/ ?

> ksrcs/
> ├── lib
> │   └── modules
> │       ├── 2.6.24-020624-generic
> │       ├── 2.6.25-020625-generic
> │       ├── ...
> │       └── 3.4.4-030404-generic
> └── usr
>     └── src
>         ├── linux-headers-2.6.24-020624
>         ├── linux-headers-2.6.24-020624-generic
>         ├── linux-headers-2.6.25-020625
>         ├── linux-headers-2.6.25-020625-generic
>         ├── ...
>         ├── linux-headers-3.4.4-030404
>         └── linux-headers-3.4.4-030404-generic

Nice!

> If you still want to use your kernel sources under /, run
> get-compat-kernels

Neat!

> or ckmake with 'sudo'.

How about instead having ckmake detect first if you have your
$HOME/ksrc/ and if so use that, otherwise go with the built in stuff ?

> Adjust ckmake to look into ksrcs/lib/modules instead of
> /lib/modules in the EUID != 0.

Likewise -- if $HOME/ksrc/ exists just use that ?

> Finally put ksrcs into .gitignore for not losing the source
> trees after a 'git clean'.
>
> Tested both as root and non-root, works fine.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Good stuff though thanks!

  Luis
