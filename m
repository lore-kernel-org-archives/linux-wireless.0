Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47423 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab2IXA0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2012 20:26:49 -0400
Received: by vcbfo13 with SMTP id fo13so5717301vcb.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Sep 2012 17:26:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1348221722.1581.12.camel@x61.thuisdomein>
References: <1348221722.1581.12.camel@x61.thuisdomein>
Date: Mon, 24 Sep 2012 04:26:48 +0400
Message-ID: <CA++WF2Ny+RDLXoybrdVM6Vh21NOOE5M3aQr7VfzgYmy1YEvfbQ@mail.gmail.com> (sfid-20120924_022653_986469_FF888555)
Subject: Re: [PATCH] ipw2x00: silence GCC warning for unused variable 'dev'
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Paul,

On 21 September 2012 14:02, Paul Bolle <pebolle@tiscali.nl> wrote:
> Building the libipw component without CONFIG_LIBIPW_DEBUG set triggers this GCC
> warning:
>     drivers/net/wireless/ipw2x00/libipw_wx.c:526:21: warning: unused variable 'dev' [-Wunused-variable]
>
> The cause of this warning is that, without CONFIG_LIBIPW_DEBUG set,
> LIBIPW_DEBUG_WX compiles away. Fix it by substituting ieee->dev for (its
> equivalent) dev.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) I noticed this warning while building v3.6-rc6 on current Fedora 17,
> using Fedora's default config.
>
> 1) Compile tested only (by just compiling libipw_wx.o).
>
>  drivers/net/wireless/ipw2x00/libipw_wx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks fine, thanks.

Stanislav.
