Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:35314 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbbGBNsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 09:48:36 -0400
Received: by oihr66 with SMTP id r66so194898oih.2
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 06:48:36 -0700 (PDT)
Date: Thu, 2 Jul 2015 08:48:01 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Wei Zhong <wzhong@google.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: update CA rules for 5600 - 5650 mHz
Message-ID: <20150702134801.GA40677@ubuntu-hedt> (sfid-20150702_154841_198344_437F624C)
References: <CAHr=Vq=hJr6WUQgFXftMSG2zYgwtCXgoTaXBzRfM8-kQa2-K2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAHr=Vq=hJr6WUQgFXftMSG2zYgwtCXgoTaXBzRfM8-kQa2-K2w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 01, 2015 at 10:44:09PM -0700, Wei Zhong wrote:
> commit 2fef4cad8a1bd9cbbf178e59a1b3ca672b057095
> Author: Wei Zhong <wzhong@google.com>
> Date:   Wed Jul 1 22:39:09 2015 -0700
> 
>     wireless-regdb: update CA rules for 5600 - 5650 mHz
> 
>     Related regulation:
>     http://www.ic.gc.ca/eic/site/smt-gst.nsf/eng/sf10971.html#s6.2.3
> 
>     Frequency Bands 5470-5600 MHz and 5650-5725 MHz
>     Until further notice, devices subject to this section [i.e. Wifi device
>     supporting 5 GHz bands] shall not be capable of transmitting in the band
>     5600-5650 MHz. This restriction is for the protection of Environment
>     Canada’s weather radars operating in this band.

Thanks for the patch. There are a couple of issues though, plus a
question.

First, this project requires that you add a Signed-off-by tag to the
commit message to acknowledge your agreement to the Developer
Certificate of Origin. Please see the CONTRIBUTING file for more
information.

Second, the patch is not in the correct format. It looks like to me you
pasted the output from git-show, which resulted in mangled white space
and other issues. Please use git-format-patch to create the patch, then
send it using git-send-email or else send the patch as an attachment.

> diff --git a/db.txt b/db.txt
> index 809cd3c..da0cfad 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -216,7 +216,8 @@ country CA: DFS-FCC
>         (2402 - 2472 @ 40), (30)
>         (5170 - 5250 @ 80), (17), AUTO-BW
>         (5250 - 5330 @ 80), (24), DFS, AUTO-BW
> -       (5490 - 5730 @ 160), (24), DFS
> +       (5490 - 5600 @ 80), (24), DFS
> +       (5650 - 5730 @ 40), (24), DFS

Why isn't 80MHz channel bandwidth allowed in the 5650-5730 range?

Thanks,
Seth
