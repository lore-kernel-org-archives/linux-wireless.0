Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:22652 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZBCAPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 19:15:49 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1732101rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 16:15:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49878B8B.4020005@erley.org>
References: <49878B8B.4020005@erley.org>
Date: Tue, 3 Feb 2009 11:15:48 +1100
Message-ID: <646765f40902021615v521d0031y27885b56a74fd2f2@mail.gmail.com> (sfid-20090203_011553_070371_32750EC9)
Subject: Re: [patch] iw: align output for HT capabilities
From: Julian Calaby <julian.calaby@gmail.com>
To: pat-lkml <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 3, 2009 at 11:10, pat-lkml <pat-lkml@erley.org> wrote:
> The HT capabilities have an additional space in front of them causing
> them not to line up with the rest of the listed outputs.  This patch
> removes that space.
>
> Signed-off-by: Pat Erley <pat-lkml@erley.org>
>
> ---
>
> diff --git a/info.c b/info.c
> index bf3b8bd..69be500 100644
> --- a/info.c
> +++ b/info.c
> @@ -70,7 +70,7 @@ static int print_phy_handler(struct nl_msg *msg, void
> *arg)
>  #ifdef NL80211_BAND_ATTR_HT_CAPA
>                if (tb_band[NL80211_BAND_ATTR_HT_CAPA]) {
>                        unsigned short cap = nla_get_u16(tb_band[NL80211_BAND_ATTR_HT_CAPA]);
> -#define PCOM(fmt, args...) do { printf("\t\t\t * " fmt "\n", ##args); }
> while (0)
> +#define PCOM(fmt, args...) do { printf("\t\t\t* " fmt "\n", ##args); }
> while (0)

Is it just me or is this patch line-wrapped?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
