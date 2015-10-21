Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbbJUBHV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 21:07:21 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 03/16] rtl8xxxu: Don't check for illegal offset when reading from efuse
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
	<1445323546-12807-4-git-send-email-jsitnicki@gmail.com>
Date: Tue, 20 Oct 2015 21:07:19 -0400
In-Reply-To: <1445323546-12807-4-git-send-email-jsitnicki@gmail.com> (Jakub
	Sitnicki's message of "Tue, 20 Oct 2015 08:45:33 +0200")
Message-ID: <wrfjvba1vxko.fsf@redhat.com> (sfid-20151021_030735_891827_088658D7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> It is enough to check for either illegal offset or illegal map address
> because map address is a value derived from an offset:
>
>   map_addr = offset * 8
>   EFUSE_MAP_LEN_8723A = EFUSE_MAX_SECTION_8723A * 8
>
> Leave just the check for an illegal map address because its upper
> bound (EFUSE_MAP_LEN_8723A) is used also in a couple other places.
>
> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 63 +++++++++++-------------
>  1 file changed, 28 insertions(+), 35 deletions(-)

Applied - I had already changed EFUSE_MAP_LEN_8723A to EFUSE_MAP_LEN, so
I applied it with that minor modification.

Jes
