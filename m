Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:53660 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaF1Uyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 16:54:55 -0400
Received: by mail-ig0-f180.google.com with SMTP id h18so3088780igc.1
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 13:54:55 -0700 (PDT)
Date: Sat, 28 Jun 2014 16:54:52 -0400
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: mesh_plink: use get_unaligned_le16 instead
 of memcpy
Message-ID: <20140628205452.GB17825@localhost> (sfid-20140628_225458_604948_1161B8F2)
References: <1403987726-17576-1-git-send-email-me@bobcopeland.com>
 <1403987726-17576-2-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403987726-17576-2-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[+CC linux-wireless]
On Sat, Jun 28, 2014 at 04:35:26PM -0400, Bob Copeland wrote:
> Use get_unaligned_le16 to access llid/plid.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  net/mac80211/mesh_plink.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index c47194d..421ec06 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -1004,7 +1004,6 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
>  	enum ieee80211_self_protected_actioncode ftype;
>  	u32 changed = 0;
>  	u8 ie_len = elems->peering_len;
> -	__le16 _plid, _llid;
>  	u16 plid, llid = 0;
>  
>  	if (!elems->peering) {
> @@ -1039,13 +1038,10 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
>  	/* Note the lines below are correct, the llid in the frame is the plid
>  	 * from the point of view of this host.
>  	 */
> -	memcpy(&_plid, PLINK_GET_LLID(elems->peering), sizeof(__le16));
> -	plid = le16_to_cpu(_plid);
> +	plid = get_unaligned_le16(PLINK_GET_LLID(elems->peering));
>  	if (ftype == WLAN_SP_MESH_PEERING_CONFIRM ||
> -	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len == 8)) {
> -		memcpy(&_llid, PLINK_GET_PLID(elems->peering), sizeof(__le16));
> -		llid = le16_to_cpu(_llid);
> -	}
> +	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len == 8))
> +		llid = get_unaligned_le16(PLINK_GET_PLID(elems->peering));
>  
>  	/* WARNING: Only for sta pointer, is dropped & re-acquired */
>  	rcu_read_lock();
> -- 
> 2.0.0.rc2
> 

-- 
Bob Copeland %% www.bobcopeland.com
