Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36230 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1JLDP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 23:15:59 -0400
Received: by iaek3 with SMTP id k3so300151iae.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 20:15:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <op.v27rulkhya27un@edmitar>
References: <op.v27rulkhya27un@edmitar>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 12 Oct 2011 14:15:39 +1100
Message-ID: <CAGRGNgVBMHP=2RB4VFGuXP-suLAgoi_CZFLnsKKt1MX335hUQA@mail.gmail.com> (sfid-20111012_051607_342453_06C9C63A)
Subject: Re: [RFC 02/07] compat-wireless: Connection quality monitor extensions
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Bartosz MARKOWSKI <bartosz.markowski@tieto.com>,
	Janusz DZIEDZIC <janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

Some minor comments on this patch:

Note that I'm not a maintainer and that these are comments on the
patch itself, not the code it adds.

That said, it's nice to see someone updating compat-wireless when they
update the main wireless repository.

On Wed, Oct 12, 2011 at 12:02, Dmitry Tarnyagin <abi.dmitryt@gmail.com> wrote:
> From: Bartosz Markowski <bartosz.markowski@tieto.com>
> Date: Tue, 12 Jul 2011 13:29:03 +0200
> Subject: [PATCH 2/7] compat-wireless: CQM STE extensions
>
> added:
> * beacon miss threshold - This value specifies the threshold
>  for the BEACON loss level
> * tx fail - This value specifies the threshold for the TX loss level
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
> ---
>  include/linux/compat-3.0.h |    2 +
>  include/linux/nl80211.h    |   16 +++++
>  include/net/cfg80211.h     |   34 ++++++++++
>  include/net/mac80211.h     |   41 ++++++++++++
>  net/mac80211/cfg.c         |   54 ++++++++++++++++
>  net/mac80211/mlme.c        |   23 ++++++-
>  net/wireless/mlme.c        |   25 +++++++
>  net/wireless/nl80211.c     |  152
> +++++++++++++++++++++++++++++++++++++++++++-
>  net/wireless/nl80211.h     |    9 +++

You are changing a lot of files that are not actually part of the
compat-wireless git repository - are you sure that this patch is
correct?

> diff --git a/include/linux/compat-3.0.h b/include/linux/compat-3.0.h
> index 8c8720e..961a3a6 100644
> --- a/include/linux/compat-3.0.h
> +++ b/include/linux/compat-3.0.h
> @@ -59,6 +59,7 @@ int __must_check kstrtos16_from_user(const char __user *s,
> size_t count, unsigne
>  int __must_check kstrtou8_from_user(const char __user *s, size_t count,
> unsigned int base, u8 *res);
>  int __must_check kstrtos8_from_user(const char __user *s, size_t count,
> unsigned int base, s8 *res);
>
> +/*
>  static inline int __must_check kstrtou64_from_user(const char __user *s,
> size_t count, unsigned int base, u64 *res)
>  {
>        return kstrtoull_from_user(s, count, base, res);
> @@ -78,6 +79,7 @@ static inline int __must_check kstrtos32_from_user(const
> char __user *s, size_t
>  {
>        return kstrtoint_from_user(s, count, base, res);
>  }
> +*/

Why are you commenting out this function?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
