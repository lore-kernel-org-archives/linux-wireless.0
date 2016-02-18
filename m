Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36652 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1425461AbcBRNkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 08:40:21 -0500
MIME-Version: 1.0
In-Reply-To: <1455798876-32186-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1455798876-32186-1-git-send-email-sudipm.mukherjee@gmail.com>
Date: Thu, 18 Feb 2016 14:40:20 +0100
Message-ID: <CACna6rztbZ5P4RborXrTdLJDEmQyGNOExNvAmWcxZG83stS2bg@mail.gmail.com> (sfid-20160218_144035_679685_F4943D07)
Subject: Re: [PATCH] b43: fix memory leak
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Network Development <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 February 2016 at 13:34, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> From: Sudip Mukherjee <sudip@vectorindia.org>
>
> On error we jumped to the label bcma_out and returned the error code but
> we missed freeing dev.

What if b43_one_core_attach fails? Won't we miss kfree then as well?
Shouldn't you simply improve error path and maybe use an additional
label? Also may we be missing a proper free in b43_bcma_remove as
well?

Your patch subject could also be a bit more descriptive (e.g. what
memory leak exactly is it).
