Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33078 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646AbcBAAD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 19:03:56 -0500
MIME-Version: 1.0
In-Reply-To: <1454060944-11320-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1454060944-11320-1-git-send-email-sudipm.mukherjee@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 1 Feb 2016 11:03:35 +1100
Message-ID: <CAGRGNgXc9PtYY=hb8nNRt4T5YGm2vexcJ01Z1fCCcb=57WRZ3g@mail.gmail.com> (sfid-20160201_010455_022116_1B65B254)
Subject: Re: [PATCH] mac80211: fix memory leak
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sudip,

On Fri, Jan 29, 2016 at 8:49 PM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> On error we jumped to the error label and returned the error code but we
> missed releasing sinfo.
>
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

Should the From: and Signed-off-by: email addresses be the same?

> ---
>  net/mac80211/sta_info.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 6c198e6..36e75c4 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -561,6 +561,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
>         __cleanup_single_sta(sta);
>   out_err:
>         mutex_unlock(&local->sta_mtx);
> +       kfree(sinfo);
>         rcu_read_lock();
>         return err;
>  }

Looks sane to me. I must note that the bug this is fixing is only in
the mac80211-next tree.

Fixes: 5fe74014172d ("mac80211: avoid excessive stack usage in sta_info")
Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
