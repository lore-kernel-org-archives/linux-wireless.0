Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:49922 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbYF1Gqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 02:46:36 -0400
Received: by ik-out-1112.google.com with SMTP id c28so302484ika.5
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2008 23:46:34 -0700 (PDT)
Message-ID: <f6ca9fed0806272346y2e8fde2cwa27a79ee83d0c0af@mail.gmail.com> (sfid-20080628_084707_495000_781A410B)
Date: Sat, 28 Jun 2008 08:46:33 +0200
From: drago01 <drago01@gmail.com>
To: "Tomas Winkler" <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/1] mac80211: don't accept WEP keys other than WEP40 and WEP104
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1214610613-6990-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214610613-6990-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 28, 2008 at 1:50 AM, Tomas Winkler <tomas.winkler@intel.com> wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>
> This patch makes mac80211 refuse a WEP key whose length is not WEP40 nor
> WEP104.
>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  include/net/mac80211.h |    9 +++++++++
>  net/mac80211/wext.c    |    7 +++++++
>  2 files changed, 16 insertions(+), 0 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 02c79e6..6a6c4bc 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -557,6 +557,15 @@ enum ieee80211_key_alg {
>        ALG_CCMP,
>  };
>
> +/**
> + * enum ieee80211_key_len - key length
> + * @WEP40: WEP 5 byte long key
> + * @WEP104: WEP 13 byte long key
> + */
> +enum ieee80211_key_len {
> +       LEN_WEP40 = 5,
> +       LEN_WEP104 = 13,
> +};

What about 0 ?
See http://marc.info/?l=linux-wireless&m=121458316301507&w=2
