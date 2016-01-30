Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:36207 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162AbcA3X42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 18:56:28 -0500
Received: by mail-qg0-f68.google.com with SMTP id 6so7778521qgy.3
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2016 15:56:28 -0800 (PST)
Date: Sat, 30 Jan 2016 18:56:13 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: Re: [PATCH v2 3/3] mac80211: Unify mesh and mpp path removal function
Message-ID: <20160130235613.GB1507@localhost> (sfid-20160131_005701_345553_6C4B3560)
References: <1454062138-18012-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1454062138-18012-4-git-send-email-henning.rogge@fkie.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454062138-18012-4-git-send-email-henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 29, 2016 at 11:08:58AM +0100, Henning Rogge wrote:
> @@ -951,37 +974,14 @@ enddel:
>   */
>  static int mpp_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
>  {
> -	struct mesh_table *tbl;
> -	struct mesh_path *mpath;
> -	struct mpath_node *node;
> -	struct hlist_head *bucket;
> -	int hash_idx;
> -	int err = 0;
> -
> -	/* flush relevant mpp entries first */
> -	mpp_flush_by_proxy(sdata, addr);
> -

Is it intentional that mpp_path_del no longer calls mpp_flush_by_proxy()
while mesh_path_del does?

-- 
Bob Copeland %% http://bobcopeland.com/
