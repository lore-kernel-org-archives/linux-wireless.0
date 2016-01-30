Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f67.google.com ([209.85.192.67]:34085 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbcA3Xhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 18:37:48 -0500
Received: by mail-qg0-f67.google.com with SMTP id 94so7782590qgt.1
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2016 15:37:48 -0800 (PST)
Date: Sat, 30 Jan 2016 18:37:32 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: Re: [PATCH v2 3/3] mac80211: Unify mesh and mpp path removal function
Message-ID: <20160130233732.GA1507@localhost> (sfid-20160131_003751_954054_C4E0B6C2)
References: <1454062138-18012-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1454062138-18012-4-git-send-email-henning.rogge@fkie.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454062138-18012-4-git-send-email-henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 29, 2016 at 11:08:58AM +0100, Henning Rogge wrote:
> mpp_path_del() and mesh_path_del() are mostly the same function.
> Move common code into a new static function.
> 
> Signed-off-by: Henning Rogge <henning.rogge@fkie.fraunhofer.de>
> ---
>  net/mac80211/mesh_pathtbl.c | 110 ++++++++++++++++++++++----------------------
>  1 file changed, 55 insertions(+), 55 deletions(-)
> 
> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index 33bb1f25..86316ee 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -55,16 +55,20 @@ int mpp_paths_generation;
>  static DEFINE_RWLOCK(pathtbl_resize_lock);
>  
>  
> +static inline struct mesh_table *resize_dereference_paths(struct mesh_table *table)

0-day caught this -- the parameter should be "struct mesh_table __rcu *table"

You can install sparse, set CONFIG_SPARSE_RCU_POINTER=y and then check it
with something like:

        make C=2 M=net/mac80211

The code is ok but the annotation catches cases where a dereference
would happen without the right lock -- in this case pathtable resize
lock is held.

> +{
> +  return rcu_dereference_protected(table,
> +    lockdep_is_held(&pathtbl_resize_lock));
> +}
> +

Besides that though, something is wrong with whitespace throughout
the patch, looks like lots of 2-space indents instead of tabs.

Approach looks fine though.  I might've moved the resize lock into
table_path_del, but it doesn't really matter as I plan to replace
with rhashtable anyway.

-- 
Bob Copeland %% http://bobcopeland.com/
