Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54913 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2A3LHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:07:19 -0500
Received: by dadi2 with SMTP id i2so3457512dad.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 03:07:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1327658573-477-2-git-send-email-helmut.schaa@googlemail.com>
References: <1327658573-477-1-git-send-email-helmut.schaa@googlemail.com>
	<1327658573-477-2-git-send-email-helmut.schaa@googlemail.com>
Date: Mon, 30 Jan 2012 12:07:19 +0100
Message-ID: <CAGXE3d_k4yGoC7JQbkAPTU9_ApY+3=-tkm7egP65JEe6bRgBfQ@mail.gmail.com> (sfid-20120130_120723_635912_5BCD8370)
Subject: Re: [PATCH 2/3] mac80211: Fix incorrect num_sta_ps decrement in ap_sta_ps_end
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 27, 2012 at 11:02 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> If the driver blocked this specific STA with the help of
> ieee80211_sta_block_awake we won't clear WLAN_STA_PS_STA later but
> still decrement num_sta_ps. Hence, the next data frame from this
> STA will trigger ap_sta_ps_end again and also decrement num_sta_ps
> again leading to an incorrect num_sta_ps counter.
>
> This can result in problems with powersaving clients not waking up
> from PS because the TIM calculation might be skipped due to the
> incorrect num_sta_ps counter.

John, I need to send a v2 for this since it introduces a warning:

net/mac80211/rx.c: In function ‘ap_sta_ps_end’:
net/mac80211/rx.c:1148:32: warning: unused variable ‘sdata’ [-Wunused-variable]

Helmut

> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>  net/mac80211/rx.c       |    1 -
>  net/mac80211/sta_info.c |    4 +++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 3567586..f89617a 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1147,7 +1147,6 @@ static void ap_sta_ps_end(struct sta_info *sta)
>  {
>        struct ieee80211_sub_if_data *sdata = sta->sdata;
>
> -       atomic_dec(&sdata->bss->num_sta_ps);
>
>  #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
>        printk(KERN_DEBUG "%s: STA %pM aid %d exits power save mode\n",
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 70a0de3..92b894c 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -1007,9 +1007,11 @@ EXPORT_SYMBOL(ieee80211_find_sta);
>  static void clear_sta_ps_flags(void *_sta)
>  {
>        struct sta_info *sta = _sta;
> +       struct ieee80211_sub_if_data *sdata = sta->sdata;
>
>        clear_sta_flag(sta, WLAN_STA_PS_DRIVER);
> -       clear_sta_flag(sta, WLAN_STA_PS_STA);
> +       if (test_and_clear_sta_flag(sta, WLAN_STA_PS_STA))
> +               atomic_dec(&sdata->bss->num_sta_ps);
>  }
>
>  /* powersave support code */
> --
> 1.7.7
>
