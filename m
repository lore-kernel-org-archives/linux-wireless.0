Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:62596 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3BZVcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 16:32:04 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so2124158bkc.38
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2013 13:32:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361808057-17899-1-git-send-email-marco@cozybit.com>
References: <1361808057-17899-1-git-send-email-marco@cozybit.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 26 Feb 2013 13:31:41 -0800
Message-ID: <CAG6hwVOrwGTceDKK9t0QAFH9LDGuhZtJDQhQh38Mh2C+YepAtw@mail.gmail.com> (sfid-20130226_223208_282175_4202A299)
Subject: Re: [PATCHv3 1/3] mac80211: move mesh sync beacon handler into neighbour_update
To: Marco Porsch <marco@cozybit.com>
Cc: johannes@sipsolutions.net, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, sleffler@google.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marco,

On Mon, Feb 25, 2013 at 8:00 AM, Marco Porsch <marco@cozybit.com> wrote:
> Move the beacon handler into mesh_neighbour_update where the STA
> pointer is already available. This avoids additional overhead
> and simplifies the handler.
> The repositioning will also benefit mesh PS which uses T_r and
> the updated T_offset value.
>
> Check frame type before calling the handler. Rename it to better
> reflect its purpose.
>
> Signed-off-by: Marco Porsch <marco@cozybit.com>
> ---
>
> v3:
>         check frame type before rx_bcn handler (Johannes)
>
>  net/mac80211/ieee80211_i.h |    9 ++++-----
>  net/mac80211/mesh.c        |    7 +------
>  net/mac80211/mesh.h        |    4 +++-
>  net/mac80211/mesh_plink.c  |   38 ++++++++++++++++++++++++++++-------
>  net/mac80211/mesh_sync.c   |   47 +++++++++-----------------------------------
>  5 files changed, 48 insertions(+), 57 deletions(-)
>
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 388580a..631760f 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -529,11 +529,10 @@ struct ieee80211_if_ibss {
>   */
>  struct ieee802_11_elems;
>  struct ieee80211_mesh_sync_ops {
> -       void (*rx_bcn_presp)(struct ieee80211_sub_if_data *sdata,
> -                            u16 stype,
> -                            struct ieee80211_mgmt *mgmt,
> -                            struct ieee802_11_elems *elems,
> -                            struct ieee80211_rx_status *rx_status);
> +       void (*rx_bcn)(struct sta_info *sta,
> +                      struct ieee80211_mgmt *mgmt,
> +                      struct ieee802_11_elems *elems,
> +                      u64 t_r);

Why not continue to sync against probe responses?
mesh_neighbour_update() gets these as well.

-- 
Thomas
