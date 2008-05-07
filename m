Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51991 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153AbYEGQDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 12:03:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 7/7][MAC80211]: Consolidate hash kfree-ing in mesh.c.
Date: Wed, 7 May 2008 18:03:10 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
References: <4821D157.90403@openvz.org>
In-Reply-To: <4821D157.90403@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805071803.11291.mb@bu3sch.de> (sfid-20080507_180244_483435_D438A1B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 07 May 2008 17:57:11 Pavel Emelyanov wrote:
> There are already two places, that kfree the mesh_table and
> its buckets.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
>  net/mac80211/mesh.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index f46fbdb..876ec18 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -315,6 +315,13 @@ struct mesh_table *mesh_table_alloc(int size_order)
>  	return newtbl;
>  }
>  
> +static void __mesh_table_free(struct mesh_table *tbl)

Why is this __double_underscored?

> +{
> +	kfree(tbl->hash_buckets);
> +	kfree(tbl->hashwlock);
> +	kfree(tbl);
> +}
> +
>  void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
>  {
>  	struct hlist_head *mesh_hash;
> @@ -330,9 +337,7 @@ void mesh_table_free(struct mesh_table *tbl, bool free_leafs)
>  		}
>  		spin_unlock(&tbl->hashwlock[i]);
>  	}
> -	kfree(tbl->hash_buckets);
> -	kfree(tbl->hashwlock);
> -	kfree(tbl);
> +	__mesh_table_free(tbl);
>  }
>  
>  static void ieee80211_mesh_path_timer(unsigned long data)
> @@ -378,9 +383,7 @@ errcopy:
>  		hlist_for_each_safe(p, q, &newtbl->hash_buckets[i])
>  			tbl->free_node(p, 0);
>  	}
> -	kfree(newtbl->hash_buckets);
> -	kfree(newtbl->hashwlock);
> -	kfree(newtbl);
> +	__mesh_table_free(tbl);
>  endgrow:
>  	return NULL;
>  }



-- 
Greetings Michael.
