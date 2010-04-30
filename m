Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40868 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520Ab0D3Xt7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 19:49:59 -0400
Received: by vws19 with SMTP id 19so593188vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Apr 2010 16:49:58 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org
Cc: yi.zhu@intel.com, Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: Re: [PATCH V2] mac80211: fix paged defragmentation
In-Reply-To: <1272668279-6065-1-git-send-email-abhijeet.kolekar@intel.com>
References: <1272668279-6065-1-git-send-email-abhijeet.kolekar@intel.com>
Date: Fri, 30 Apr 2010 19:49:52 -0400
Message-ID: <87hbmsa4bj.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 30 Apr 2010 15:57:59 -0700, Abhijeet Kolekar <abhijeet.kolekar@intel.com> wrote:
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 72efbd8..e7217e2 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1255,6 +1255,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
>  	if (skb_linearize(rx->skb))
>  		return RX_DROP_UNUSABLE;
>  
> +	hdr = (struct ieee80211_hdr *)rx->skb->data;
>  	seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
>  
It seems to me that this might deserve a comment describing exactly why
hdr needs to be set twice in one function. To the uninformed outsider
the code simply seems redundant. It's unclear semantics like this that
could cause nasty issues when someone goes back for housecleaning. Just
a thought.

- Ben
