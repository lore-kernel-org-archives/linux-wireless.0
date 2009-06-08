Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:43576 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZFHGMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 02:12:30 -0400
Received: by gxk10 with SMTP id 10so1444902gxk.13
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 23:12:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A2CA986.3070500@gmail.com>
References: <4A2CA986.3070500@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 8 Jun 2009 16:12:12 +1000
Message-ID: <646765f40906072312y5043ac12rd6d756230e98b746@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: update for 2009-06-08
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 8, 2009 at 16:02, Julian Calaby<julian.calaby@gmail.com> wrote:
> Update to match wireless-testing v2.6.30-rc8-25759-g00f7164
>
> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
> ---
>  compat/compat.diff |   42 +++++++++++++++++++++++-------------------
>  1 files changed, 23 insertions(+), 19 deletions(-)
>
> diff --git a/compat/compat.diff b/compat/compat.diff
> index d89ea98..846e8f5 100644
> --- a/compat/compat.diff
> +++ b/compat/compat.diff
> @@ -181,6 +181,12 @@
>  obj-$(CONFIG_LIBERTAS)                += libertas/
>
>  obj-$(CONFIG_LIBERTAS_THINFIRM)       += libertas_tf/
> +@@ -60,5 +34,3 @@
> + obj-$(CONFIG_MAC80211_HWSIM)  += mac80211_hwsim.o
> +
> + obj-$(CONFIG_WL12XX)  += wl12xx/
> +-
> +-obj-$(CONFIG_IWM)     += iwmc3200wifi/

Sigh.

Of course, I forgot to describe the changes in this patch.

compat.diff has been updated to apply cleanly over the
wireless-testing.git version specified above with no fuzz.

iwmc3200wifi, as I don't know if it compiles on anything but
wireless-testing.git, has been disabled by editing it out of the
Makefile as it's directory isn't actually copied from
wireless-testing. -- I'm not sure that this is the correct way to do
this as it's hiding the problem away in compat.diff - not obviously
fixing it by, e.g. copying the directory from wireless-testing.git or
making it compile on older kernels.

I must note that even after these changes, this still doesn't actually
compile for me, as ath9k uses the rfkill_ops structure which isn't
present in my 2.6.29 kernel.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
